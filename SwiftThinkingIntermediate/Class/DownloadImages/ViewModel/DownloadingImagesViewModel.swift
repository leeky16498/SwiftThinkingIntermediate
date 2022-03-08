//
//  DownloadingImagesViewModel.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import Foundation
import Combine

class DownloadingImageViewModel : ObservableObject {
    
    @Published var dataArray : [PhotoModel] = []
    
    let dataService = PhotoModelDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        dataService.$photoModel
            .sink { [weak self] (returnedPhotoModel) in
                DispatchQueue.main.async {
                    self?.dataArray = returnedPhotoModel
                } // 비동기 처리
            }
            .store(in: &cancellables)
    }
    
}
