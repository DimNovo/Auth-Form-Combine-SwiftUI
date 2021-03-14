//
//  RegisterView.swift
//  Auth Form Combine SwiftUI
//
//  Created by Dmitry Novosyolov on 14/03/2021.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject
    var authVM: AuthViewModel
    @Environment(\.presentationMode)
    var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(
                        header:
                            Text("Create account")
                            .font(.headline)) {
                        TextField("email...", text: $authVM.user.email)
                            .keyboardType(.emailAddress)
                        SecureField("password...", text: $authVM.user.password)
                        if !(authVM.user.password.isEmpty) {
                            SecureField("confirm password...", text: $authVM.confirmPassword)
                        }
                    }
                }
                Button(
                    action: {
                        authVM.registerAction() ? presentationMode.wrappedValue.dismiss() : nil
                    },
                    label: {
                        Text("Register")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(
                                width: UIScreen.main.bounds.width / 1.2,
                                height: 45)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous)
                                    .fill(!authVM.registerPermission ? .secondary : Color.blue))
                            .opacity(authVM.registerPermission ? 0.85 : 0.35)
                    })
                    .padding(.vertical)
                    .disabled(!authVM.registerPermission)
            }
            .navigationTitle("Register")
            .navigationBarItems(
                trailing: Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                )
            )
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authVM: AuthViewModel())
    }
}
