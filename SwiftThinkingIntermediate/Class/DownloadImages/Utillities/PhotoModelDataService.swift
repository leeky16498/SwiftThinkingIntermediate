//
//  PhotoModelDataService.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import Foundation
import Combine

class PhotoModelDataService {
    
    static let instance = PhotoModelDataService() // 싱글톤
    
    @Published var photoModel : [PhotoModel] = []
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        downloadData()
    }
    
    func downloadData() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {fatalError()}
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap(handleOutput)
            .decode(type: [PhotoModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error downloading data")
                }
            } receiveValue: { [weak self] (returnedPhotoModel) in
                self?.photoModel = returnedPhotoModel
            }
            .store(in: &cancellables)

        
    }
    
    func handleOutput(output : URLSession.DataTaskPublisher.Output) throws -> Data {
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw URLError(.badServerResponse)
              }
        return output.data
        
    }
    
}
