import Foundation

struct Entry: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var note: String?
    var createdAt: Date

    init(id: UUID = UUID(), title: String, note: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.note = note
        self.createdAt = createdAt
    }
}

