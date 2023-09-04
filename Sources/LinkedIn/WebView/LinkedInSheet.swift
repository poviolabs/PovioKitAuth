//
//  File.swift
//  
//
//  Created by Borut Tomazin on 04/09/2023.
//

import SwiftUI

//struct LinkedInSheet: ViewModifier {
//  typealias SuccessHandler = (Bool) -> Void
//  typealias ErrorHandler = (Error) -> Void
//  let isPresented: Binding<Bool>
//  let onSuccess: SuccessHandler?
//  let onError: ErrorHandler?
//  
//  func body(content: Content) -> some View {
//    content
//      .sheet(isPresented: isPresented) {
//        LinkedInWebView { data in
//          //          Task { await viewModel.signInWithLinkedIn() }
//        } onFailure: {
//          //          viewModel.error = .general
//        }
//      }
//  }
//}
//
//extension View {
//  func linkedInSheet(isPresented: Binding<Bool>,
//                     onSuccess: LinkedInSheet.SuccessHandler? = nil,
//                     onError: LinkedInSheet.ErrorHandler? = nil) -> some View {
//    modifier(LinkedInSheet(isPresented: isPresented, onSuccess: onSuccess, onError: onError))
//  }
//}
