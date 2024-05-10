//
//  SignInViewModel.swift
//  PovioKitAuthDemo
//
//  Created by Borut Tomazin on 10/05/2024.
//

import SwiftUI
import PovioKitCore
import PovioKitAuthCore
import PovioKitAuthApple
import PovioKitAuthGoogle
import PovioKitAuthFacebook
import PovioKitAuthLinkedIn

final class SignInViewModel: ObservableObject {
  private var isSigningInWithApple: Bool = false
  private var isSigningInWithLinkedIn: Bool = false
  
  private let socialAuthManager: SocialAuthenticationManager
  
  @Published private(set) var error: String = ""
  @Published private(set) var success: String = ""
  
  init() {
    socialAuthManager = SocialAuthenticationManager(authenticators: [
      AppleAuthenticator(),
      GoogleAuthenticator(),
      FacebookAuthenticator(),
      LinkedInAuthenticator()
    ])
  }
}

extension SignInViewModel {
  func signInWithApple() {
    guard let auth = socialAuthManager.authenticator(for: AppleAuthenticator.self) else { return }
    
    Task { @MainActor in
      isSigningInWithApple = true
      
      do {
        _ = try await auth.signIn(from: UIViewController())
        self.success = "SignIn with Apple succeeded."
      } catch AppleAuthenticator.Error.cancelled {
        Logger.debug("Apple Auth cancelled.")
      } catch {
        Logger.error(error.localizedDescription)
        self.error = error.localizedDescription
      }
      
      isSigningInWithApple = false
    }
  }
  
  func signInWithGoogle() {
    guard let auth = socialAuthManager.authenticator(for: GoogleAuthenticator.self) else { return }
    
    Task { @MainActor in
      do {
        _ = try await auth.signIn(from: UIViewController())
        self.success = "SignIn with Google succeeded."
      } catch GoogleAuthenticator.Error.cancelled {
        Logger.debug("Apple Auth cancelled.")
      } catch {
        Logger.error(error.localizedDescription)
        self.error = error.localizedDescription
      }
    }
  }
  
  func signInWithFacebook() {
    guard let auth = socialAuthManager.authenticator(for: FacebookAuthenticator.self) else { return }
    
    Task { @MainActor in
      do {
        _ = try await auth.signIn(from: UIViewController())
        self.success = "SignIn with Facebook succeeded."
      } catch FacebookAuthenticator.Error.cancelled {
        Logger.debug("Apple Auth cancelled.")
      } catch {
        Logger.error(error.localizedDescription)
        self.error = error.localizedDescription
      }
    }
  }
  
  func signInWithLinkedIn() {
    
  }
}
