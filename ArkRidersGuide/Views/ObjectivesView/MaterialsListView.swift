import SwiftUI

struct MaterialsListView: View {
    @StateObject private var viewModel: MaterialsVM

    init(service: APIServiceProtocol, storage: ChecklistStorageProtocol = UserDefaultsChecklistStorage()) {
        _viewModel = StateObject(wrappedValue: MaterialsVM(service: service, storage: storage))
    }

    var body: some View {
        ZStack {
            TriadColor.background
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Scanning salvage...")
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
                        Task { await viewModel.fetchMaterials() }
                    }
                    .font(TriadFont.tactical(14))
                    .foregroundStyle(TriadColor.primary)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        if !viewModel.groupedQuestMaterials.isEmpty {
                            sectionHeader("QUEST REQUIRED", color: TriadColor.secondary)
                                .padding(.horizontal, 16)

                            progressSummary
                                .padding(.horizontal, 16)

                            ForEach(viewModel.groupedQuestMaterials) { group in
                                questSubHeader(group.questName)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 4)

                                ForEach(group.materials) { required in
                                    RequiredItemRowView(
                                        requiredItem: required,
                                        isChecked: viewModel.isItemChecked(questId: group.questId, itemId: required.item.id),
                                        onToggle: { viewModel.toggleChecked(questId: group.questId, itemId: required.item.id) }
                                    )
                                    .padding(.horizontal, 16)
                                }
                            }

                            sectionHeader("ALL MATERIALS", color: TriadColor.tertiary)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                        }

                        ForEach(viewModel.materials) { item in
                            MaterialRowView(item: item)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier(AccessibilityID.Materials.list)
            }
        }
        .task {
            if viewModel.materials.isEmpty {
                await viewModel.fetchMaterials()
            }
        }
    }

    private var progressSummary: some View {
        Text(viewModel.progressText)
            .font(TriadFont.tactical(12))
            .foregroundStyle(TriadColor.tertiary)
            .accessibilityIdentifier(AccessibilityID.QuestMaterials.progressSummary)
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
    }

    private func questSubHeader(_ title: String) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(TriadColor.secondary)
                .frame(width: 3, height: 14)
            Text(title)
                .font(TriadFont.tactical(11))
                .foregroundStyle(TriadColor.secondary)
        }
        .accessibilityIdentifier(AccessibilityID.QuestMaterials.questHeader)
    }
}
