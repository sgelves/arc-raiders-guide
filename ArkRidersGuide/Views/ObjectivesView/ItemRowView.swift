import SwiftUI

struct ItemRowView: View {
    let item: Item
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: item.imageRelativePath,
                cacheKey: item.id,
                placeholderSymbol: "wrench.and.screwdriver"
            )
            .frame(width: 44, height: 44)
            .padding(6)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.Items.cellImage)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(TriadFont.headline(14))
                    .foregroundStyle(TriadColor.textPrimary)
                    .lineLimit(1)
                    .accessibilityIdentifier(AccessibilityID.Items.cellTitle)

                HStack(spacing: 8) {
                    Text(item.type.uppercased())
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.secondary)
                        .accessibilityIdentifier(AccessibilityID.Items.cellType)

                    Text(item.rarityDisplay)
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(rarityColor(for: item.rarity))
                        .accessibilityIdentifier(AccessibilityID.Items.cellRarity)
                }
            }

            Spacer()

            Button(action: onToggle) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundStyle(isChecked ? TriadColor.primary : TriadColor.textSecondary)
            }
        }
        .padding(10)
        .background(TriadColor.surface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(TriadColor.tertiary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AccessibilityID.Items.cell)
    }

    private func rarityColor(for rarity: String?) -> Color {
        switch rarity?.lowercased() {
        case "common": return TriadColor.textSecondary
        case "uncommon": return .green
        case "rare": return TriadColor.tertiary
        case "epic": return .purple
        case "legendary": return TriadColor.primary
        default: return TriadColor.textSecondary
        }
    }
}
