struct APIConstants {
    public static let baseURL: String = "http://127.0.0.1:5000"
    static let id: String = "id"
    static let email: String = "email"
    static let username: String = "username"
    static let password: String = "password"
    
    enum Handles: String {
        case register = "/register"
        case login = "/login"
        case newEvent = "/newEvent"
        case users = "/users"
        case user = "/user"
        case events = "/events"
    }
    
    enum RESTMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum HeaderFields: String {
        case contentType = "Content-Type"
    }
    
    enum HeaderValues: String {
        case json = "application/json"
    }
}
