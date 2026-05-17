import Foundation

struct Problem: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let difficulty: Int  // 1-5

    // MARK: - Sample Problems
    static let sampleLesson1 = Problem(
        title: "Lesson 1: メニューの把握",
        description: "500円以下のコーヒーの name と price を教えて！",
        difficulty: 1
    )
}
