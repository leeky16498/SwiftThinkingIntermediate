//
//  DownloadingImagesRow.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import SwiftUI

struct DownloadingImagesRow: View {
    
    let model : PhotoModel
    
    var body: some View {
        HStack{
            DownloadingImageView(url: model.url, key: "\(model.id)")
                .frame(width : 75, height : 75)
            VStack {
                Text(model.title)
                    .font(.headline)
                Text(model.url)
                    .foregroundColor(.gray)
                    .italic()
            }
            .frame(maxWidth : .infinity, alignment: .leading)
        }
    }
}
