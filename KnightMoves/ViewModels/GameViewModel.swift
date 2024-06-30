//
//  GameViewModel.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import Foundation
import SwiftUI

struct Square: Hashable {
    let row: Int
    let column: Int
}

final class GameViewModel: ObservableObject {
    //MARK: variables
    @Published var selectedSquares: [Square] = []
    var chessboardSize: Int
    @Published var isPathImpossible: Bool = false
    let placeHolderSquare = Square(row: -1, column: -1)
    let maxMoves: Int = 3
    let knightMoves = [
        (2, 1), (2, -1), (-2, 1), (-2, -1),
        (1, 2), (1, -2), (-1, 2), (-1, -2)
    ]
    
    //MARK: Texts
    let appTitle = "Knight moves"
    let showPathText = "Show path!"
    let hidePathText = "Hide possible paths!"
    let impossibleText = "There is no path within 3 moves between these tiles!"
    let pressButtonText = "Now Press the button to calculate the best path within 3 moves of the Knight!"
    let selectTilesText = "Select tiles for start and finish!"
    
    //MARK: Init
    init(chessboardSize: Int) {
        self.chessboardSize = chessboardSize
    }
    
    //MARK: Functions
    func toggleSquare(_ square: Square) {
        if let index = selectedSquares.firstIndex(of: square) {
            selectedSquares.remove(at: index)
        } else {
            if selectedSquares.count >= 2 {
                selectedSquares.removeFirst()
            }
            selectedSquares.append(square)
        }
    }
    
    //MARK: Getters
    func getStart() -> Square? {
        return  selectedSquares.first
    }
    
    func getFinish() -> Square? {
        return selectedSquares.count > 1 ? selectedSquares[1] : nil
    }
    
    func getBestPath(paths: [[Square]]) -> [Square] {
        return paths.min { $0.count < $1.count} ?? []
    }
    
    //MARK: Path calculation
    func isWithinBounds(_ square: Square, rows: Int, columns: Int) -> Bool {
        return square.row >= 0 && square.row < rows && square.column >= 0 && square.column < columns
    }
    
    func knightPaths(start: Square, end: Square, maxMoves: Int) -> [[Square]] {
        guard isWithinBounds(start, rows: chessboardSize, columns: chessboardSize) && isWithinBounds(end, rows: chessboardSize, columns: chessboardSize) else { return [] }
        
        var paths: [[Square]] = []
        var queue: [(Square, [Square], Int)] = [(start, [start], 0)]
        
        while !queue.isEmpty {
            let (current, path, moves) = queue.removeFirst()
            
            if current == end {
                paths.append(path)
                continue
            }
            
            if moves < maxMoves {
                for move in knightMoves {
                    let nextSquare = Square(row: current.row + move.0, column: current.column + move.1)
                    if isWithinBounds(nextSquare, rows: chessboardSize, columns: chessboardSize) && !path.contains(nextSquare) {
                        queue.append((nextSquare, path + [nextSquare], moves + 1))
                    }
                }
            }
        }

        self.setImpossblePath(paths: paths)
        self.resetImpossiblePath()
        
        return paths
    }
    
    func setImpossblePath(paths: [[Square]]) { // DispatchQueue to avoid publishing changes to view from background thread
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isPathImpossible = paths.isEmpty
        }
    }
    
    //MARK: Reset
    func resetBoard() {
        self.selectedSquares = []
    }
    
    func resetImpossiblePath() {
        guard self.isPathImpossible else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in // DispatchQueue to avoid publishing changes to view from background thread
            guard let self else { return }
            self.isPathImpossible = false
        }
    }
}


