//
//  DataDef.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/11/15.
//

import Foundation

struct ChatMessage: Decodable {
    let chatTime: String
    let text: String
    let type: Int
}

struct FriendInfo: Decodable {
    let avatarUrl: String?
    let nickName: String
    let noteName: String?
    let userId: String
    let messages: [ChatMessage]
    
    func displayName() -> String {
        return self.noteName ?? self.nickName;
    }
}

struct ChatCellModel: Decodable, Identifiable {
    var id: String
    let friendInfo: FriendInfo
    var unreadCount: Int
}

struct ChatListResponse: Decodable {
    let code: Int
    let data: [ChatCellModel]
}
