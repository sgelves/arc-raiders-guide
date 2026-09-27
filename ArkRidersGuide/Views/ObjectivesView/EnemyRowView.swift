import SwiftUI

struct EnemyRowView: View {
    let enemy: ArcEnemy
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CachedImageView(
                relativePath: enemy.imageRelativePath,
                cacheKey: enemy.id,
                placeholderSymbol: "bolt.shield"
            )
            .frame(width: 48, height: 48)
            .padding(8)
            .background(TriadColor.background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(TriadColor.tertiary.opacity(0.3), lineWidth: 1)
            )
            .accessibilityIdentifier(AccessibilityID.Enemies.cellImage)

            VStack(alignment: .leading, spacing: 4) {
                Text(enemy.name)
                    .font(TriadFont.headline(16))
                    .foregroundStyle(TriadColor.textPrimary)
                    .accessibilityIdentifier(AccessibilityID.Enemies.cellTitle)

                Text("THREAT UNIT")
                    .font(TriadFont.tactical(10))
                    .foregroundStyle(TriadColor.secondary)
            }

            Spacer()

            Button(action: onToggle) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundStyle(isChecked ? TriadColor.primary : TriadColor.textSecondary)
            }
        }
        .padding(12)
        .background(TriadColor.surface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(TriadColor.tertiary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AccessibilityID.Enemies.cell)
    }
}
