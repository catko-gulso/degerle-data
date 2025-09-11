import SwiftUI

struct EntryFormView: View {
    let initialEntry: Entry?
    let onCancel: () -> Void
    let onSave: (String, String?) -> Void

    @State private var titleText: String
    @State private var noteText: String

    init(initialEntry: Entry?, onCancel: @escaping () -> Void, onSave: @escaping (String, String?) -> Void) {
        self.initialEntry = initialEntry
        self.onCancel = onCancel
        self.onSave = onSave
        _titleText = State(initialValue: initialEntry?.title ?? "")
        _noteText = State(initialValue: initialEntry?.note ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Kısa başlık", text: $titleText)
                        .textInputAutocapitalization(.sentences)
                }
                Section("Not") {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle(initialEntry == nil ? "Yeni Kayıt" : "Kaydı Düzenle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        onSave(
                            titleText.trimmingCharacters(in: .whitespacesAndNewlines),
                            noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    }
                    .disabled(titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

