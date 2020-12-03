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
    let tag1, tag2, tag3, location1, location2: String
    let numType: String
    let age: Int
    let gender, createdDate, updatedDate, date: String
    let user: UserParsing
    let check: Bool

    enum CodingKeys: String, CodingKey {
        case idx, title, img1, img2, img3, tag1, tag2, tag3, location1, location2
        case numType = "num_type"
        case age, gender, createdDate, updatedDate, user, check, date
    }
}

// MARK: - User
public struct UserParsing: Codable {
    let idx: Int
    let nickName, img, email, gender: String
    let age, location1, location2, kakaoID: String
    let point: Int

    enum CodingKeys: String, CodingKey {
        case idx, nickName, img, email, gender, age, location1, location2
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
    let tag1, tag2, tag3, location1, location2: String
    let numType: String
    let age: Int
    let gender, createdDate, updatedDate, date: String
    let user: DetailBoaradUserParsing
    let check:Bool

    enum CodingKeys: String, CodingKey {
        case idx, title, img1, img2, img3, tag1, tag2, tag3, location1, location2
        case numType = "num_type"
        case age, gender, createdDate, updatedDate, user,check, date
    }
}

// MARK: - User
struct DetailBoaradUserParsing: Codable {
    let idx: Int
    let nickName, img, email, gender: String
    let age, location1, location2, kakaoID: String
    let point: Int

    enum CodingKeys: String, CodingKey {
        case idx, nickName, img, email, gender, age, location1, location2
        case kakaoID = "kakao_id"
        case point
    }
}


struct FavoriteBoardListParsing: Codable {
    let idx: Int
    let user: UserParsing
    let board: BoardWithoutCheckParsing
}

struct BoardWithoutCheckParsing: Codable {
    let idx: Int
    let title: String
    let img1, img2, img3: String
    let tag1, tag2, tag3, location1: String
    let location2, numType: String
    let age: Int
    let gender, createdDate, updatedDate, date: String
    let user: UserParsing

    enum CodingKeys: String, CodingKey {
        case idx, title, img1, img2, img3, tag1, tag2, tag3, location1, location2
        case numType = "num_type"
        case age, gender, createdDate, updatedDate, user, date
    }
}
//찜목록을 위한 파싱
typealias FavoriteParse = [FavoriteBoardListParsing]


//따끈따끈한 미팅을 위한 파싱
typealias LatestMeetingListParsing = [BoardWithoutCheckParsing]



//my list 에 내 게시판과 그에 따른 sender 목록을 보여주기 위한 parsing

//MY List 를 구성하는 페이지에 대한 파싱목록
//보낸요청
struct SendRequestParsing: Codable {
    let date: String
    let matched: [Matched]
}

// MARK: - Matched
struct Matched: Codable {
    let idx: Int
    let sender: Sender
    let board: BoardWithoutCheckParsing
    let status: Bool
    let createdTime: String
    let matched: Bool

    enum CodingKeys: String, CodingKey {
        case idx, sender, board, status, createdTime
        case matched = "_matched"
    }
}

struct Sender: Codable {
    let idx: Int
    let nickName: String
    let img: String
    let email: String
    let gender: String
    let age: String
    let location1: String
    let location2: String
    let kakaoID: String
    let point: Int
    let token: String
    let jwt: String

    enum CodingKeys: String, CodingKey {
        case idx, nickName, img, email, gender, age, location1, location2
        case kakaoID = "kakao_id"
        case point, token, jwt
    }
}

typealias SendRequestParse = [SendRequestParsing]


//받은 요청
struct RecievedRequestParsing: Codable {
    let idx: Int
    let title: String
    let img1, img2, img3: String
    let tag1, tag2, tag3: String
    let location1: String
    let location2, numType: String
    let age: Int
    let gender: String
    let date, createdDate, updatedDate: String
    let senders: [SenderAboutMyRoom]

    enum CodingKeys: String, CodingKey {
        case idx, title, img1, img2, img3, tag1, tag2, tag3, location1, location2
        case numType = "num_type"
        case age, gender, date, createdDate, updatedDate, senders
    }
}

struct SenderAboutMyRoom: Codable {
    let idx: Int
    let nickName: String
    let img: String
    let email, gender, age: String
    let location1: String
    let location2, kakaoID: String
    let point: Int
    let token, jwt: String
    let status: Bool
    let createdTime: String
    let matched: Bool

    enum CodingKeys: String, CodingKey {
        case idx, nickName, img, email, gender, age, location1, location2
        case kakaoID = "kakao_id"
        case point, token, jwt, status, createdTime
        case matched = "_matched"
    }
}

typealias RecievedRequestParse = [RecievedRequestParsing]











//매칭된 리스트
struct MatchedListParsing: Codable {
    let isSenders: [MatchingParsing]
    let isMakers: [MatchingParsing]

    enum CodingKeys: String, CodingKey {
        case isSenders = "is_senders"
        case isMakers = "is_makers"
    }
}
struct MatchingParsing: Codable {
    let idx: Int
    let sender: UserParsing
    let board: BoardWithoutCheckParsing
    let status: Bool
    let createdTime: String
    let matched: Bool

    enum CodingKeys: String, CodingKey {
        case idx, sender, board, status, createdTime
        case matched = "_matched"
    }
}

