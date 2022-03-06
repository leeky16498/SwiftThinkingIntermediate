//
//  LongpressGestureClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct LongpressGestureClass: View {
    
    @State var isCompleted : Bool = false
    @State var isSuccess : Bool = false
    
    var body: some View {
//        Text(isCompleted ? "Completed" : "not completed")
//            .padding()
//            .background(isCompleted ? .red : .gray)
//            .cornerRadius(10)
//            .onTapGesture {
//                isCompleted.toggle()
//            }
//            .onLongPressGesture(minimumDuration: 1, maximumDistance: 50) {
//                isCompleted.toggle()
//            } 제스처에 대해서 시간과 공간을 정해줄 수 있다.
        
        
        VStack{
            
            Rectangle()
                .fill(Color.blue)
                .frame(maxWidth : isCompleted ? .infinity : 10)
                .frame(height : 55)
                .frame(maxWidth : .infinity, alignment: .leading)
                .background(.gray)
            
            HStack {
                Text("click here")
                    .foregroundColor(isSuccess ? .green : .white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .onLongPressGesture(minimumDuration: 1, maximumDistance: 50) { (isPressing) in
                        if isPressing {
                            withAnimation(.easeInOut(duration: 1)) {
                                isCompleted.toggle()
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                if !isSuccess {
                                    isCompleted = false
                                }
                            }
                        }
                    } perform: {
                        withAnimation(.easeInOut(duration: 1)) {
                            isSuccess = true
                        }
                    }//여기에서는 클로저를 통해서 누르는 동안의 동작을 정의해 줄 수 있다.
                
                Text("Reset")
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .onTapGesture {
                        isCompleted = false
                        isSuccess = false
                    }
                    
            }
        }
    }
}

struct LongpressGestureClass_Previews: PreviewProvider {
    static var previews: some View {
        LongpressGestureClass()
    }
}
