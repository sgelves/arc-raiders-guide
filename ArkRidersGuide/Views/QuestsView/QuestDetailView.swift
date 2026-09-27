import SwiftUI

struct QuestDetailView: View {
    let quest: Quest
    let isFollowed: Bool
    let onToggleFollow: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                traderSection
                descriptionSection
                stepsSection

                if !quest.requiredItems.isEmpty {
                    requiredItemsSection
                }

                if !quest.maps.isEmpty {
                    mapsSection
                }
            }
            .padding(16)
        }
        .background(TriadColor.background)
        .navigationTitle(quest.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(TriadColor.surface, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: onToggleFollow) {
                    Image(systemName: isFollowed ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(isFollowed ? TriadColor.secondary : TriadColor.textSecondary)
                }
            }
        }
    }

    private var traderSection: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: quest.traderImagePath,
                cacheKey: "trader_\(quest.trader.id)",
                placeholderSymbol: "person.circle"
            )
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(TriadColor.tertiary.opacity(0.4), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(quest.trader.name)
                    .font(TriadFont.headline(16))
                    .foregroundStyle(TriadColor.textPrimary)

                if let type = quest.trader.type {
                    Text(type.uppercased())
                        .font(TriadFont.tactical(11))
                        .foregroundStyle(TriadColor.tertiary)
                }

                Text(quest.trader.description)
                    .font(TriadFont.body(11))
                    .foregroundStyle(TriadColor.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(TriadColor.surface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(TriadColor.tertiary.opacity(0.15), lineWidth: 1)
        )
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("MISSION BRIEF", color: TriadColor.primary)

            Text(quest.description)
                .font(TriadFont.body(13))
                .foregroundStyle(TriadColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("OBJECTIVES", color: TriadColor.tertiary)

            ForEach(Array(quest.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(index + 1)")
                        .font(TriadFont.tactical(12))
                        .foregroundStyle(TriadColor.primary)
                        .frame(width: 24, height: 24)
                        .background(TriadColor.primary.opacity(0.15))
                        .cornerRadius(4)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                            .font(TriadFont.body(13))
                            .foregroundStyle(TriadColor.textPrimary)

                        if let amount = step.amount {
                            Text("AMOUNT: \(amount)")
                                .font(TriadFont.tactical(10))
                                .foregroundStyle(TriadColor.textSecondary)
                        }
                    }

                    Spacer()
                }
                .padding(10)
                .background(TriadColor.surface)
                .cornerRadius(6)
            }
        }
    }

    private var requiredItemsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("REQUIRED ITEMS", color: TriadColor.secondary)

            ForEach(quest.requiredItems) { required in
                RequiredItemRowView(requiredItem: required)
            }
        }
    }

    private var mapsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("AVAILABLE ZONES", color: TriadColor.tertiary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(quest.maps) { map in
                    HStack(spacing: 6) {
                        Image(systemName: "map")
                            .font(.system(size: 12))
                            .foregroundStyle(TriadColor.tertiary)
                        Text(map.name)
                            .font(TriadFont.tactical(11))
                            .foregroundStyle(TriadColor.textPrimary)
                            .lineLimit(1)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(TriadColor.surface)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(TriadColor.tertiary.opacity(0.15), lineWidth: 1)
                    )
                }
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

#Preview {
    NavigationStack {
        QuestDetailView(
            quest: MockData.quests[1],
            isFollowed: true,
            onToggleFollow: {}
        )
    }
}
