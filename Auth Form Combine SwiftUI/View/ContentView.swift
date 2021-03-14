//
//  ContentView.swift
//  Auth Form Combine SwiftUI
//
//  Created by Dmitry Novosyolov on 14/03/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject
    private var authVM = AuthViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("enter account").font(.headline)) {
                        TextField("email...", text: $authVM.user.email)
                            .keyboardType(.emailAddress)
                        SecureField("password...", text: $authVM.user.password)
                    }
                }
                VStack(alignment: .center, spacing: 15) {
                    Button(
                        action: {
                            authVM.loginAction()
                        },
                        label: {
                            Text("Login")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(
                                    width: UIScreen.main.bounds.width / 1.2,
                                    height: 44)
                                .background(
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous)
                                        .fill(
                                            !authVM.loginPermission ?
                                                .secondary :
                                                Color.blue))
                                .opacity(authVM.loginPermission ? 0.85 : 0.35)
                        })
                        .disabled(!authVM.loginPermission)
                    Button(
                        action: {
                            authVM.isPresented.toggle()
                        },
                        label: {
                            Text("Don't have an account?")
                        }
                    )
                }
                .padding(.vertical)
            }
            .alert(item: $authVM.loginAlert) { alert in alert.alertView }
            .fullScreenCover(isPresented: $authVM.isPresented) {
                RegisterView(authVM: authVM)
                    .alert(item: $authVM.registerAlert) { alert in alert.alertView }
            }
            .navigationTitle("Login")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
