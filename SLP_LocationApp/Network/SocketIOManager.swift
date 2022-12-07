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
        
        socket = manager.defaultSocket
        
        //이벤트 3개(connect, disconnect, chat)
        //연결
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            self.socket.emit("changesocketid", "myUID")
        }
        
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)}
        
        //이벤트 수신
        socket.on("chat") { dataArray, ack in
            print("CHAT RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let chat = data["text"] as! String
            let id = data["id"] as! String
            let createdAt = data["createdAt"] as! String
            
            print("CHECK >>>", chat, createdAt)
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["chat": chat, "id": id, "createdAt": createdAt])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
