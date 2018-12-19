import Service

public struct B2Config: Service {
    public let keyID: String
    public let applicationID: String
    public let bucket: Bucket
    
    public init(keyID: String, applicationID: String, bucket: Bucket) {
        self.applicationID = applicationID
        self.keyID = keyID
        self.bucket = bucket
    }
}
