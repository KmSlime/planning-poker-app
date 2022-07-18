//
//  SocketManager.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import SocketIO
import Foundation
import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    public private(set) var socket: SocketIOClient?
    
    private var manager: SocketManager?
    private var isShowAlert: Bool = false
    private var isReconnecting: Bool = false
    private let socketIsNilMessage: String = "Socket is nil"
    
    override init() {
        super.init()
        self.initSocket()
    }

    var socketStatus: SocketIOStatus {
        guard let _socket = socket else { return .notConnected }
        return _socket.status
    }

    func initSocket(isRequestConnect: Bool = false) {
        self.closeConnection()
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceNew(true), .reconnects(true), .log(false), .forcePolling(true), .compress, .connectParams(["token": ""])])
        socket = manager?.defaultSocket
        if isRequestConnect {
            self.connectSocket { status in
                print("initSocket \(status)")
            }
        }
        self.establishConnection(completionHandler: { messageInfo in
            print("connectSocket with messageInfo \(messageInfo)")
//            if let userId = messageInfo["userId"] as? Int, userId == AuthenticationService.shared.currentUserID {
//                Log(userId)
//            } else{
//                let messageDictionary = [String: Any]()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorNotification"), object: nil,userInfo: messageDictionary)
//            }
        })
    }

    func closeConnection() {
        socket?.disconnect()
        socket = nil
        manager = nil
    }

    func reConnection() {
        self.isReconnecting = true
        socket?.disconnect()
        self.connectSocket(completionHandler: { statusInfo in
            print("reConnection: \(statusInfo)")
        })
    }

    func establishConnection(statusCode: Int = 0, completionHandler: @escaping (_ messageInfo: [String: Any]) -> Void) {
        guard let _socket = socket else {
            completionHandler(["MessageError": socketIsNilMessage])
            return
        }
        _socket.on("connect-success") { dataArray, socketAck in
            print("connect-success")
            let dataValue: [String: Any] = dataArray[0] as? [String: Any] ?? [:]

            if UserStore.GetChangeStatusWifi() {
                UserStore.setChangeStatusWifi(value: false)

                let arrStoreOffline = UserStore.getMessageOffline()
                var statusSend = false
                for item in arrStoreOffline {
                    if let keyValue = item["key_load_message"] as? String, keyValue != "" {
                        statusSend = true
                        break
                    }
                }

                if statusSend {
                    #if ContainerMessage
                    self.sendMessageOffline()
                    #else
                    #endif
                }
            }
            if UserStore.getShouldGetHistoryList() {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kGetHistoryListRESTFUL), object: nil, userInfo: nil)
            }
            completionHandler(dataValue)
        }
        _socket.on("connect-fail") { [weak self] dataArray, socketAck in
            completionHandler([:])
            guard let self = self else { return }
            self.reConnection()
        }

        _socket.onAny { item in
            print(item)
        }
        
        _socket.on("start-game") { [weak self] data, ack in
            guard let data = data[0] as? String else {
                print("Start game fail")
                return
            }
            let json = data.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: json) as? Dictionary<String,Any>
                {
                    let roomName: String = jsonArray["roomName"]! as! String
                    let roomUrl: String = jsonArray["roomUrl"]! as! String
                    let userId: String = jsonArray["userId"]! as! String
                    let cards: [String] = jsonArray["cardData"]! as! [String]
                    let issueTitle: String = jsonArray["currentIssueTitle"]! as! String
                    let userName: String = jsonArray["userName"]! as! String
                    let player = PlayerModel(id: userId, name: userName, roomUrl: roomUrl, role: PlayerRole.host)
                    let newRoom = RoomModel(roomName: roomName, roomUrl: roomUrl, cards: cards, mainPlayer: player, otherPlayers: [])
                    newRoom.currentIssue = issueTitle
                    let newGame = GameModel(id: 1, name: roomName, url: roomUrl)
                    AppViewController.shared.pushToChooseCardScreen(newRoomModel: newRoom, gameInfo: newGame)
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        _socket.on("notification-change") { data, ack in
            self.socket?.emit("reload-room", [])
        }
        
        _socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else { return }
            self.isReconnecting = false
            print("Socket connected")
        }

        _socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("socket disconnect")
            guard let self = self,
                  UIApplication.shared.applicationState == .active,
                  !self.isReconnecting else { return }
            self.isReconnecting = true
            self.reConnection()
        }

        _socket.on(clientEvent: .reconnectAttempt) { [weak self] data, ack in
            print("======App: reconnectAttempt")
            UserStore.setChangeStatusWifi(value: true)
            UserStore.setShouldGetHistoryList(value: true)
        }

        #if ContainerMessage
        self.listenForOtherMessages()
        #else
        #endif
    }
    
    // TODO: Handle create room (Create, Join)
    // 1. Emit room data when CreateRoom button selected
    func createRoom(roomName: String, roomUrl: String, userId: Int, cardData: [String], userName: String) { // 1 chieu //2 da chieu
        let dic : [String: Any] = [
            "roomName" : roomName,
            "roomUrl" : roomUrl,
            "userId" : String(userId),
            "cardData" : cardData,
            "userName": userName
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        socket?.emit("create-room", jsonData!)
    }
    // 2. Emit user data when JoinRoom button selected
    func enterJoinRoom(roomId: String, userId: Int, userName: String) { // Join room type group / private
        guard let socket = self.socket else { return }
        let socketConnectionStatus = socket.status
        let dic : [String: Any] = [
            "roomUrl" : roomId,
            "userId" : String(userId),
            "userName" : userName
        ]
        
            let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                socket.emit("join-room", jsonData!)

            case SocketIOStatus.connecting:
                let messageDictionary = [String: Any]()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorNotification"), object: nil, userInfo: messageDictionary)
                socket.disconnect()
                self.connectSocket(completionHandler: { statusInfo in
                    if statusInfo == "1" {
                        socket.emit("join-room", jsonData!)
                    }
                })
            case SocketIOStatus.disconnected:
                self.connectSocket(completionHandler: { statusInfo in
                    if statusInfo == "1" {
                        socket.emit("join-room", jsonData!)
                    }
                })
            case SocketIOStatus.notConnected:
                self.connectSocket(completionHandler: { statusInfo in
                    if statusInfo == "1" {
                        socket.emit("join-room", jsonData!)
                    }
                })
            }
    }
    // 3. Get error when url of room is invalid
    func unknownUrl(completionHandler: @escaping () -> Void) {
        socket?.on("unknown-code"){ (dataArray, ack) in
            completionHandler()
        }
    }
    // 4. When start game successfully, update otherPlayerCollectionView for all clients
    func updateOtherPlayers(completionHandler: @escaping (_ users:  Dictionary<String , String>) -> Void){
        socket?.on("update-player"){ (dataArray, ack) in
            print("xxx")
            guard let data = dataArray[0] as? String else {
                print("update-player fail")
                return
            }
            let json = data.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: json) as? [Dictionary<String,Any>] {
                    var listUserIds : Dictionary<String , String> = [:]
                    for item in jsonArray {
                        let userId: String = item["userId"]! as! String
                        let userName: String = item["userName"]! as! String
                        listUserIds[userId] = userName
                    }
                    completionHandler(listUserIds)
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    // TODO: Handle issue
    // 1. Get issue title when push to ChooseCard
    func updateIssue(completionHandler: @escaping (_ issueTitle: String) -> Void) {
        socket?.on("update-issue"){ (dataArray, ack) in
            guard let data = dataArray[0] as? String else {
                print("update-issue fail")
                return
            }
            let json = data.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: json) as? Dictionary<String,Any> {
                    let issueTitle: String = jsonArray["issueTitle"]! as! String
                    completionHandler(issueTitle)
                }
            } catch {
                print(error)
            }
            
        }
    }
    // 2. Emit issue when vote issue
    func voteIssue(issueTitle: String, issueId: Int) {
        let dic: [String: Any] = ["issueTitle": issueTitle, "issueId": issueId]
        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        socket?.emit("vote-issue", jsonData!)
    }
    // 3. Emit disable issue when reverse issue status to false
    func disableVote() {
        socket?.emit("disable-vote", [])
    }
    // 4. Get no issue notification on ChooseCard when there is no issue voted
    func issueDisabled(completionHandler: @escaping () -> Void) {
        socket?.on("issue-disabled"){ (dataArray, ack) in
            completionHandler()
        }
    }
    
    // TODO: Handle choose card
    // 1. Emit card selected
    func selectCard(userId: String, selectedIndex: String) {
        let dic: [String: Any] = ["selectedIndex": selectedIndex, "userId" : userId]
        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        socket?.emit("select-card", jsonData!)
    }
    // 2. Emit card disable select
    func removeCard(userId: String) {
        let dic: [String: Any] = ["userId" : userId]
        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        socket?.emit("remove-card", jsonData!)
    }
    // 3. Get card seleted to notify all player in room
    func updateCard(completionHandler: @escaping (_ userId: String, _ selectCardValue: String) -> Void) {
        socket?.on("update-card"){ (dataArray, ack) in
            guard let data = dataArray[0] as? String else {
                print("update-card fail")
                return
            }
            let json = data.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: json) as? Dictionary<String,Any> {
                    let userId: String = jsonArray["userId"]! as! String
                    let selectCardValue: String = jsonArray["cardSelectedIndex"]! as! String
                    completionHandler(userId, selectCardValue)
                }
            } catch {
                print(error)
            }
            
        }
    }
    // 4. Get card unselected by one user for all in room
    func updateCardRemoved(completionHandler: @escaping (_ userId: String) -> Void) {
        socket?.on("update-card-removed"){ (dataArray, ack) in
            guard let data = dataArray[0] as? String else {
                print("updated-card-removed fail")
                return
            }
            let json = data.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: json) as? Dictionary<String,Any> {
                    let userId: String = jsonArray["userId"]! as! String
                    completionHandler(userId)
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    // TODO: Handle reveal card
    // 1. Emit data when click reveal card
    func revealCard() {
        let dic: [String: Any] = ["isRevealCard": true]
        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        socket?.emit("reveal-card", jsonData!)
    }
    // 2. Card selected then no allowed to choose card
    func lockSelectCard(completionHandler: @escaping (_ isLock: Bool) -> Void) {
        socket?.on("lock-select-card"){ (dataArray, ack) in
            completionHandler(true)
        }
    }
    // 3. When reveal button is pressed, notify count down 3s to all clients
    func showCountDown(completionHandler: @escaping () -> Void) {
        socket?.on("show-countdown"){ (dataArray, ack) in
            completionHandler()
        }
    }
    // 4. Get result
    func getResult(completionHandler: @escaping (_ averagePoint: String, _ selectedCardsSort: Dictionary<String, Int>) -> Void) {
        socket?.on("get-result"){ (dataArray, ack) in
            guard let data = dataArray[0] as? String else {
                print("updated-card-removed fail")
                return
            }
            let json = data.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: json) as? Dictionary<String,Any> {
                    let averagePoint: String = jsonArray["averagePoint"]! as! String
                    let selectedCardsSort: Dictionary<String, Int> = jsonArray["selectedCardsSort"]! as! Dictionary<String, Int>
                    completionHandler(averagePoint, selectedCardsSort)
                }
            } catch {
                print(error)
            }
            
        }
    }
    // 5. Show result
    func showResult() {
        socket?.emit("show-result", [])
    }
    
    // Test
    func test() {
        socket?.emit("/topic/greetings", [])
    }

    func stopShareLocation(messageId: Int, groupId: Int) { // Stop share location
        socket?.emit("stop-share-location", ["messageId": messageId, "groupId": groupId ])
    }

    func enterJoinRoomPrivate(ownerId: Int, memberId: Int) { // Create room private
        socket?.emit("join-private-room", ["ownerId": ownerId, "memberId": memberId])
    }

    func enterJoinRoomSecret(ownerId: Int, memberId: Int) { // Create room private
        socket?.emit("join-secret-room", ["ownerId": ownerId, "memberId": memberId])
    }

    func removeUserGroup(roomId: Int, userId: Int) { // remove user group
        socket?.emit("delete-useringroup", ["roomUrl": roomId, "userId": userId])
    }

    func leaveGroup(roomId: Int) { // leave group
        socket?.emit("delete-useringroup", ["roomUrl": roomId, "userId": ""])
    }

    func deleteConversation(threadId: Int, type: String) { // delete private
        socket?.emit("delete-conversation", ["threadId": threadId, "type": type])
    }

    func setStatusMessage(groupId: Int) { ////set user status message read
        socket?.emit("setstatus-message", ["groupId": groupId])
    }

    func addUserToGroup(groupId: Int, listUser: [Int] = []) { /// Add list user to Group
        socket?.emit("adduser-togroup", ["userId": listUser, "groupId": groupId])
    }

    func updateInfoGroup(avatar: String, groupId: Int, namegroup: String) { // update info group
        socket?.emit("update-group", ["avatar": avatar, "groupId": groupId, "namegroup": namegroup])
    }

    func blockUnblockNotifyGroup(groupId: Int, type: Int) { // block = 0 or unblock  = 1 notify group
        if type == 0 {
            socket?.emit("block-notify-group", ["groupId": groupId])
        } else {
            socket?.emit("unblock-notify-group", ["groupId": groupId])
        }
    }

    func deleteMessage(messageId: Int, condDelete: Int) { // condDelete = 1 delete one , 2 delete 2
        socket?.emit("delete-message", ["messageId": messageId, "condDelete": condDelete])
    }

    func deleteSecret(messageId: Int) {
        socket?.emit("delete-secret", ["messageId": messageId])
    }

    func checkOnline(userId: Int, completionHandler: @escaping (_ statusOnline: Bool) -> Void) {
        socket?.emitWithAck("check-online", ["userId": userId]).timingOut(after: 60, callback: { dataArray in
            let data = dataArray[0] as? [String: Any] ?? [:]
            if let status = data["online"] as? Int, status == 1 {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }

    func acceptJoinRoom(groupId: Int) {
        socket?.emit("accept-joinroom", ["groupId": groupId, "valueRequest": 1])
    }

    func removeJoinRoom(groupId: Int) {
        socket?.emit("remove-joinroom", ["groupId": groupId, "valueRequest": -1])
    }

    func getTimeOnline(userId: Int) {
        socket?.emit("get-time-online", ["userId": userId])
    }

    func updateBackground(groupId: Int, background: String, side: Int) { // side 2 change all
        socket?.emit("update-background", ["groupId": groupId, "background": background, "side": side])
    }

    func resendRequestJoin(groupId: Int, userId: Int) {
        socket?.emit("resend-requestjoin", ["groupId": groupId, "userId": userId])
    }

    func addUserGroupToAdmin(groupId: Int, listUser: [Int] = []) {
        socket?.emit("addusergroup-toadmin", ["userId": listUser, "groupId": groupId])
    }

    func deleteUserAdminInGroup(groupId: Int, userId: Int) {
        socket?.emit("deleteuseradmin-ingroup", ["userId": userId, "groupId": groupId])
    }

    func countInvite() {
        socket?.emit("count-invite")
    }

    func countMessage() {
        socket?.emit("count-message")
    }

    func setCountCall() {
        socket?.emit("set-count-call")
    }

    func forwardMessage(messageId: Int, arrUser: [Int] = [], arrGroupDefault: [Int] = [], arrGroup: [Int] = [], element: [String: Any]? = nil) {
        if (element?.isEmpty)! {
            socket?.emit("forward-message", ["arrUser": arrUser, "arrGroupDefault": arrGroupDefault, "arrGroup": arrGroup, "messageId": messageId])
        } else {
            socket?.emit("forward-message", ["arrUser": arrUser, "arrGroupDefault": arrGroupDefault, "arrGroup": arrGroup, "messageId": messageId, "element": element ?? [String: Any]()])
        }
    }

    func setMessageEmoji(messageId: Int, emojiId: Int) {
        socket?.emit("set-message-emojiId", ["value": 1, "emoijId": emojiId, "messageId": messageId])
    }

    func updateAvatarSecret(userId: Int, avatar: String = "", threadId: Int, alias_secret: String = "") {
        if avatar != "" {
            socket?.emit("update-data-secret", ["userId": userId, "avatar": avatar, "threadId": threadId])
        }
        if alias_secret != "" {
            socket?.emit("update-data-secret", ["userId": userId, "threadId": threadId, "alias_secret": alias_secret])
        }
    }

    func groupCallInit(groupId: Int, arrUser: [Int], isAudio: Bool = false) {
        socket?.emit("group-call-init", ["groupId": groupId, "arrUser": arrUser, "isAudio": isAudio])
    }

    func joinOnGroup(groupTime: String) { // Call when event on-group receive
        socket?.emit("join-on-group", ["groupTime": groupTime])
    }

    func acceptCall(groupId: Int, isAudio: Bool = false, groupTime: String) {
        socket?.emit("accept-call", ["groupId": groupId, "isAudio": isAudio, "groupTime": groupTime])
    }

    func cancelCall(groupId: Int, isAudio: Bool = false, groupTime: String) {
        socket?.emit("cancel-call", ["groupId": groupId, "isAudio": isAudio, "groupTime": groupTime])
    }

    func userCallCancel(groupId: Int, arrUser: [Int], isAudio: Bool = false) {
        socket?.emit("usercall-cancel", ["groupId": groupId, "arrUser": arrUser, "isAudio": isAudio])
    }

    func leaveCall(groupId: Int, isAudio: Bool = false, groupTime: String) {
        socket?.emit("leave-call", ["groupId": groupId, "isAudio": isAudio, "groupTime": groupTime])
    }

    func missCall(groupId: Int, arrUser: [Int], isAudio: Bool = false) {
        socket?.emit("miss-call", ["groupId": groupId, "arrUser": arrUser, "isAudio": isAudio])
    }

    func joinCall(groupId: Int, arrUser: [Int], isAudio: Bool = false) {
        socket?.emit("join-call", ["groupId": groupId, "arrUser": arrUser, "isAudio": isAudio])
    }

    func statusCamera(groupId: Int, camera: String, groupTime: String, arrUser: [Int]) {
        socket?.emit("status-camera", ["groupId": groupId, "groupTime": groupTime, "camera": camera, "arrUser": arrUser])
    }

    func swapCamera(groupId: Int, camera: String, groupTime: String, arrUser: [Int]) {
        // swapCameraToFront swapCameraToBack
        socket?.emit("swap-camera", ["groupId": groupId, "groupTime": groupTime, "camera": camera, "arrUser": arrUser])
    }

    func countCall() {
        socket?.emit("count-call")
    }

    func setNameConversation(messageId: Int, groupId: Int, name: String) {
        socket?.emit("set-name-conversation", ["messageId": messageId, "groupId": groupId, "name": name])
    }

    func deleteSetNameConversation(messageId: Int, groupId: Int) {
        socket?.emit("delete-setname-conversation", ["messageId": messageId, "groupId": groupId])
    }

    func deleteImageInMulti(messageId: Int, linkImage: String) {
        socket?.emit("delete-image-inmulti", ["id": messageId, "linkImage": linkImage])
    }

    func connectSocket(completionHandler: @escaping (_ status: String) -> Void) {
        // check login or not
//        guard AuthenticationService.shared.authenticated else {
//            self.closeConnection()
//            return
//        }
        guard let _socket = socket else {
            self.initSocket(isRequestConnect: true)
            return
        }
        guard _socket.status != .connected else {
            return }
        _socket.connect()
    }

    func checkSocketConnection() -> Bool {
        guard let _socket = socket else { return false }
        switch _socket.status {
        case SocketIOStatus.connected:
            return true
        default:
            return false
        }
    }

    func listenForOtherMessages() {
        guard let socket = self.socket else { return }
        socket.onAny { item in
            //            print("==========",item.event)
            //            Log(item.event)
        }
        socket.on("createRoomSuccess") { dataArray, ack in
            let data = dataArray[0] as? [String: Any] ?? [:]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createRoomSuccessNotification"), object: nil, userInfo: data)
        }

        socket.on("new-message") { dataArray, socketAck in
            //            Log("new-message ")
            //              Log("new-message \(dataArray)")
//            var messageDictionary = [String: Any]()
//            messageDictionary = dataArray[0] as! [String:Any]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new-messageNotification"), object: nil,userInfo: messageDictionary)
//            //check Local
//            DispatchQueue.main.async {
//                let newsData = ListMessage(dictionary: messageDictionary as NSDictionary)
//                //                Log("new-message with message text : \(newsData?.text)")
//                let arrStoreOffline = UserStore.getMessageOffline()
//                print("new-message with message text : \(newsData?.text) with arrStoreOffline count \(arrStoreOffline.count)")
//                if let i = arrStoreOffline.index(where: { $0["key_load_message"] as? String == newsData?.key_load_message}) {
//                    if UserStore.setMessageOffline_removeAtIndex(indexValue:i){
//                        print("remove local list")
//                    }
//                    print("new-chat-message sendMessageOffline")
//                    //todo
//                }
//            }

            // self.pushLocal_message(type: "new-chat-message", userInfo: messageDictionary)
        }

        socket.on("join-room-private") { dataArray, socketAck in ////Success Create room private
            var messageDictionary = [String: Any]()
            messageDictionary = dataArray[0] as? [String: Any] ?? [:]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "join-room-privateNotification"), object: nil, userInfo: messageDictionary)
        }

        socket.on("join-business-private") { dataArray, socketAck in ////Success Create room private
            var messageDictionary = [String: Any]()
            messageDictionary = dataArray[0] as? [String: Any] ?? [:]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "join-room-privateNotification"), object: nil, userInfo: messageDictionary)
        }

        socket.on("join-secret-private") { dataArray, socketAck in ////Success Create room private secret
            var messageDictionary = [String: Any]()
            messageDictionary = dataArray[0] as? [String: Any] ?? [:]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "join-secret-privateNotification"), object: nil, userInfo: messageDictionary)
        }

        socket.on("invited-room") { dataArray, socketAck in ////invite user join room private
            var messageDictionary = [String: Any]()
            messageDictionary = dataArray[0] as? [String: Any] ?? [:]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "invited-roomNotification"), object: nil, userInfo: messageDictionary)
        }
    }

    private func getCurrentViewController() -> UIViewController? {
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            return navigationController.visibleViewController
        }

        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController

            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while currentController.presentedViewController != nil {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }

    private func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController {
            return navigationController as? UINavigationController
        }
        return nil
    }
}
