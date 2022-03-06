//
//  ScrollViewReaderClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct ScrollViewReaderClass: View {
    
    @State var textFieldText : String = ""
    @State var scrollIndex : Int = 0
    
    var body: some View {
        VStack {
            
            TextField("enter the number", text: $textFieldText)
                .frame(height : 55)
                .border(Color.gray)
                .keyboardType(.numberPad)
            
            Button(action: {
                withAnimation {
                    if let index = Int(textFieldText) {
                        scrollIndex = index
                    }
                }
                //앵커에는 탑, 센터, 닐이 있고 옆에 원하는 번호를 적어줌으로서 알아볼 수 있다.
            }, label: {
                Text("Click here to go 30")
            })
            
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach(0..<50) { index in
                        Text("this is \(index)")
                            .font(.headline)
                            .frame(width : 200)
                            .padding()
                            .id(index)
                    }
                    .onChange(of: scrollIndex) { value in
                        proxy.scrollTo(value, anchor: .top)
                    }
                }
            }
        }
    }
}

struct ScrollViewReaderClass_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReaderClass()
    }
}
