import SwiftUI

@MainActor
final class SQLEditorViewModel: ObservableObject {
    // MARK: - Published State
    @Published var queryText: String = ""
    @Published var currentProblem: Problem
    @Published var queryResult: QueryResult?
    @Published var isExecuting: Bool = false

    // MARK: - Initialization
    init(problem: Problem = .sampleLesson1) {
        self.currentProblem = problem
    }

    // MARK: - Methods
    func executeQuery() {
        isExecuting = true

        // Simulate query execution with 2-second delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.queryResult = dummyQueryResult
            self?.isExecuting = false
        }
    }

    func resetEditor() {
        queryText = ""
        queryResult = nil
        isExecuting = false
    }

    func insertKeyword(_ keyword: String) {
        queryText += keyword + " "
    }
}
