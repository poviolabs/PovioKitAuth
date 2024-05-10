//
//  SignInView.swift
//  PovioKitAuthDemo
//
//  Created by Borut Tomazin on 10/05/2024.
//

import SwiftUI

struct SignInView: View {
  @ObservedObject var viewModel: SignInViewModel
  @State private var showErrorAlert: Bool = false
  
  var body: some View {
    VStack(spacing: 20) {
      Button {
        viewModel.signInWithApple()
      } label: {
        Text("SignIn with Apple")
      }
      Button {
        viewModel.signInWithGoogle()
      } label: {
        Text("SignIn with Google")
      }
      Button {
        viewModel.signInWithFacebook()
      } label: {
        Text("SignIn with Facebook")
      }
      Button {
        viewModel.signInWithLinkedIn()
      } label: {
        Text("SignIn with LinkedIn")
      }
    }
    .onChange(of: viewModel.error) { oldValue, newValue in
      showErrorAlert = true
    }
    .alert("Error", isPresented: $showErrorAlert) {
      Button("Ok", action: {})
    } message: {
      Text(viewModel.error)
    }
    .alert("Success", isPresented: $showErrorAlert) {
      Button("Ok", action: {})
    } message: {
      Text(viewModel.success)
    }
  }
}

#Preview {
  SignInView(viewModel: .init())
}
