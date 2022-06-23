//
//  SocketManager.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import SocketIO
import Foundation

class SocketIOManager : NSObject {
    static let shareInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "localhost:3000")!, config: [.log(false), .forcePolling(true)])
    var socket : SocketIOClient?
    override init(){
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket?.connect()
    }
    
    func closeConnection() {
        socket?.disconnect()
    }
}

