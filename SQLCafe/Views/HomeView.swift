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

                VStack(spacing: 10) {
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
                .padding(.bottom, 24)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 3) {
            Text("☕ SQL Cafe")
                .font(.system(size: 26, weight: .heavy))
                .foregroundColor(.headerBrown)

            Text("今日のレッスン")
                .font(.system(size: 13))
                .foregroundColor(.subtleText)

            progressBar
                .padding(.top, 6)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 16)
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
            HStack(spacing: 12) {
                // アイコン
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 42, height: 42)
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.subtleText)
                    } else if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("\(lesson.lessonNumber)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                // テキスト
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lesson \(lesson.lessonNumber)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(isLocked ? .subtleText : .accentGold)

                    Text(lesson.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isLocked ? .subtleText : .headerBrown)
                        .lineLimit(1)

                    difficultyStars
                }

                Spacer()

                if !isLocked {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(isCompleted ? .successGreen : Color.accentGold.opacity(0.6))
                }
            }
            .padding(14)
            .background(cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
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
        isCompleted ? Color.successGreen.opacity(0.08) : Color.white.opacity(0.82)
    }

    private var cardBorder: Color {
        if isCompleted { return Color.successGreen.opacity(0.5) }
        if isLocked { return Color.borderColor.opacity(0.2) }
        return Color.accentGold.opacity(0.3)
    }
}

#Preview {
    HomeView()
}
