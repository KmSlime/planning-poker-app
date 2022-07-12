//
//  Game.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 08/07/2022.
//

struct Game: Codable {
//    enum CodingKeys: String, CodingKey {
//        case roomName, roomId, userId
//    }
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(roomName, forKey: .roomName)
//        try container.encode(roomId, forKey: .roomId)
//        try container.encode(userId, forKey: .userId)
//    }
    var roomName: String
    var roomId: String
    var userId: String
}

//extension Game: Decodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        roomName = try container.decode(String.self, forKey: .roomName)
//        roomId = try container.decode(String.self, forKey: .roomId)
//        userId = try container.decode(String.self, forKey: .userId)
//    }
//}
