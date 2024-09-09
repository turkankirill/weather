import SwiftUI
import SwiftData

@main
struct weatherAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ItemModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                AppTabBarView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
