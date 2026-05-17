import SwiftUI

struct BlockQuizView: View {
    @StateObject private var vm: BlockQuizViewModel
    @State private var incorrectShake: Bool = false
    @State private var showResult: Bool = false
    @State private var showResultTable: Bool = false

    let onNext: () -> Void

    init(problem: Problem, onNext: @escaping () -> Void) {
        self._vm = StateObject(wrappedValue: BlockQuizViewModel(problem: problem))
        self.onNext = onNext
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationBarView(title: "Lesson \(vm.problem.lessonNumber)")

                // Main content - fits on screen without scrolling
                if showResultTable {
                    // Result screen with scrollable table
                    ScrollView {
                        VStack(spacing: 12) {
                            resultTable
                                .padding(12)
                        }
                        .padding(.bottom, 40)
                    }
                } else {
                    // Quiz screen - no scroll needed
                    VStack(spacing: 10) {
                        problemCard

                        answerArea

                        if vm.quizState == .answering || vm.quizState == .incorrect {
                            blockPalette
                        }

                        Spacer(minLength: 0)

                        actionButton
                    }
                    .padding(12)
                }
            }
        }
        .onChange(of: vm.quizState) { state in
            if state == .correct {
                withAnimation(.spring()) { showResult = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation { showResultTable = true }
                }
            }
            if state == .incorrect {
                withAnimation(.default) { incorrectShake = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    incorrectShake = false
                }
            }
        }
    }

    // MARK: - Subviews

    private var problemCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.accentGold)
                Text("マスターからの指示")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.accentGold)
                Spacer()
                Button {
                    withAnimation { vm.showHint.toggle() }
                } label: {
                    Text("ヒント")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.accentGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentGold, lineWidth: 1)
                        )
                }
            }

            Text(vm.problem.description)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.headerBrown)
                .lineLimit(nil)

            if vm.showHint {
                HStack(spacing: 5) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.accentGold)
                    Text(vm.problem.hint)
                        .font(.system(size: 12))
                        .foregroundColor(.headerBrown)
                }
                .padding(8)
                .background(Color.accentGold.opacity(0.12))
                .cornerRadius(6)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.85))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accentGold.opacity(0.3), lineWidth: 1.5)
        )
    }

    private var answerArea: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("あなたの回答")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.headerBrown)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.editorBackground)
                    .frame(minHeight: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(borderStrokeColor, lineWidth: 2)
                    )

                if placedBlocks.isEmpty {
                    Text("ブロックをタップして並べよう")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.subtleText)
                        .padding(10)
                } else {
                    FlowLayout(spacing: 5) {
                        ForEach(vm.placedBlocks) { block in
                            Button {
                                vm.removeBlock(block)
                            } label: {
                                BlockTile(
                                    text: block.text,
                                    style: .placed,
                                    state: vm.quizState
                                )
                            }
                            .disabled(vm.quizState != .answering)
                        }
                    }
                    .padding(8)
                }
            }
            .modifier(ShakeModifier(trigger: incorrectShake))
        }
    }

    private var blockPalette: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ブロック")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.headerBrown)

            FlowLayout(spacing: 6) {
                ForEach(vm.availableBlocks) { block in
                    Button {
                        vm.placeBlock(block)
                    } label: {
                        BlockTile(text: block.text, style: .available, state: .answering)
                    }
                }
            }
            .padding(10)
            .background(Color.accentGold.opacity(0.08))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.accentGold.opacity(0.3), lineWidth: 1)
            )
        }
    }

    private var actionButton: some View {
        Group {
            switch vm.quizState {
            case .answering:
                Button {
                    vm.submitAnswer()
                } label: {
                    Text("確認する")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(vm.placedBlocks.isEmpty ? Color.borderColor.opacity(0.5) : Color.accentGold)
                        .cornerRadius(6)
                }
                .disabled(vm.placedBlocks.isEmpty)

            case .correct:
                Button {
                    onNext()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                        Text("正解！次へ")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.successGreen)
                    .cornerRadius(6)
                }

            case .incorrect:
                Button {
                    vm.retry()
                    showResult = false
                    showResultTable = false
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14))
                        Text("もう一度")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.errorRed)
                    .cornerRadius(6)
                }
            }
        }
    }

    private var resultTable: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "tablecells.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.accentGold)
                Text("実行結果")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.headerBrown)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 0) {
                        ForEach(vm.problem.resultTableData.headers, id: \.self) { header in
                            Text(header)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(minWidth: 80, alignment: .leading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 7)
                                .background(Color.accentGold)
                                .border(Color.white.opacity(0.3), width: 0.5)
                        }
                    }

                    // Rows
                    ForEach(vm.problem.resultTableData.rows.indices, id: \.self) { i in
                        HStack(spacing: 0) {
                            ForEach(vm.problem.resultTableData.rows[i], id: \.self) { cell in
                                Text(cell)
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.headerBrown)
                                    .frame(minWidth: 80, alignment: .leading)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 7)
                                    .background(i % 2 == 0 ? Color.appBackground : Color.white)
                                    .border(Color.borderColor.opacity(0.3), width: 0.5)
                            }
                        }
                    }
                }
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentGold.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private var borderStrokeColor: Color {
        switch vm.quizState {
        case .answering: return Color.borderColor.opacity(0.5)
        case .correct: return Color.successGreen
        case .incorrect: return Color.errorRed
        }
    }

    private var placedBlocks: [BlockQuizViewModel.AnswerBlock] { vm.placedBlocks }
}

