import SwiftUI

struct MaterialRowView: View {
    let item: Item

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: item.imageRelativePath,
                cacheKey: item.id,
                placeholderSymbol: "cube.box"
            )
            .frame(width: 40, height: 40)
            .padding(6)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.Materials.cellImage)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(TriadFont.headline(14))
                    .foregroundStyle(TriadColor.textPrimary)
                    .lineLimit(1)
                    .accessibilityIdentifier(AccessibilityID.Materials.cellTitle)

                HStack(spacing: 8) {
                    Text(item.rarityDisplay)
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(rarityColor(for: item.rarity))
                        .accessibilityIdentifier(AccessibilityID.Materials.cellRarity)

                    Text(item.type.uppercased())
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.textSecondary)
                }
            }

            Spacer()
        }
        .padding(10)
        .background(TriadColor.surface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(TriadColor.tertiary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AccessibilityID.Materials.cell)
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
