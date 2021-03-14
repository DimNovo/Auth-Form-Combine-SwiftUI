//
//  CustomAlert.swift
//  Auth Form Combine SwiftUI
//
//  Created by Dmitry Novosyolov on 14/03/2021.
//

import SwiftUI

enum CustomAlert: Identifiable {
    typealias Action = () -> Void
    var id: String { UUID().uuidString }
    case notification(String, Action), error(String, Action)
    var alertView: Alert {
        switch self {
        case .notification(let message, let action):
            return
                .init(
                    title: Text("Notification"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"),
                                            action: action))
        case .error(let message, let action):
            return
                .init(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .destructive(Text("OK"),
                                                action: action))
        }
    }
}