// MARK: - Block Tile

private struct BlockTile: View {
    let text: String
    let style: Style
    let state: BlockQuizViewModel.QuizState

    enum Style { case available, placed }

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .monospaced))
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1.5)
            )
    }

    private var foregroundColor: Color {
        switch style {
        case .available: return .headerBrown
        case .placed:
            switch state {
            case .answering: return .white
            case .correct: return .white
            case .incorrect: return .white
            }
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .available: return Color.accentGold.opacity(0.12)
        case .placed:
            switch state {
            case .answering: return Color.accentGold.opacity(0.2)
            case .correct: return Color.successGreen.opacity(0.85)
            case .incorrect: return Color.errorRed.opacity(0.85)
            }
        }
    }

    private var borderColor: Color {
        switch style {
        case .available: return Color.accentGold.opacity(0.4)
        case .placed:
            switch state {
            case .answering: return Color.accentGold
            case .correct: return Color.successGreen
            case .incorrect: return Color.errorRed
            }
        }
    }
}

// MARK: - Flow Layout（ブロックの折り返し）

private struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { $0.size.height }.max() ?? 0 }.reduce(0, +)
            + CGFloat(max(rows.count - 1, 0)) * spacing
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.size.height }.max() ?? 0
            for item in row {
                item.subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(item.size))
                x += item.size.width + spacing
            }
            y += rowHeight + spacing
        }
    }

    private struct RowItem {
        let subview: LayoutSubview
        let size: CGSize
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[RowItem]] {
        let maxWidth = proposal.width ?? 320
        var rows: [[RowItem]] = []
        var currentRow: [RowItem] = []
        var currentWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentWidth + size.width > maxWidth, !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = [RowItem(subview: subview, size: size)]
                currentWidth = size.width + spacing
            } else {
                currentRow.append(RowItem(subview: subview, size: size))
                currentWidth += size.width + spacing
            }
        }
        if !currentRow.isEmpty { rows.append(currentRow) }
        return rows
    }
}

// MARK: - Shake Modifier

private struct ShakeModifier: ViewModifier {
    let trigger: Bool

    func body(content: Content) -> some View {
        content
            .offset(x: trigger ? -8 : 0)
            .animation(
                trigger ? .interpolatingSpring(stiffness: 600, damping: 8).repeatCount(3, autoreverses: true) : .default,
                value: trigger
            )
    }
}

// MARK: - Preview

#Preview {
    BlockQuizView(problem: Problem.allLessons[2], onNext: {})
}
