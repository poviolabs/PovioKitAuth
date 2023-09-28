//
//  LinkedInWebView.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 04/09/2023.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import PovioKitCore
import SwiftUI
import WebKit

@available(iOS 15.0, *)
public struct LinkedInWebView: UIViewRepresentable {
  @Environment(\.dismiss) var dismiss
  // create a random string based on the time interval (it will be in the number form) - Needed for state.
  public typealias SuccessHandler = ((code: String, state: String)) -> Void
  public typealias ErrorHandler = () -> Void
  private let requestState: String = "\(Int(Date().timeIntervalSince1970))"
  private let webView: WKWebView
  private let configuration: LinkedInAuthenticator.Configuration
  public let onSuccess: SuccessHandler?
  public let onFailure: ErrorHandler?
  
  public init(with configuration: LinkedInAuthenticator.Configuration,
              onSuccess: @escaping SuccessHandler,
              onFailure: @escaping ErrorHandler) {
    self.configuration = configuration
    let config = WKWebViewConfiguration()
    config.websiteDataStore = WKWebsiteDataStore.default()
    webView = WKWebView(frame: .zero, configuration: config)
    self.onSuccess = onSuccess
    self.onFailure = onFailure
    
    webView.navigationDelegate = makeCoordinator()
  }
  
  public func makeUIView(context: Context) -> some UIView {
    webView
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {
    guard let webView = uiView as? WKWebView else { return }
    guard let authURL = configuration.authorizationUrl(state: requestState) else {
      Logger.error("Failed to geet auth url!")
      dismiss()
      return
    }
    webView.navigationDelegate = context.coordinator
    webView.load(.init(url: authURL))
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self, requestState: requestState)
  }
}

@available(iOS 15.0, *)
public extension LinkedInWebView {
  class Coordinator: NSObject, WKNavigationDelegate {
    private let parent: LinkedInWebView
    private let requestState: String
    
    public init(_ parent: LinkedInWebView, requestState: String) {
      self.parent = parent
      self.requestState = requestState
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      if let url = navigationAction.request.url,
         url.absoluteString.hasPrefix(parent.configuration.authCancel.absoluteString) {
        decisionHandler(.cancel)
        parent.dismiss()
        return
      }
      
      guard let url = webView.url, url.host == parent.configuration.redirectUrl.host else {
        decisionHandler(.allow)
        return
      }
      
      // extract the authorization code
      let components = URLComponents(string: url.absoluteString)
      guard let state = components?.queryItems?.first(where: { $0.name == "state" }),
            let code = components?.queryItems?.first(where: { $0.name == "code" }) else {
        decisionHandler(.allow)
        return
      }
      guard requestState == state.value ?? "" else {
        parent.onFailure?()
        decisionHandler(.allow)
        parent.dismiss()
        return
      }
      parent.onSuccess?((code.value ?? "", parent.requestState))
      decisionHandler(.allow)
      parent.dismiss()
    }
  }
}
