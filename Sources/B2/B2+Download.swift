import Vapor

extension B2 {
    public func download(file name: String) -> Future<File> {
        return self.authorize().flatMap { auth -> Future<File> in
            let path = auth.downloadUrl + "/file/" + self.config.bucket.name + "/" + name
            guard let url = URL(string: path) else {
                throw Abort(.badRequest, reason: "Unable to construct URL from path `\(path)`")
            }
            guard let filename = name.split(separator: "/").last.map(String.init) else {
                throw Abort(.badRequest, reason: "Unable to extract filename from relative path `\(name)`")
            }
            
            var http = HTTPRequest()
            http.url = url
            http.method = .GET
            http.headers = ["Authorization": auth.authorizationToken]
            
            let request = Request(http: http, using: self.client.container)
            return self.client.send(request).flatMap { response in
                return response.http.body.consumeData(on: self.client.container).map { data in
                    return File(data: data, filename: filename)
                }
            }
        }
    }
}
