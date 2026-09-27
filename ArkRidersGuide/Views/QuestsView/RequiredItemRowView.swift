import SwiftUI

struct RequiredItemRowView: View {
    let requiredItem: RequiredItem
    var isChecked: Bool = false
    var onToggle: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: requiredItem.item.imageRelativePath,
                cacheKey: requiredItem.item.id,
                placeholderSymbol: "shippingbox"
            )
            .frame(width: 36, height: 36)
            .padding(4)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellImage)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(requiredItem.item.name)
                        .font(TriadFont.headline(13))
                        .foregroundStyle(TriadColor.textPrimary)
                        .lineLimit(1)
                        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellTitle)

                    Text("x\(requiredItem.amount)")
                        .font(TriadFont.tactical(10))
                        .foregroundStyle(TriadColor.background)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(TriadColor.tertiary)
                        .clipShape(Capsule())
                        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellAmountBadge)
                }

                Text(requiredItem.item.type.uppercased())
                    .font(TriadFont.tactical(10))
                    .foregroundStyle(TriadColor.textSecondary)
            }

            Spacer()

            if let onToggle {
                Button(action: onToggle) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .font(.system(size: 22))
                        .foregroundStyle(isChecked ? TriadColor.primary : TriadColor.textSecondary)
                }
                .accessibilityIdentifier(AccessibilityID.QuestMaterials.cellCheckbox)
            }
        }
        .padding(8)
        .background(TriadColor.surface)
        .cornerRadius(6)
        .accessibilityIdentifier(AccessibilityID.QuestMaterials.cell)
    }
}
