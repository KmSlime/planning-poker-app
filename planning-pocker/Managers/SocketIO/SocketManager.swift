//
//  SocketManager.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    public private(set) var socket: SocketIOClient?
    
    private var manager: SocketManager?
    private var isShowAlert: Bool = false
    private var isReconnecting: Bool = false
    static let socketURL = "http://localhost:3000"
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
        manager = SocketManager(socketURL: URL(string: SocketIOManager.socketURL)!, config: [.forceNew(true), .reconnects(true), .log(true), .forcePolling(true), .compress, .connectParams(["token": ""]), .path("/socket.io-client")])
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
    
    func createRoom(namegroup: String, avatar: String, listUser: [Int], type: Int, groupDefault: Int) { // 1 chieu //2 da chieu
        socket?.emit("create-room", ["namegroup": namegroup, "avatar": avatar, "listUser": listUser, "type": type, "groupDefault": groupDefault])
    }
    
    func stopShareLocation(messageId: Int, groupId: Int) { // Stop share location
        socket?.emit("stop-share-location",
                     [
                         "messageId": messageId,
                         "groupId": groupId
                     ])
    }
    
    func enterJoinRoomPrivate(ownerId: Int, memberId: Int) { // Create room private
        socket?.emit("join-private-room", ["ownerId": ownerId, "memberId": memberId])
    }
    
    func enterJoinRoomSecret(ownerId: Int, memberId: Int) { // Create room private
        socket?.emit("join-secret-room", ["ownerId": ownerId, "memberId": memberId])
    }
    
    func enterJoinRoom(roomId: Int, type: String) { // Join room type group / private
        guard let socket = self.socket else { return }
        let socketConnectionStatus = socket.status
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            socket.emit("join-room", ["roomId": roomId, "type": type])
        
        case SocketIOStatus.connecting:
            let messageDictionary = [String: Any]()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorNotification"), object: nil, userInfo: messageDictionary)
            socket.disconnect()
            self.connectSocket(completionHandler: { statusInfo in
                if statusInfo == "1" {
                    socket.emit("join-room", ["roomId": roomId, "type": type])
                }
            })
        case SocketIOStatus.disconnected:
            self.connectSocket(completionHandler: { statusInfo in
                if statusInfo == "1" {
                    socket.emit("join-room", ["roomId": roomId, "type": type])
                }
            })
        case SocketIOStatus.notConnected:
            self.connectSocket(completionHandler: { statusInfo in
                if statusInfo == "1" {
                    socket.emit("join-room", ["roomId": roomId, "type": type])
                }
            })
        }
    }
    
    func removeUserGroup(roomId: Int, userId: Int) { // remove user group
        socket?.emit("delete-useringroup", ["roomId": roomId, "userId": userId])
    }
    
    func leaveGroup(roomId: Int) { // leave group
        socket?.emit("delete-useringroup", ["roomId": roomId, "userId": ""])
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
        guard _socket.status != .connected else { return }
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
