import SwiftUI

struct SQLEditorView: View {
    @StateObject private var viewModel = SQLEditorViewModel()

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationBarView(title: viewModel.currentProblem.title)

                ScrollView {
                    VStack(spacing: 16) {
                        ProblemStatementView(problem: viewModel.currentProblem)

                        SQLQueryEditorView(queryText: $viewModel.queryText)

                        Spacer(minLength: 20)
                    }
                    .padding(16)
                }
            }
        }
    }
}

#Preview {
    SQLEditorView()
}
