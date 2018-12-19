import Crypto
import Vapor

extension B2 {
    public func upload(file: File) throws -> Future<Response> {
        return authorize().flatMap(self.getUploadUrl).flatMap { uploadUrl in
            let uploadAuthorizationToken = uploadUrl.authorizationToken
            let fileName = file.filename
            
            let sha1 = try SHA1.hash(file.data).hexEncodedString()
            
            var b2Headers: [String: String] = ["Authorization": uploadAuthorizationToken]
            b2Headers["X-Bz-File-Name"] = fileName
            b2Headers["Content-Type"] = file.contentType?.description ?? "b2/X-auto"
            b2Headers["Content-Length"] = "\(file.data.count + 40)"
            b2Headers["X-Bz-Content-Sha1"] = sha1
            
            let headers = HTTPHeaders(b2Headers.map { $0 })
            
            let request = Request(using: self.client.container)
            request.http.method = .POST
            request.http.headers = headers
            request.http.body = file.data.convertToHTTPBody()
            request.http.url = URL(string: uploadUrl.uploadUrl)!
            
            return self.client.send(request)
        }
    }
    
    private func getUploadUrl(auth: Auth) throws -> Future<UploadUrl> {
        let request = Request(using: client.container)
        request.http.method = .POST
        request.http.headers.add(name: "Authorization", value: auth.authorizationToken)
        try request.content.encode(json: UploadUrlRequest(bucketId: config.bucketID))
        request.http.url = URL(string: auth.apiUrl + "/b2api/v2/b2_get_upload_url")!
        
        return client.send(request).flatMap { try $0.content.decode(UploadUrl.self) }
    }
    
    private struct UploadUrl: Codable {
        let bucketId: String
        let uploadUrl: String
        let authorizationToken: String
    }
    
    private struct UploadUrlRequest: Encodable {
        let bucketId: String
    }
}
