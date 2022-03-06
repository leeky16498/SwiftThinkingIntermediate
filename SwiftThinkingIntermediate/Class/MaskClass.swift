//
//  MaskClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct MaskClass: View {
    
    @State var rating: Int = 0
    
    var body: some View {
        ZStack{
           starsView
                .overlay(
                    overlayView
                        .mask(starsView)
                )
        }
    }
    
    var overlayView : some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue,.red,.blue,.yellow]), startPoint: .leading, endPoint: .trailing))
                    .frame(width : CGFloat(rating) / 5 * proxy.size.width)
            }
        }
        .allowsHitTesting(false)
    }
    
    
    var starsView: some View {
        HStack{
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundColor(rating >= index ? Color.yellow : Color.gray)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            rating = index
                        }
                    }
            }
        }
    }
}

struct MaskClass_Previews: PreviewProvider {
    static var previews: some View {
        MaskClass()
    }
}
