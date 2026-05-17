import SwiftUI

struct ProblemStatementView: View {
    let problem: Problem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("マスターからの指示")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.headerBrown)
                .opacity(0.7)

            Text(problem.description)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.headerBrown)
                .lineLimit(nil)
        }
        .padding(16)
        .background(Color.appBackground)
        .border(Color.borderColor, width: 1)
        .cornerRadius(4)
    }
}

#Preview {
    ProblemStatementView(problem: .sampleLesson1)
        .padding()
}
