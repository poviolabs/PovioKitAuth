//
//  File.swift
//
//
//  Created by Borut Tomazin on 04/09/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct LinkedInSheet: ViewModifier {
  typealias SuccessHandler = LinkedInWebView.SuccessHandler // (Bool) -> Void
  typealias ErrorHandler = LinkedInWebView.ErrorHandler // (Error) -> Void
  let config: LinkedInAuthenticator.Configuration
  let isPresented: Binding<Bool>
  let onSuccess: SuccessHandler?
  let onError: ErrorHandler?
  
  func body(content: Content) -> some View {
    content
      .sheet(isPresented: isPresented) {
        LinkedInWebView(with: config) { data in
          onSuccess?(data)
        } onFailure: {
          onError?()
        }
      }
  }
}

@available(iOS 15.0, *)
extension View {
  /// ViewModifier to present `LinkedInWebView` in sheet
  func linkedInSheet(with config: LinkedInAuthenticator.Configuration,
                     isPresented: Binding<Bool>,
                     onSuccess: LinkedInSheet.SuccessHandler? = nil,
                     onError: LinkedInSheet.ErrorHandler? = nil) -> some View {
    modifier(LinkedInSheet(config: config, isPresented: isPresented, onSuccess: onSuccess, onError: onError))
  }
}
