import SwiftUI

struct HomeView: View {
    @State private var completedLessons: Set<UUID> = []
    @State private var selectedLesson: Problem? = nil
    @State private var currentLessonIndex: Int? = nil

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if let index = currentLessonIndex {
                BlockQuizView(problem: Problem.allLessons[index]) {
                    let nextIndex = index + 1
                    completedLessons.insert(Problem.allLessons[index].id)
                    if nextIndex < Problem.allLessons.count {
                        currentLessonIndex = nextIndex
                    } else {
                        currentLessonIndex = nil
                    }
                }
                .transition(.move(edge: .trailing))
            } else {
                menuBoard
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.spring(duration: 0.4), value: currentLessonIndex)
    }

    // MARK: - Menu Board

    private var menuBoard: some View {
        ScrollView {
            VStack(spacing: 0) {
                header

                VStack(spacing: 12) {
                    ForEach(Problem.allLessons) { lesson in
                        LessonCard(
                            lesson: lesson,
                            isCompleted: completedLessons.contains(lesson.id),
                            isLocked: isLocked(lesson: lesson)
                        ) {
                            currentLessonIndex = lesson.lessonNumber - 1
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("☕ SQL Cafe")
                .font(.englishTitle(size: 28))
                .foregroundColor(.headerBrown)

            Text("今日のレッスンメニュー")
                .font(.japaneseBody(size: 14))
                .foregroundColor(.subtleText)

            progressBar
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 20)
    }

    private var progressBar: some View {
        let total = Problem.allLessons.count
        let done = completedLessons.count
        return VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.borderColor.opacity(0.2))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentGold)
                        .frame(width: geo.size.width * CGFloat(done) / CGFloat(total), height: 8)
                        .animation(.spring(), value: done)
                }
            }
            .frame(height: 8)

            HStack {
                Text("\(done) / \(total) レッスン完了")
                    .font(.system(size: 12))
                    .foregroundColor(.subtleText)
                Spacer()
            }
        }
    }

    private func isLocked(lesson: Problem) -> Bool {
        guard lesson.lessonNumber > 1 else { return false }
        let prev = Problem.allLessons.first { $0.lessonNumber == lesson.lessonNumber - 1 }
        guard let prev else { return true }
        return !completedLessons.contains(prev.id)
    }
}

// MARK: - Lesson Card

private struct LessonCard: View {
    let lesson: Problem
    let isCompleted: Bool
    let isLocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: { if !isLocked { onTap() } }) {
            HStack(spacing: 14) {
                // アイコン
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 44, height: 44)
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.subtleText)
                    } else if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("\(lesson.lessonNumber)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                // テキスト
                VStack(alignment: .leading, spacing: 4) {
                    Text("Lesson \(lesson.lessonNumber)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(isLocked ? .subtleText : .accentGold)

                    Text(lesson.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isLocked ? .subtleText : .headerBrown)

                    difficultyStars
                }

                Spacer()

                if !isLocked {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "chevron.right")
                        .foregroundColor(isCompleted ? .successGreen : .borderColor)
                }
            }
            .padding(16)
            .background(cardBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(cardBorder, lineWidth: 1.5)
            )
            .opacity(isLocked ? 0.5 : 1.0)
        }
        .buttonStyle(.plain)
    }

    private var difficultyStars: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= lesson.difficulty ? "star.fill" : "star")
                    .font(.system(size: 10))
                    .foregroundColor(i <= lesson.difficulty ? .accentGold : .borderColor.opacity(0.4))
            }
        }
    }

    private var iconBackground: Color {
        if isLocked { return Color.borderColor.opacity(0.3) }
        if isCompleted { return Color.successGreen }
        return Color.accentGold
    }

    private var cardBackground: Color {
        isCompleted ? Color.successGreen.opacity(0.05) : Color.white.opacity(0.8)
    }

    private var cardBorder: Color {
        if isCompleted { return Color.successGreen.opacity(0.4) }
        if isLocked { return Color.borderColor.opacity(0.2) }
        return Color.borderColor.opacity(0.4)
    }
}

#Preview {
    HomeView()
}
