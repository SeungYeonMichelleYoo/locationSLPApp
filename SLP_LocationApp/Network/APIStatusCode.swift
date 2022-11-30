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