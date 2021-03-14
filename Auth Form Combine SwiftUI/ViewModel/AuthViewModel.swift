//
//  AuthViewModel.swift
//  Auth Form Combine SwiftUI
//
//  Created by Dmitry Novosyolov on 14/03/2021.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    
    @Published
    var isPresented = false {
        didSet {
            clearInput()
        }
    }
    
    @Published
    var user: User = User.demoUsers[0]
    
    @Published
    var loginAlert: CustomAlert? = nil
    
    @Published
    var registerAlert: CustomAlert? = nil
    
    @Published
    var loginPermission = false
    
    @Published
    var registerPermission = false
    
    @Published
    var confirmPassword = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var loginAccountCheck: Bool {
        User.demoUsers.map {
            $0.email == user.email.lowercased() && $0.password == user.password
        }
        .first ?? false
    }
    
    private var loginPermissionPublisher: AnyPublisher<Bool, Never> {
        $user.map {
            !$0.email.isEmpty && !$0.password.isEmpty
        }
        .eraseToAnyPublisher()
    }
    
    private var passwordIdenticPermissionPublisher: AnyPublisher<Bool, Never> {
        $user
            .combineLatest($confirmPassword)
            .map {
                $0.0.password == $0.1
            }
            .eraseToAnyPublisher()
    }
    
    private var registerPermissionPublisher: AnyPublisher<Bool, Never> {
        $user
            .map {
                !$0.email.isEmpty && !$0.password.isEmpty
            }
            .combineLatest(passwordIdenticPermissionPublisher)
            .map {
                $0.0 && $0.1
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        loginPermissionPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.loginPermission, on: self)
            .store(in: &cancellableSet)
        registerPermissionPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.registerPermission, on: self)
            .store(in: &cancellableSet)
    }
    
    func loginAction() {
        switch loginAccountCheck {
        case true:
            loginAlert = .notification("User: \(user.email.lowercased())\nsuccessfully logged in!")
                { [self] in loginAlert = nil }
        case false:
            loginAlert = .error("User with\ncurrent email / password\ndoesn't exist")
                { [self] in loginAlert = nil }
        }
    }
    
    func registerAction() -> Bool {
        switch User.demoUsers.map(\.email).contains(user.email.lowercased()) {
        case true:
            registerAlert = .error("User is already exists") { [self] in clearInput() }
        case false:
            switch user.email.isEmail {
            case true:
                createNewUser()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    loginAlert =
                        .notification("User:\n\(User.demoUsers.last?.email.lowercased() ?? "error")\nsuccessfully registered!")
                        { clearInput() }
                }
                return true
            case false:
                registerAlert = .error("Please,\nenter valid email address.") { [self] in user.email.removeAll() }
            }
        }
        return false
    }
    
    private func createNewUser() {
        User.demoUsers.append(
            .init(
                email: user.email.lowercased(),
                password: user.password
            )
        )
    }
    
    private func clearInput() {
        DispatchQueue.main.async { [self] in
            user.email.removeAll()
            user.password.removeAll()
            confirmPassword.removeAll()
        }
    }
}
