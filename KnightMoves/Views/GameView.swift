//
//  GameView.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    let rows = 6
    let columns = 6
    let boardSize: CGFloat = 300
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    var content: some View {
        VStack {
            ZStack {
                chessboard
                touchOverlay
            }
        }
    }
    
    var touchOverlay: some View {
        GeometryReader { proxy in
            ForEach(0..<rows, id: \.self) { row in
                ForEach(0..<columns, id: \.self) { column in
                    let square = Square(row: row, column: column)
                    Rectangle()
                        .fill(viewModel.selectedSquares.contains(square) ? Color.yellow.opacity(0.8) : Color.clear)
                        .frame(
                            width: proxy.size.width / CGFloat(columns),
                            height: proxy.size.height / CGFloat(rows)
                        )
                        .position(
                            x: (proxy.size.width / CGFloat(columns)) * CGFloat(column) + (proxy.size.width / CGFloat(columns) / 2),
                            y: (proxy.size.height / CGFloat(rows)) * CGFloat(row) + (proxy.size.height / CGFloat(rows) / 2)
                        )
                    attachKnightPawn(proxy: proxy, row: row, column: column, square: square)
                        .onTapGesture {
                            viewModel.toggleSquare(square)
                        }
                }
            }
        }
        .frame(width: boardSize, height: boardSize)
    }
    
    @ViewBuilder
    func attachKnightPawn(proxy: GeometryProxy, row: Int, column: Int, square: Square) -> some View {
        if viewModel.getStart() == square {
            Image("Knight")
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
    
    var chessboard: some View {
        ChessboardView(rows: rows, columns: columns)
            .fill(.black)
            .frame(height: boardSize)
    }
    
    
}

