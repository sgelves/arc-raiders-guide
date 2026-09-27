import SwiftUI

struct ItemsListView: View {
    @StateObject private var viewModel: ItemsVM

    init(service: APIServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ItemsVM(service: service))
    }

    var body: some View {
        ZStack {
            TriadColor.background
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Analyzing cargo...")
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
                        Task { await viewModel.fetchItems() }
                    }
                    .font(TriadFont.tactical(14))
                    .foregroundStyle(TriadColor.primary)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        if !viewModel.questRequiredItems.isEmpty {
                            sectionHeader("QUEST REQUIRED", color: TriadColor.secondary)
                                .padding(.horizontal, 16)

                            ForEach(viewModel.questRequiredItems) { required in
                                RequiredItemRowView(requiredItem: required)
                                    .padding(.horizontal, 16)
                            }

                            sectionHeader("ALL ITEMS", color: TriadColor.tertiary)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                        }

                        ForEach(viewModel.items) { item in
                            ItemRowView(
                                item: item,
                                isChecked: viewModel.checkedIds.contains(item.id),
                                onToggle: { viewModel.toggleChecked(itemId: item.id) }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier(AccessibilityID.Items.list)
            }
        }
        .task {
            if viewModel.items.isEmpty {
                await viewModel.fetchItems()
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
    }
}
