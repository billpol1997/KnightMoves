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
    @Published var selectedSquares: [Square] = []
    let placeHolderSquare = Square(row: -1, column: -1)
    let knightMoves = [
        (2, 1), (2, -1), (-2, 1), (-2, -1),
        (1, 2), (1, -2), (-1, 2), (-1, -2)
    ]
    
    
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
    
    func getStart() -> Square? {
        return  selectedSquares.first
    }
    
    func getFinish() -> Square? {
        return selectedSquares.count > 1 ? selectedSquares[1] : nil
    }
    
    func isWithinBounds(_ square: Square, rows: Int, columns: Int) -> Bool {
        return square.row >= 0 && square.row < rows && square.column >= 0 && square.column < columns
    }
    
    func knightPaths(start: Square, end: Square, maxMoves: Int) -> [[Square]] {
        guard isWithinBounds(start, rows: 6, columns: 6) && isWithinBounds(end, rows: 6, columns: 6) else { return [] }
        
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
                    if isWithinBounds(nextSquare, rows: 6, columns: 6) && !path.contains(nextSquare) {
                        queue.append((nextSquare, path + [nextSquare], moves + 1))
                    }
                }
            }
        }
        
        return paths
    }
    
    func getBestPath(paths: [[Square]]) -> [Square] {
        return paths.min { $0.count < $1.count} ?? []
    }
    
}


