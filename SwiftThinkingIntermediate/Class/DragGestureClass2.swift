//
//  DragGestureClass2.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct DragGestureClass2: View {
    
    @State var startingOffsetY : CGFloat = UIScreen.main.bounds.height * 0.85
    @State var currentDragOffsetY : CGFloat = 0
    @State var endingOffsetY : CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack {
                Image(systemName: "chevron.up")
                    .padding()
                
                Text("Sign up")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width : 100, height : 100)
                
                Text("This is the description for our app. This is my favorite SwiftUI course and I recommend to all of ym friends to subscribe to SwiftUI Thinking")
                    .multilineTextAlignment(.center)
                
                Text("Create an account")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.black.cornerRadius(10))
                Spacer()
            }
            .frame(maxWidth : .infinity)
            .background(.white)
            .cornerRadius(30)
            .offset(y : startingOffsetY)
            .offset(y: currentDragOffsetY)
            .offset(y: endingOffsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.spring()) {
                            currentDragOffsetY = value.translation.height
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if currentDragOffsetY < -150 {
                                endingOffsetY = -startingOffsetY
                                currentDragOffsetY = 0
                            } else if endingOffsetY != 0 && currentDragOffsetY > 150{
                                endingOffsetY = 0
                            } else {
                                currentDragOffsetY = 0
                            }
                        }
                    }
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DragGestureClass2_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureClass2()
    }
}
