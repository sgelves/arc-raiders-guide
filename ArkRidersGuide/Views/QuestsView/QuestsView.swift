import SwiftUI

struct QuestsView: View {
    @StateObject private var viewModel: QuestsVM

    init(service: APIServiceProtocol) {
        _viewModel = StateObject(wrappedValue: QuestsVM(service: service))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                TriadColor.background
                    .ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Loading intel...")
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
                            Task { await viewModel.fetchQuests() }
                        }
                        .font(TriadFont.tactical(14))
                        .foregroundStyle(TriadColor.primary)
                    }
                    .padding()
                } else {

                    List {

                        if !viewModel.followedQuests.isEmpty {

                            Section {
                                ForEach(viewModel.followedQuests) { quest in

                                    QuestCardView(quest: quest, isFollowed: true) {
                                        viewModel.toggleFollow(questId: quest.id)
                                    }
                                    .background {
                                        NavigationLink("QuestDetails", value: quest.id)
                                    }
                                }
                            } header: {
                                sectionHeader("FOLLOWED OPERATIONS", color: TriadColor.secondary)
                                    .accessibilityIdentifier(AccessibilityID.Quests.followedSection)
                            }


                        }

                        Section {

                            ForEach(viewModel.availableQuests) { quest in

                                QuestCardView(quest: quest, isFollowed: false) {
                                    viewModel.toggleFollow(questId: quest.id)
                                }
                                .background {
                                    NavigationLink("QuestDetails", value: quest.id)
                                }
                            }

                        } header: {
                            sectionHeader("AVAILABLE INTEL", color: TriadColor.tertiary)
                                .accessibilityIdentifier(AccessibilityID.Quests.availableSection)
                        }
                    }
                    .listStyle(InsetListStyle())
                    .accessibilityIdentifier(AccessibilityID.Quests.list)
                }
            }
            .navigationDestination(for: String.self) { value in
                if let quest = viewModel.quests.first(where: {value == $0.id}) {
                    QuestDetailView(
                        quest: quest,
                        isFollowed: viewModel.followedQuests.contains(where: {quest.id == $0.id}),
                        onToggleFollow: { viewModel.toggleFollow(questId: quest.id) }
                    )
                }
            }
            .navigationTitle("QUESTS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(TriadColor.surface, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .task {
            if viewModel.quests.isEmpty {
                await viewModel.fetchQuests()
            }
        }
    }

    private func sectionHeader(_ title: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(width: 3, height: 16)

            Text(title)
                .font(TriadFont.tactical(12))
                .foregroundStyle(color)
        }
        .padding(.top, 8)
    }
}


#Preview {
    QuestsView(service: MockAPIService())
}
