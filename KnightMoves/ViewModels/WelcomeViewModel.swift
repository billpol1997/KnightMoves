//
//  WelcomeViewModel.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import Foundation

final class WelcomeViewModel: ObservableObject {
    //MARK: variables
    @Published var chessboardSize: Int = 0
    
    //MARK: Texts
    let appTitle = "Knight moves"
    let playButtonText = "Get moving!"
    let chooseSizeText = "Please choose chessboard size!"
    
    //MARK: Functions
    func setSize(size: Double) {
        self.chessboardSize = Int(size)
    }
}
