import Combine
import Foundation

class SplashVM: ObservableObject {
    @Published var bootLines: [String] = []
    @Published var isBootComplete = false
    @Published var showInitButton = false

    private let bootSequence = [
        "[SYS] ARC_TACTICAL_OS v2.7.1",
        "[SYS] Initializing kernel modules...",
        "[NET] Scanning frequency bands...",
        "[NET] Encrypted uplink established",
        "[SEC] Raider credentials verified",
        "[HUD] Loading Triad HUD interface...",
        "[DAT] Syncing field intelligence...",
        "[SYS] Boot sequence complete"
    ]

    func runBootSequence() async {
        for line in bootSequence {
            try? await Task.sleep(nanoseconds: 250_000_000)
            bootLines.append(line)
        }
        try? await Task.sleep(nanoseconds: 400_000_000)
        isBootComplete = true
        try? await Task.sleep(nanoseconds: 200_000_000)
        showInitButton = true
    }
}
