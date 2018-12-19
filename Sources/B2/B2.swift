import Vapor
import Service
import Crypto
import Foundation

internal var b2CacheKey = "__b2_authorization_token"

public final class B2: ServiceType {
    internal let config: B2Config
    internal let client: Client
    internal let cache: KeyedCache
    
    private init(config: B2Config, client: Client, cache: KeyedCache) {
        self.config = config
        self.client = client
        self.cache = cache
    }
    
    public static func makeService(for worker: Container) throws -> B2 {
        return B2(
            config: try worker.make(),
            client: try worker.client(),
            cache: try worker.make()
        )
    }
}

public extension Container {
    public func b2() throws -> B2 {
        return try B2.makeService(for: self)
    }
}
