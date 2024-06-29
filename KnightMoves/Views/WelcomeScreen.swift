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
        }
    }
    
    var image: some View {
        Image("logo")
    }
    
    var playButton: some View {
        Button {
            //TODO add action or turn this into navlink
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
