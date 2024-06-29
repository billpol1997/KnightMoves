//
//  DIContainer.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import Foundation
import Swinject

public protocol SwinjectInterface{
    func getContainerSwinject() -> Container
}

final class DIContainer: SwinjectInterface {
    static let shared = DIContainer()
    
    var diContainer: Container {
        let container = Container()
        
        container.register(WelcomeScreen.self) { r in
            WelcomeScreen(viewModel: r.resolve(WelcomeViewModel.self)!)
        }
        
        container.register(WelcomeViewModel.self) { _ in
            WelcomeViewModel()
        }
        
        container.register(GameView.self) { r in
            GameView(viewModel: r.resolve(GameViewModel.self)!)
        }
        
        container.register(GameViewModel.self) { r, size in
            GameViewModel(chessboardSize: size)
        }
        
        return container
    }
   
    func getContainerSwinject() -> Container {
        return diContainer
    }
    
}
