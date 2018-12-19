import Service

public struct B2Config: Service {
    public let keyID: String
    public let applicationID: String
    public let bucketID: String
    
    public init(keyID: String, applicationID: String, bucketID: String) {
        self.applicationID = applicationID
        self.keyID = keyID
        self.bucketID = bucketID
    }
}
