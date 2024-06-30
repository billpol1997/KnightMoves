//
//  PathCalculationTests.swift
//  KnightMovesTests
//
//  Created by Bill on 30/6/24.
//

import XCTest
@testable import KnightMoves

final class PathCalculationTests: XCTestCase {
    
    let chessboardSize = 16
    
    let gameVm = GameViewModel(chessboardSize: 16)
    
    //MARK: GameViewModel.isWithinBounds() test scenarios
    func testBoundsCheck() { // Happy path test case with Square within bounds
        let randomRow = Int.random(in: 0...chessboardSize)
        let randomColumn = Int.random(in: 0...chessboardSize)
        
        let square = Square(row: randomRow, column: randomColumn)
        let isValid = gameVm.isWithinBounds(square, rows: chessboardSize, columns: chessboardSize)
        
        XCTAssertTrue(isValid)
    }
    
    func testBoundCheckError() { // Error test case with Square out of bounds
        let randomRow = Int.random(in: chessboardSize...(chessboardSize * 10))
        let randomColumn = Int.random(in: chessboardSize...(chessboardSize * 10))
        
        let square = Square(row: randomRow, column: randomColumn)
        let isValid = gameVm.isWithinBounds(square, rows: chessboardSize, columns: chessboardSize)
        
        XCTAssertFalse(isValid)
    }
    
    //MARK: GameViewModel.knightPaths() test scenarios
    
    func testCalculatingPaths() { // Happy path test case with end Square that can be reached within 3 moves
        let start = Square(row: 1, column: 5)
        let end = Square(row: 5, column: 5)
        let maxMoves = 3
        
        let paths = gameVm.knightPaths(start: start, end: end, maxMoves: maxMoves)
        let isValid = !(paths.isEmpty)
        XCTAssertTrue(isValid)
    }
    
    func testCalculatingPathsError() { // Error test case with Square out of bounds
        let start = Square(row: -1, column: 5)
        let end = Square(row: 5, column: 5)
        let maxMoves = 3
        
        let paths = gameVm.knightPaths(start: start, end: end, maxMoves: maxMoves)
        let isValid = paths.isEmpty
        
        XCTAssertTrue(isValid)
    }
    
    func testCalculatingPathsImpossiblePath() { // Impossible path within 3 moves test case
        let start = Square(row: 1, column: 1)
        let end = Square(row: 5, column: 5)
        let maxMoves = 3
        
        let paths = gameVm.knightPaths(start: start, end: end, maxMoves: maxMoves)
        let isValid = paths.isEmpty
        
        XCTAssertTrue(isValid)
    }
    
    func testCalculatingPathsBestPath() { // test case best path
        let start = Square(row: 1, column: 3)
        let end = Square(row: 3, column: 5)
        let maxMoves = 3
        
        let paths = gameVm.knightPaths(start: start, end: end, maxMoves: maxMoves)
        let best = gameVm.getBestPath(paths: paths)
        guard !(paths.isEmpty) else { return }
        var randomOtherPath = paths[Int.random(in: 0..<paths.count)]
        while randomOtherPath == best {
            randomOtherPath = paths[Int.random(in: 0..<paths.count)]
        }
        let isValid = best.count < randomOtherPath.count
        
        XCTAssertTrue(isValid)
    }
}
