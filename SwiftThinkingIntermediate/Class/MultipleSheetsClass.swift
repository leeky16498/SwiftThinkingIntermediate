//
//  MultipleSheetsClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct RandomModel : Identifiable {
    let id = UUID()
    let title : String
}


struct MultipleSheetsClass: View {
//
//    @State var isPresented : Bool = false
//    @State var selectedModel : RandomModel = RandomModel(title: "Start title")
    @State var selectedModel : RandomModel? = nil
    
    var body: some View {
//        VStack{
//            Button(action: {
//                selectedModel = RandomModel(title: "One")
////                isPresented.toggle()
//            }, label: {
//              Text("1")
//            })
//
//            Button(action: {
//                selectedModel = RandomModel(title: "Two")
////                isPresented.toggle()
//            }, label: {
//                Text("2")
//            })
//        }
//        .sheet(item: $selectedModel) { model in
//            NextScreen(selectedModel: model)
//            //selected 모델이 바뀔때마다 신호를 내보내주고 이것을 포착해서 쉬트를 띄워준다.
//        }
        ScrollView {
            VStack {
                ForEach(0..<50) { index in
                    Button("Button \(index)") {
                        selectedModel = RandomModel(title: "\(index)")
                    }
                }
            }
            .sheet(item: $selectedModel) { model in
                NextScreen(selectedModel: model)
            }
        }
    }
}

struct NextScreen : View {
    
    var selectedModel : RandomModel
    //응 바인딩 해주면 그만이야~~
    
    var body : some View {
        Text(selectedModel.title)
            .font(.largeTitle)
    }
    
}

struct MultipleSheetsClass_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSheetsClass()
    }
}
