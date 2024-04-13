public struct User: Codable, Hashable {
    public let id: Int
    public let username: String
    public let email: String
    
    public init(
        id: Int = 0,
        username: String = "",
        email: String = ""
    ) {
        self.id = id
        self.username = username
        self.email = email
    }
}
