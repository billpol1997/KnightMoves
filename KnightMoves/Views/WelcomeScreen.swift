//
//  WelcomeScreen.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import SwiftUI

struct WelcomeScreen: View {
    @State var chessboardSize: Double = 0
    @StateObject var viewModel: WelcomeViewModel
    
    init(viewModel: WelcomeViewModel) {
        self._viewModel = StateObject(wrappedValue: DIContainer.shared.getContainerSwinject().resolve(WelcomeViewModel.self)!)
    }
    
    var body: some View {
        content
            .onChange(of: chessboardSize) { newValue in
                self.viewModel.setSize(size: newValue)
            }
    }
    
    var content: some View {
        VStack(spacing: 16) {
            image
            Text("Knight moves")
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
    
    var playButton: some View {
        NavigationLink {
            GameView(viewModel: DIContainer.shared.getContainerSwinject().resolve(GameViewModel.self, argument: self.viewModel.chessboardSize)!)
        } label: {
            HStack {
                Text("Get moving!")
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding(16)
            .background(.black)
            .cornerRadius(16)
        }
        
    }
    
    var chessboardSizeSlider: some View {
        VStack(spacing: 8) {
            Text("Please choose chessboard size!")
            Slider(value: $chessboardSize, in: 6...16)
                .tint(.black)
            Text("\(Int(chessboardSize))")
        }
        .foregroundColor(.black)
        .font(.body)
        .padding(.horizontal, 16)
    }
}
