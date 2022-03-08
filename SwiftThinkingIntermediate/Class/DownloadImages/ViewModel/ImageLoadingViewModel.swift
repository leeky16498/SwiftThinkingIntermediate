//
//  ImageLoadingViewModel.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import Foundation
import SwiftUI
import Combine

class ImageLoadingViewModel : ObservableObject {
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    
    var cancellables = Set<AnyCancellable>()
    let manager = PhotoModelCacheManager.instance
    
    let urlString : String
    let imagekey : String
    
    init(url: String, key : String) {
        imagekey = key
        urlString = url
        getImage()
    }
    
    func getImage() {
        if let savedImage = manager.get(key: imagekey) {
            image = savedImage
            print("getting saved Image")
        } else {
            downloadImage()
            print("downloading image now!")
        }
    }
    
    func downloadImage() {
        print("downloading Image now!")
        isLoading = true
        
        guard let url = URL(string: urlString)
        else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map{ UIImage(data: $0.data)}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                guard let self = self,
                      let image = returnedImage else {return}
                self.image = returnedImage
                self.manager.add(key: self.imagekey, value: image)
//                self?.image = returnedImage
//
            }
            .store(in: &cancellables)

        
//            .map{(data, response) -> UIImage? in
//                return UIImage(data: data)위아래 똑같음.
        
    }
}
