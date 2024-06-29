//
//  WelcomeViewModel.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import Foundation

final class WelcomeViewModel: ObservableObject {
    @Published var chessboardSize: Int = 0
    
    func setSize(size: Double) {
        self.chessboardSize = Int(size)
    }
}
