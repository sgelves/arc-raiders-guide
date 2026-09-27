import SwiftUI

struct QuestCardView: View {
    let quest: Quest
    var isFollowed: Bool
    let onToggleFollow: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                CachedImageView(
                    relativePath: quest.traderImagePath,
                    cacheKey: "trader_\(quest.trader.id)",
                    placeholderSymbol: "person.circle"
                )
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(TriadColor.tertiary.opacity(0.4), lineWidth: 1)
                )
                .accessibilityIdentifier(AccessibilityID.Quests.cellTraderImage)

                VStack(alignment: .leading, spacing: 2) {
                    Text(quest.title)
                        .font(TriadFont.headline(14))
                        .foregroundStyle(TriadColor.textPrimary)
                        .lineLimit(2)
                        .accessibilityIdentifier(AccessibilityID.Quests.cellTitle)

                    Text(quest.trader.name.uppercased() + " — " + (quest.trader.type?.uppercased() ?? ""))
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.tertiary)
                        .accessibilityIdentifier(AccessibilityID.Quests.cellTraderName)
                }

                Spacer()

                Button(action: onToggleFollow) {
                    Image(systemName: isFollowed ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18))
                        .foregroundStyle(isFollowed ? TriadColor.secondary : TriadColor.textSecondary)
                }
                .buttonStyle(.borderless)
            }

            Text(quest.description)
                .font(TriadFont.body(12))
                .foregroundStyle(TriadColor.textSecondary)
                .lineLimit(3)
                .accessibilityIdentifier(AccessibilityID.Quests.cellDescription)

            HStack(spacing: 12) {
                Label("\(quest.steps.count) steps", systemImage: "list.bullet")
                    .font(TriadFont.tactical(10))
                    .foregroundStyle(TriadColor.textSecondary)
                    .accessibilityIdentifier(AccessibilityID.Quests.cellStepCount)

                if !quest.maps.isEmpty {
                    Label("\(quest.maps.count) zones", systemImage: "map")
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.textSecondary)
                }

                if !quest.requiredItems.isEmpty {
                    Label("\(quest.requiredItems.count) items", systemImage: "shippingbox")
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.secondary)
                }
            }
        }
        .padding(12)
        .background(TriadColor.surface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isFollowed ? TriadColor.secondary.opacity(0.4) : TriadColor.tertiary.opacity(0.15),
                    lineWidth: 1
                )
        )
        .accessibilityIdentifier(AccessibilityID.Quests.cell)
    }
}

#Preview {
    QuestCardView(quest: MockData.quests.first!, isFollowed: true, onToggleFollow: {})
}
