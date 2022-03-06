//
//  GeometryReaderClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct GeometryReaderClass: View {
    
    func getPercentage(geo : GeometryProxy) -> Double {
        let maxDistance = UIScreen.main.bounds.width / 2
        let currentX = geo.frame(in: .global).midX
        
        return Double(1 - (currentX / maxDistance))
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(0..<20) { index in
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: 10)
                            .rotation3DEffect(Angle(degrees: getPercentage(geo: proxy)*10), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(width : 300, height : 250)
                    .padding()
                    
                }
            }
        }
        
        
//        GeometryReader { proxy in
//            HStack(spacing:0) {
//                Rectangle()
//                    .fill(Color.red)
//                    .frame(width: proxy.size.width * 0.6666)
//                //.frame(width : UIscreen.main.bounds.width랑 지금 똑같다
//
//                Rectangle().fill(Color.blue)
//            }
//            .ignoresSafeArea()
//        }
    }
}

struct GeometryReaderClass_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderClass()
    }
}
