# LinkedInAuthenticator

Auth provider for social login with LinkedIn.

## Setup
Please read [official documentation](https://learn.microsoft.com/en-us/linkedin/shared/authentication/authorization-code-flow?context=linkedin%2Fcontext&tabs=HTTPS1) from LinkedIn for the details about the authorization.

## Usage

```swift
// present login screen
body
  .sheet(isPresented: $openLinkedInWebView) {
    LinkedInWebView(with: linkedInConfig) { data in
      Task { await viewModel.signInWithLinkedIn(authCode: data.code) }
    } onFailure: {
      viewModel.error = .general
    }
  }

// handle response from webView
let authResponse = try await auth.signIn(authCode: authCode, configuration: linkedInConfig)

// get authentication status
let state = authenticator.isAuthenticated

// signOut user
authenticator.signOut() // all provider data regarding the use auth is cleared at this point

// handle url
authenticator.canOpenUrl(_: application: options:) // call this from `application:openURL:options:` in UIApplicationDelegate
```
