//
//  SocketIOManager.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/06.
//

import Foundation
import SocketIO

class SocketIOManager {
 
    static let shared = SocketIOManager()
        
    //서버와 메시지를 주고 받기 위한 클래스
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    private init() {
        manager = SocketManager(socketURL: URL(string: "\(UserAPI.BASEURL)")!, config: [
            .forceWebsockets(true)
        ])
        
        //이벤트 3개(connect, disconnect, on SeSAC event)
        //연결
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            self.socket.emit("changesocketid", "myUID")
        }
        
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)}
        
        //이벤트 수신
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
