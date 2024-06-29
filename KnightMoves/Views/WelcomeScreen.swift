//
//  WelcomeScreen.swift
//  KnightMoves
//
//  Created by Bill on 29/6/24.
//

import SwiftUI

struct WelcomeScreen: View {
    
    var body: some View {
        content
    } 
    
    var content: some View {
        VStack(spacing: 16) {
            image
            Text("Knight moves")
                .foregroundColor(.black)
                .font(.title)
            playButton
            Spacer()
        }
    }
    
    var image: some View {
        Image("logo")
            .resizable()
            .frame(width: 200, height: 300)
    }
    
    var playButton: some View {
        NavigationLink {
            GameView()
        } label: {
            HStack {
                Text("Get moving!")
                    .foregroundColor(.white)
                    .font(.body)
            }
            .background(.black)
            .cornerRadius(16)
        }
        
    }
}

#Preview {
    WelcomeScreen()
}
