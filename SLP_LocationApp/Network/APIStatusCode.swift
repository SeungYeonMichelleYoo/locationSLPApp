//
//  APIStatusCode.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//

import Foundation

enum APIStatusCode: Int {
    case success = 200
    case option = 201
    case forbiddenNickname = 202
    case firebaseTokenError = 401
    case unAuthorized = 406
    case serverError = 500
    case clientError = 501
}

//SearchVC
enum APIQueueStatusCode: Int {
    case success = 200
    case forbiddenUse = 201
    case cancelPanlty1 = 203
    case cancelPanlty2 = 204
    case cancelPanlty3 = 205
    case firebaseTokenError = 401
    case unAuthorized = 406
    case serverError = 500
    case clientError = 501
}

//FindTotalVC - stop study
enum APIStopStudyStatusCode: Int {
    case success = 200
    case matched = 201
    case firebaseTokenError = 401
    case unAuthorized = 406
    case serverError = 500
    case clientError = 501
}

//checkMatchStatusVM - v1/queue/myQueueState
enum APIMyQueueStatusCode: Int {
    case success = 200
    case noSearch = 201
    case firebaseTokenError = 401
    case unAuthorized = 406
    case serverError = 500
    case clientError = 501
}

enum APIStudyRequestStatusCode: Int {
    case success = 200
    case alreadyRecievedRequest = 201
    case opponentCancelledMatcting = 202
    case firebaseTokenError = 401
    case unAuthorized = 406
    case serverError = 500
    case clientError = 501
}

enum APIStudyAcceptStatusCode: Int {
    case success = 200
    case alreadyOpponentMatched = 201
    case opponentCancelledMatcting = 202
    case alreadyIMatched = 203
    case firebaseTokenError = 401
    case unAuthorized = 406
    case serverError = 500
    case clientError = 501
}
