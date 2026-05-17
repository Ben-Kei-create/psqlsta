import SwiftUI

@MainActor
final class BlockQuizViewModel: ObservableObject {
    // MARK: - Published State
    @Published var availableBlocks: [AnswerBlock] = []
    @Published var placedBlocks: [AnswerBlock] = []
    @Published var quizState: QuizState = .answering
    @Published var showHint: Bool = false

    let problem: Problem

    // MARK: - Types
    enum QuizState {
        case answering
        case correct
        case incorrect
    }

    struct AnswerBlock: Identifiable, Equatable {
        let id: UUID = UUID()
        let text: String
    }

    // MARK: - Initialization
    init(problem: Problem) {
        self.problem = problem
        self.availableBlocks = problem.blocks.shuffled().map { AnswerBlock(text: $0) }
    }

    // MARK: - Methods
    func placeBlock(_ block: AnswerBlock) {
        guard quizState == .answering else { return }
        availableBlocks.removeAll { $0.id == block.id }
        placedBlocks.append(block)
    }

    func removeBlock(_ block: AnswerBlock) {
        guard quizState == .answering else { return }
        placedBlocks.removeAll { $0.id == block.id }
        availableBlocks.append(block)
    }

    func submitAnswer() {
        let answer = placedBlocks.map { $0.text }
        if answer == problem.correctAnswer {
            quizState = .correct
        } else {
            quizState = .incorrect
        }
    }

    func retry() {
        placedBlocks.removeAll()
        availableBlocks = problem.blocks.shuffled().map { AnswerBlock(text: $0) }
        quizState = .answering
    }
}
