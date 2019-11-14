# Functional Networking
Example how to use functional programming concepts for networking layer in Swift.

# Example
```swift
restClient.executeRequest(
    route: .login,
    request: LoginRequest(
        login: "user", password: "user"
    ).subscribe { (event: Event<LoginResponse>) in
        switch event {
        case .next(let response):
            showLoggedInView()
        case .error(let error):
            handle(error)
        case .completed:
            hideSpinner()
        }
    }.disposed(by: disposeBag)
```

# Execute request
```swift
public func executeRequest<Request: Encodable, Response: Decodable>(
        route: APIRoutable,
        request: Request
    ) -> Observable<Response> {
        guard isConnected else { return .error(NetworkError.noConnection) }
        
        return (route, authDetails, request)
            |> F.Network.addHeaders
            |> F.Network.createRequest
            |> F.Network.convertToUrlRequest
            |> { ($0, self.session) |> F.Network.execute }
    }
```
