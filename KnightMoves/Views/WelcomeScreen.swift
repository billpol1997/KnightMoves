//
//  WelcomeScreen.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import SwiftUI

struct WelcomeScreen: View {
    //MARK: variables
    @State var chessboardSize: Double = 0
    @StateObject var viewModel: WelcomeViewModel
    
    //MARK: Init
    init(viewModel: WelcomeViewModel) {
        self._viewModel = StateObject(wrappedValue: DIContainer.shared.getContainerSwinject().resolve(WelcomeViewModel.self)!)
    }
    
    //MARK: Body
    var body: some View {
        content
            .onChange(of: chessboardSize) { newValue in
                self.viewModel.setSize(size: newValue)
            }
    }
    
    //MARK: SubViews
    var content: some View {
        VStack(spacing: 16) {
            image
            Text(self.viewModel.appTitle)
                .foregroundColor(.black)
                .font(.title)
            chessboardSizeSlider
            playButton
            Spacer()
        }
    }
    
    var image: some View {
        Image("logo")
            .resizable()
            .frame(width: 300, height: 500)
    }
    
    //MARK: Button
    var playButton: some View {
        NavigationLink {
            DIContainer.shared.getContainerSwinject().resolve(GameView.self, argument: self.viewModel.chessboardSize)!
        } label: {
            HStack {
                Text(self.viewModel.playButtonText)
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding(16)
            .background(.black)
            .cornerRadius(16)
        }
        
    }
    
    //MARK: Slider
    var chessboardSizeSlider: some View {
        VStack(spacing: 8) {
            Text(self.viewModel.chooseSizeText)
            Slider(value: $chessboardSize, in: 6...16)
                .tint(.black)
            Text("\(Int(chessboardSize))")
        }
        .foregroundColor(.black)
        .font(.body)
        .padding(.horizontal, 16)
    }
}
