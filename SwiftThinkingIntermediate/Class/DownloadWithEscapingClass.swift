//
//  DownloadWithEscapingClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 07/03/2022.
//

import SwiftUI

struct postModel : Identifiable, Codable {
    let userId : Int
    let id : Int
    let title : String
    let body : String
}

class DownloadWithEscapingViewModel : ObservableObject {
    
    @Published var posts : [postModel] = []
    
    init() {
        getPost()
       
    }
    
    func getPost() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        downloadData(fromURL: url) { data in
            if let data = data {
                guard let newPosts = try? JSONDecoder().decode([postModel].self, from: data) else { return }
                
//                print("여기")
                DispatchQueue.main.async { [weak self] in
                    self?.posts = newPosts
                }
            } else {
                print("failed")
            }
        }
        //여기에서 알아야 할 점, 바디를 만들고 바디의 배열로 받아줘야 한다. 바디를 받고, 하나일때는 추가해주고 배열일떄는 대체해주면 된다. 참으로 재미잇고 쉽다.
        
//        URLSession.shared.dataTask(with: url) {data, response, error in
//            guard
//                let data = data,
//                    error == nil,
//                let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300
//            else {return}
//
//
        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//
//            guard let data = data else {
//                print("no data")
//                return
//            }
//
//            guard error == nil else {
//                print("error = \(error)")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {
//                print("invalid response")
//                return
//            }
//
//            guard response.statusCode >= 200 && response.statusCode < 300 else {
//                print(response.statusCode)
//                return
//            }
//
//            print("Successfully downloaded.")
//            print(data)
//
//            let jsonString = String(data: data, encoding: .utf8)
//            print(jsonString)
            
        }
//        .resume()
    }
    
    func downloadData(fromURL url : URL, completionHandler: @escaping(_ data: Data?) ->()) {
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard
                let data = data,
                    error == nil,
                let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300
            else {return}
            
            completionHandler(data)
    }
        .resume()
    
}


struct DownloadWithEscapingClass: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack {
                    Text(post.title)
                    Text(post.body)
                }
            }
        }
    }
}

struct DownloadWithEscapingClass_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscapingClass()
    }
}
