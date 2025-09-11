import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: EntryStore
    @State private var activeSheet: ActiveSheet?

    enum ActiveSheet: Identifiable {
        case new
        case edit(Entry)

        var id: String {
            switch self {
            case .new:
                return "new"
            case .edit(let entry):
                return entry.id.uuidString
            }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.entries.isEmpty {
                    ContentUnavailableView(
                        "Henüz kayıt yok",
                        systemImage: "tray",
                        description: Text("Yeni bir kayıt eklemek için + düğmesine dokunun.")
                    )
                } else {
                    List {
                        ForEach(store.entries) { entry in
                            Button {
                                activeSheet = .edit(entry)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title)
                                        .font(.headline)
                                    if let note = entry.note, !note.isEmpty {
                                        Text(note)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                    Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                        }
                        .onDelete(perform: store.delete)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("S.MPLE Track")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        activeSheet = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityLabel("Yeni kayıt ekle")
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .new:
                    EntryFormView(
                        initialEntry: nil,
                        onCancel: { activeSheet = nil },
                        onSave: { title, note in
                            store.add(title: title, note: note)
                            activeSheet = nil
                        }
                    )
                case .edit(let entry):
                    EntryFormView(
                        initialEntry: entry,
                        onCancel: { activeSheet = nil },
                        onSave: { title, note in
                            let updated = Entry(id: entry.id, title: title, note: note, createdAt: entry.createdAt)
                            store.update(entry: updated)
                            activeSheet = nil
                        }
                    )
                }
            }
        }
    }
}

