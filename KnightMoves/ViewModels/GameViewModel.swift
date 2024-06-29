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
    
    func toggleSquare(_ square: Square) {
        if let index = selectedSquares.firstIndex(of: square) {
            selectedSquares.remove(at: index)
        } else {
            if selectedSquares.count >= 2 {
                selectedSquares.removeFirst()
            }
            selectedSquares.append(square)
        }
        
        // Ensure exactly two squares are selected
        if selectedSquares.count == 1 {
            selectedSquares.append(placeHolderSquare) // Placeholder
        } else if selectedSquares.count == 0 {
            selectedSquares.append(placeHolderSquare) // Placeholder
            selectedSquares.append(placeHolderSquare) // Placeholder
        }
    }
    
    func getStart() -> Square? {
       return  selectedSquares.first
    }
    
    func getFinish() -> Square? {
        return selectedSquares.count > 1 ? selectedSquares[1] : nil
    }
}


