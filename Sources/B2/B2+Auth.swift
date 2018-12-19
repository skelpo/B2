import Vapor

extension B2 {
    internal func authorize() -> Future<Auth> {
        return cache.get(b2CacheKey, as: Auth.self).flatMap { auth in
            if let auth = auth {
                return self.client.container.future(auth)
            }
            
            let keyID = self.config.keyID
            let applicationID = self.config.applicationID
            let auth = ((keyID + ":" + applicationID).data(using: .utf8) ?? Data()).base64EncodedString()
            
            let request = Request(using: self.client.container)
            request.http.method = .GET
            request.http.headers.add(name: "Authorization", value: "Basic \(auth)")
            request.http.url = URL(string: "https://api.backblazeb2.com/b2api/v2/b2_authorize_account")!
            
            return self.client.send(request)
                .flatMap { try $0.content.decode(Auth.self) }
                .flatMap { self.cache.set(b2CacheKey, to: $0).transform(to: $0) }
        }
    }
    
    internal struct Auth: Codable {
        let absoluteMinimumPartSize: Int
        let accountId: String
        let apiUrl: String
        let authorizationToken: String
        let downloadUrl: String
        let recommendedPartSize: Int
    }
}
