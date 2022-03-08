//
//  DownloadingImageView.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import SwiftUI

struct DownloadingImageView: View {
    
    @StateObject var loader : ImageLoadingViewModel
    @State var isLoading : Bool = true // 이미지를 가져오는 동안의 로딩화면을 띄워줄 단계이다.
    
    init(url : String, key : String) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
            }
        }
    }
}
