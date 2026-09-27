import SwiftUI

struct MainTabView: View {
    private let service: APIServiceProtocol

    init(service: APIServiceProtocol? = nil) {
        self.service = service ?? APIService()
    }

    func setup(service: APIServiceProtocol) -> MainTabView {
        MainTabView(service: service)
    }

    var body: some View {

        TabView {

            Tab {
                ObjectivesView(service: service)
            } label: {
                Image(systemName: "target")
                Text("Objectives")
            }
            .accessibilityIdentifier(AccessibilityID.MainTab.objectivesTab)

            Tab {
                QuestsView(service: service)
            } label: {
                Image(systemName: "map")
                Text("Quests")
            }
            .accessibilityIdentifier(AccessibilityID.MainTab.questsTab)
        }
        .tint(TriadColor.primary)
        .accessibilityIdentifier(AccessibilityID.MainTab.tabBar)
    }
}
