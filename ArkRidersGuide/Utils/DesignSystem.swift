import SwiftUI

enum TriadColor {
    static let primary = Color(red: 0.96, green: 0.65, blue: 0.14)
    static let secondary = Color(red: 0.91, green: 0.12, blue: 0.49)
    static let tertiary = Color(red: 0.31, green: 0.88, blue: 0.85)
    static let background = Color(red: 0.05, green: 0.05, blue: 0.07)
    static let surface = Color(red: 0.11, green: 0.11, blue: 0.14)
    static let textPrimary = Color(red: 0.88, green: 0.88, blue: 0.88)
    static let textSecondary = Color(red: 0.55, green: 0.55, blue: 0.55)
}

enum TriadFont {
    static func headline(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }

    static func tactical(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}
