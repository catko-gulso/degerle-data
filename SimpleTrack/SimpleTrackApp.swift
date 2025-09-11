import SwiftUI

@main
struct SimpleTrackApp: App {
    @StateObject private var store = EntryStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

