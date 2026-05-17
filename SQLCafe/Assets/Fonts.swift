import SwiftUI

extension Font {
    // MARK: - Japanese (DotGothic16 style - using system serif as fallback)
    static func japaneseTitle(size: CGFloat = 18) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }

    static func japaneseBody(size: CGFloat = 14) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func japaneseSmall(size: CGFloat = 12) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    // MARK: - English (System font - clear and readable)
    static func englishTitle(size: CGFloat = 18) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func englishBody(size: CGFloat = 14) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    static func englishSmall(size: CGFloat = 12) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    // MARK: - Monospace (for code/SQL)
    static func codeSmall(size: CGFloat = 13) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }

    static func codeMedium(size: CGFloat = 14) -> Font {
        .system(size: size, weight: .semibold, design: .monospaced)
    }
}
