import Foundation
import SwiftUI

final class EntryStore: ObservableObject {
    @Published private(set) var entries: [Entry] = []

    private let userDefaultsKey = "simpletrack_entries_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        load()
    }

    func add(title: String, note: String?) {
        let newEntry = Entry(title: title, note: note)
        entries.insert(newEntry, at: 0)
        save()
    }

    func update(entry: Entry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            let decoded = try decoder.decode([Entry].self, from: data)
            entries = decoded.sorted(by: { $0.createdAt > $1.createdAt })
        } catch {
            entries = []
        }
    }

    private func save() {
        do {
            let data = try encoder.encode(entries)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            // No-op for simplicity
        }
    }
}

