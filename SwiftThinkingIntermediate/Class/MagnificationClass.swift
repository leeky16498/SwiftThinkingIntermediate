//
//  MagnificationClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct MagnificationClass: View {
    
    @State var currentAmount : CGFloat = 0
    @State var lastAmount : CGFloat = 0
    
    var body: some View {
        
        VStack{
            HStack{
                Circle()
                    .frame(width : 35, height : 35)
                Text("SwiftUI Thinking")
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding()
            
            Rectangle()
                .frame(height : 300)
                .scaleEffect(1+currentAmount)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentAmount = value - 1
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                currentAmount = 0
                            }
                        }
                
                )
            //인스타그램 사진 확대 기능이랑 비슷하다. 매그니피케이션이랑 스케일 이팩트를 합쳐서 운용한다.
                
            HStack {
                Image(systemName: "heart.fill")
                Image(systemName: "text.bubble.fill")
                Spacer()
            }
            .padding()
            .font(.headline)
            Text("This is my the caption for my Photos!")
                .frame(maxWidth : .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        
        
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .font(.title)
//            .padding(40)
//            .background(Color.red.cornerRadius(10))
//            .scaleEffect(1 + currentAmount)
//            .gesture(
//                MagnificationGesture()
//                    .onChanged { value in
//                        currentAmount = value - 1
//                    }
//                    .onEnded { value in
//                        lastAmount += currentAmount
//                        currentAmount = 0
//                    }
//            )
    }
}

struct MagnificationClass_Previews: PreviewProvider {
    static var previews: some View {
        MagnificationClass()
    }
}
