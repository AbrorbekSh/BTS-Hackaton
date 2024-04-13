import Foundation

public struct Category: Codable {
    let id: Int
    let createdAt: String
    let updatedAt: String?
    let deletedAt: String?
    let isDeleted: Int
    let name: String
    let image: String
}

public struct CategoryResponse: Codable {
    let content: [Category]
    let totalPages: Int
    let totalElements: Int
}
