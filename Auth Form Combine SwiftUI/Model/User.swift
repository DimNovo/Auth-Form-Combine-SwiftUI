//
//  User.swift
//  Auth Form Combine SwiftUI
//
//  Created by Dmitry Novosyolov on 14/03/2021.
//

import Foundation

struct User {
    var email, password: String
}

extension User: Equatable {
    static var demoUsers: [Self] = [.init(email: "demo@mail.com", password: "123123")]
}
