import Vapor

extension B2 {
    public func delete(file name: String, id: String) -> Future<Void> {
        return self.authorize().flatMap { auth in
            let body = try JSONEncoder().encode(["fileName": name, "fileId": id])
            let path = "https://api.backblazeb2.com/b2api/v2/b2_delete_file_version"
            guard let url = URL(string: path) else {
                throw Abort(.internalServerError, reason: "Unable to create URL from path `\(path)`")
            }
            
            var http = HTTPRequest()
            http.body = HTTPBody(data: body)
            http.headers = ["Authorization": auth.authorizationToken]
            http.method = .DELETE
            http.url = url
            
            let request = Request(http: http, using: self.client.container)
            return self.client.send(request).transform(to: ())
        }
    }
}
