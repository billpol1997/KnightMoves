//
//  GameView.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State var showPossiblePaths: Bool = false
    @State var isSelectionOver: Bool = false
    @State var isPathImpossible: Bool = false
    let rows: Int
    let columns: Int
    let boardSize: CGFloat = 400
    
    init(viewModel: GameViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.rows = viewModel.chessboardSize
        self.columns = viewModel.chessboardSize
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden()
    }
    
    var content: some View {
        VStack {
            dismissButton
                .padding(.top, 16)
            Spacer()
            gameHelperLabel
                .padding(.bottom, 8)
            field
            Spacer()
            gameButtons
                .padding(.bottom, 16)
        }
        .onChange(of: self.viewModel.isPathImpossible) { newValue in
            withAnimation {
                self.isPathImpossible = newValue
                guard newValue else { return }
                self.showPossiblePaths = false
            }
        }
    }
    
    var field: some View {
        VStack {
            ZStack {
                chessboard
                touchOverlay
            }
        }
        .border(.black)
        .padding(.horizontal, 8)
    }
    
    var touchOverlay: some View {
        GeometryReader { proxy in
            ForEach(0..<rows, id: \.self) { row in
                ForEach(0..<columns, id: \.self) { column in
                    let square = Square(row: row, column: column)
                    Rectangle()
                        .fill(viewModel.selectedSquares.contains(square) ? Color.yellow.opacity(0.8) : Color.white.opacity(0.001)) // if the base color was clear swiftui wouldn't registered touch gestures
                        .frame(
                            width: proxy.size.width / CGFloat(columns),
                            height: proxy.size.height / CGFloat(rows)
                        )
                        .position(
                            x: (proxy.size.width / CGFloat(columns)) * CGFloat(column) + (proxy.size.width / CGFloat(columns) / 2),
                            y: (proxy.size.height / CGFloat(rows)) * CGFloat(row) + (proxy.size.height / CGFloat(rows) / 2)
                        )
                        .onTapGesture {
                            viewModel.toggleSquare(square)
                            isSelectionOver = viewModel.getStart() != nil && viewModel.getFinish() != nil
                        }
                    attachKnightPawn(proxy: proxy, row: row, column: column, square: square)
                }
            }
            displayPossiblePaths(proxy: proxy)
        }
        .frame(width: boardSize, height: boardSize)
    }
    
    @ViewBuilder
    func attachKnightPawn(proxy: GeometryProxy, row: Int, column: Int, square: Square) -> some View {
        if viewModel.getStart() == square {
            Image("pawn")
                .resizable()
                .scaledToFit()
                .frame(
                    width: proxy.size.width / CGFloat(columns),
                    height: proxy.size.height / CGFloat(rows)
                )
                .position(
                    x: (proxy.size.width / CGFloat(columns)) * CGFloat(column) + (proxy.size.width / CGFloat(columns) / 2),
                    y: (proxy.size.height / CGFloat(rows)) * CGFloat(row) + (proxy.size.height / CGFloat(rows) / 2)
                )
        }
    }
    
    @ViewBuilder
    func displayPossiblePaths(proxy: GeometryProxy) -> some View {
        if showPossiblePaths, let start = viewModel.getStart(), let finish = viewModel.getFinish(), start != Square(row: -1, column: -1), finish != Square(row: -1, column: -1) {
            let paths = viewModel.knightPaths(start: start, end: finish, maxMoves: 3)
            let bestPath = viewModel.getBestPath(paths: paths)
            ForEach(paths, id: \.self) { path in
                ForEach(path, id: \.self) { square in
                    Rectangle()
                        .fill(Color.green.opacity(0.5))
                        .frame(
                            width: proxy.size.width / CGFloat(columns),
                            height: proxy.size.height / CGFloat(rows)
                        )
                        .position(
                            x: (proxy.size.width / CGFloat(columns)) * CGFloat(square.column) + (proxy.size.width / CGFloat(columns) / 2),
                            y: (proxy.size.height / CGFloat(rows)) * CGFloat(square.row) + (proxy.size.height / CGFloat(rows) / 2)
                        )
                }
                
                Path { path in
                    let columnSize = proxy.size.width / CGFloat(columns)
                    let rowSize = proxy.size.height / CGFloat(rows)
                    
                    guard let firstSquare = bestPath.first else { return }
                    let startX = columnSize * CGFloat(firstSquare.column) + columnSize / 2
                    let startY = rowSize * CGFloat(firstSquare.row) + rowSize / 2
                    
                    path.move(to: CGPoint(x: startX, y: startY))
                    
                    for square in bestPath.dropFirst() {
                        let x = columnSize * CGFloat(square.column) + columnSize / 2
                        let y = rowSize * CGFloat(square.row) + rowSize / 2
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.red, lineWidth: 2)
                
            }
            .frame(width: boardSize, height: boardSize)
        }
    }
    
    var chessboard: some View {
        ChessboardView(rows: rows, columns: columns)
            .fill(.black)
            .frame(height: boardSize)
    }
    
    var moveButton: some View {
        Button {
            withAnimation {
                showPossiblePaths.toggle()
            }
        } label: {
            HStack {
                Text(!showPossiblePaths ? "Show path!" : "Hide possible paths!")
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding(16)
            .background(.black)
            .cornerRadius(24)
        }
    }
    
    @ViewBuilder
    var gameHelperLabel: some View {
        HStack {
            Text(self.isPathImpossible ? "There is no path within 3 moves between these tiles ": (isSelectionOver ? "Now Press the button to calculate the best path within 3 moves of the Knight" : "Select tiles for start and finish!"))
                .foregroundColor(.black)
                .font(.title)
        }
        .frame(height: 200)
        .padding(.horizontal, 8)
    }
    
    var resetBoardButton: some View {
        Button {
            withAnimation {
                self.showPossiblePaths = false
                self.viewModel.resetBoard()
            }
        } label: {
            HStack {
                Text("Rest chessboard")
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding(16)
            .background(.red.opacity(0.8))
            .cornerRadius(24)
        }
    }
    
    var gameButtons: some View {
        HStack(spacing: 16) {
            resetBoardButton
            moveButton
        }
    }
    
    var dismissButton: some View {
        HStack {
            Button {
                withAnimation {
                    dismiss()
                }
            } label: {
                HStack(spacing: 2) {
                    Image("arrow")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                    Text("Change size!")
                        .foregroundColor(.white)
                        .font(.footnote)
                }
                .padding(.vertical, 8)
                .padding(.trailing, 8)
                .background(LinearGradient(colors: [.blue, .green], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
            }
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
}

