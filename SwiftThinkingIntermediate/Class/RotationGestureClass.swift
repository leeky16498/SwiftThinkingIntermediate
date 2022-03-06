//
//  RotationGestureClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct RotationGestureClass: View {
    
    @State var angle : Angle = Angle(degrees: 0)
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue.cornerRadius(10))
            .rotationEffect(angle)
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        angle = value
                    }
                    .onEnded {value in
                        withAnimation(.spring()) {
                            angle = Angle(degrees: 0)
                        }
                    }
            
            )
    }
}

struct RotationGestureClass_Previews: PreviewProvider {
    static var previews: some View {
        RotationGestureClass()
    }
}
