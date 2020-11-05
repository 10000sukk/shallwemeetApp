//
//  Parsing.swift
//  test1
//
//  Created by 김환석 on 2020/11/02.
//  Copyright © 2020 김환석. All rights reserved.
//

import Foundation

public struct BoardsParsing: Codable {
    let idx: Int
    let title: String
    let img1, img2, img3: String
    let tag1, tag2, tag3, location: String
    let numType: String
    let age: Int
    let gender, createdDate, updatedDate: String
    let user: UserParsing
    let check: Bool

    enum CodingKeys: String, CodingKey {
        case idx, title, img1, img2, img3, tag1, tag2, tag3, location
        case numType = "num_type"
        case age, gender, createdDate, updatedDate, user, check
    }
}

// MARK: - User
public struct UserParsing: Codable {
    let idx: Int
    let nickName, img, email, gender: String
    let age, location, kakaoID: String
    let point: Int

    enum CodingKeys: String, CodingKey {
        case idx, nickName, img, email, gender, age, location
        case kakaoID = "kakao_id"
        case point
    }
}
typealias BoardsParse = [BoardsParsing]



public struct CodeAndMessage: Codable{
    let code:Int
    let msg:String
    
    enum CodingKeys: String, CodingKey {
        case code, msg
    }
    
}


struct DetailBoardParsing: Codable {
    let idx: Int
    let title: String
    let img1, img2, img3: String
    let tag1, tag2, tag3, location: String
    let numType: String
    let age: Int
    let gender, createdDate, updatedDate: String
    let user: DetailBoaradUserParsing

    enum CodingKeys: String, CodingKey {
        case idx, title, img1, img2, img3, tag1, tag2, tag3, location
        case numType = "num_type"
        case age, gender, createdDate, updatedDate, user
    }
}

// MARK: - User
struct DetailBoaradUserParsing: Codable {
    let idx: Int
    let nickName, img, email, gender: String
    let age, location, kakaoID: String
    let point: Int

    enum CodingKeys: String, CodingKey {
        case idx, nickName, img, email, gender, age, location
        case kakaoID = "kakao_id"
        case point
    }
}
