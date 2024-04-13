public struct User: Codable, Hashable {
    public let id: Int
    public let name: String
    public let email: String
    
    public init(
        id: Int = 0,
        name: String = "",
        email: String = ""
    ) {
        self.id = id
        self.name = name
        self.email = email
    }
}
