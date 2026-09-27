import SwiftUI

struct ObjectivesView: View {
    let service: APIServiceProtocol

    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Objectives", selection: $selectedTab) {
                    Text("Enemies").tag(0)
                        .accessibilityIdentifier(AccessibilityID.Objectives.enemiesTab)
                    Text("Materials").tag(1)
                        .accessibilityIdentifier(AccessibilityID.Objectives.materialsTab)
                    Text("Items").tag(2)
                        .accessibilityIdentifier(AccessibilityID.Objectives.itemsTab)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .accessibilityIdentifier(AccessibilityID.Objectives.segmentedControl)

                TabView(selection: $selectedTab) {
                    EnemiesListView(service: service)
                        .tag(0)
                    MaterialsListView(service: service)
                        .tag(1)
                    ItemsListView(service: service)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(TriadColor.background)
            .navigationTitle("OBJECTIVES")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(TriadColor.surface, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .accessibilityIdentifier(AccessibilityID.Objectives.navigationBar)
        }
    }
}
