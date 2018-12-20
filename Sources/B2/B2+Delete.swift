import Vapor

extension B2 {
    public func delete(file name: String, id: String) -> Future<Void> {
        return self.authorize().flatMap { auth in
            let body = try JSONEncoder().encode(["fileName": name, "fileId": id])
            
            var http = HTTPRequest()
            http.body = HTTPBody(data: body)
            http.headers = ["Authorization": auth.authorizationToken]
            http.method = .DELETE
            
            let request = Request(http: http, using: self.client.container)
            return self.client.send(request).transform(to: ())
        }
    }
}
