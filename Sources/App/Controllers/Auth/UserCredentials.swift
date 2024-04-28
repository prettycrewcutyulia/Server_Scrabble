//
//  UserCredentials.swift
//  
//
//  Created by Ярослав Гамаюнов on 27.04.2024.
//

import Foundation
import Vapor
import JWT

// Модель данных для учетных данных пользователя
struct UserCredentials: Content {
    let nickName: String
    let password: String
}
