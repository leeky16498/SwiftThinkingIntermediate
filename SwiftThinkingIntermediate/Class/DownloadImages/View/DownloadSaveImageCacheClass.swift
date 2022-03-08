//
//  DownloadSaveImageCacheClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import SwiftUI


//codable
//background threads
//weak self
//combine
//publisher and subscribers
//filemanager
//nscache

struct DownloadSaveImageCacheClass: View {
    
    @StateObject var vm = DownloadingImageViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.dataArray) { model in
                    DownloadingImagesRow(model: model)
                }
            }
            .navigationTitle("List")
        }
    }
}

struct DownloadSaveImageCacheClass_Previews: PreviewProvider {
    static var previews: some View {
        DownloadSaveImageCacheClass()
    }
}
