import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashVM()
    let onInitialize: () -> Void

    var body: some View {
        ZStack {
            TriadColor.background
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("ARC_TACTICAL_OS")
                    .font(TriadFont.headline(28))
                    .foregroundStyle(TriadColor.primary)
                    .accessibilityIdentifier(AccessibilityID.Splash.title)

                Text("// AUTHORIZED RAIDER ONLY")
                    .font(TriadFont.tactical(12))
                    .foregroundStyle(TriadColor.tertiary)
                    .accessibilityIdentifier(AccessibilityID.Splash.subtitle)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(viewModel.bootLines.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(TriadFont.tactical(11))
                            .foregroundStyle(TriadColor.textSecondary)
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .accessibilityIdentifier(AccessibilityID.Splash.bootLog)

                Spacer()

                if viewModel.showInitButton {
                    Button(action: onInitialize) {
                        Text("[ INITIALIZE SHELL ]")
                            .font(TriadFont.tactical(16))
                            .foregroundStyle(TriadColor.background)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(TriadColor.primary)
                            .cornerRadius(4)
                    }
                    .accessibilityIdentifier(AccessibilityID.Splash.initializeButton)
                    .transition(.opacity)
                    .padding(.bottom, 60)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.bootLines.count)
            .animation(.easeInOut(duration: 0.5), value: viewModel.showInitButton)
        }
        .task {
            await viewModel.runBootSequence()
        }
    }
}
