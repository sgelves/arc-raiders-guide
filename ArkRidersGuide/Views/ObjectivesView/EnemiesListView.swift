import SwiftUI

struct EnemiesListView: View {
    @StateObject private var viewModel: EnemiesVM

    init(service: APIServiceProtocol) {
        _viewModel = StateObject(wrappedValue: EnemiesVM(service: service))
    }

    var body: some View {
        ZStack {
            TriadColor.background
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Scanning threats...")
                    .font(TriadFont.tactical(12))
                    .tint(TriadColor.tertiary)
                    .foregroundStyle(TriadColor.textSecondary)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundStyle(TriadColor.secondary)
                    Text(error)
                        .font(TriadFont.tactical(12))
                        .foregroundStyle(TriadColor.textSecondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await viewModel.fetchEnemies() }
                    }
                    .font(TriadFont.tactical(14))
                    .foregroundStyle(TriadColor.primary)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.enemies) { enemy in
                            EnemyRowView(
                                enemy: enemy,
                                isChecked: viewModel.checkedIds.contains(enemy.id),
                                onToggle: { viewModel.toggleChecked(enemyId: enemy.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier(AccessibilityID.Enemies.list)
            }
        }
        .task {
            if viewModel.enemies.isEmpty {
                await viewModel.fetchEnemies()
            }
        }
    }
}
