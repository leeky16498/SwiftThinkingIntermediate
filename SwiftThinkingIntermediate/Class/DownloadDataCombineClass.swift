//
//  DownloadDataCombineClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 07/03/2022.
//

import SwiftUI
import Combine

struct PostModel : Identifiable, Codable {
    let userId : Int
    let id : Int
    let title : String
    let body : String
}

class DownloadDataCombineViewModel {
    
    @Published var posts : [PostModel] = []
    var cancellable = Set<AnyCancellable>() // 얘를 통해서 원할 때 작업 캔슬을 한다는 것이다.
    
    init() {
        getPost()
    }
    
    func getPost() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        else {return} // url은 옵셔널이다.
        
        /*Comebine notation
        //Combine?
        //sign up for monthly subscription for pakage to be delivered
        //company would make the pakage behind the scene
        //recieve the pakage at your front door
        //make sure the box isnt damaged
        //open and make sure the item is correct
        //cancellable at anytime
        
        //아래 작업 순서가 가르치는 것
        //1. create publisher
        //2. subscribe publisher on background thread
        //3. receive on main thread
        //4. tryMap(check the data is good)
        //5. decode data into postmodels
        //6. sink(put the item into our app)
        //7. store(cancel subscription if needed)
         */
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))//백그라운드 스레드에서 작업.
            .receive(on: DispatchQueue.main) // 백그러운드의 작업을 메인 스레드로 불러오는 작업이고
        //이말은 뷰에서 그릴 준비를 하겠다는 말이다.
            .tryMap(handleOutput)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .replaceError(with: []) // 에러가 발생할 경우 비어있는 데이터를 리턴하도록 처리도 가능하다.
            .sink(receiveValue: { [weak self] (returnedPosts) in
                self?.posts = returnedPosts
            })

//            .sink { (completion) in
////                print("Completion : \(completion)")
//                switch completion {
//                case .finished:
//                    print("finished")
//                case.failure(let error):
//                    print("there is error : \(error)")
//                } // 컴플리션은 열거형의 결과값을 리턴해준다.
//            } receiveValue: { [weak self] (returnedPosts) in
//                    self?.posts = returnedPosts
//            }
            .store(in: &cancellable)
    }
    
    func handleOutput(output : URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    //가운데 데이터 처리를 별도로 빼서 간단하게 로직과 다음 로직 구분을 해주는것도 가능하다.
    
}

struct DownloadDataCombineClass: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { item in
                VStack{
                    Text(item.title)
                    Text(item.body)
                }
            }
        }
    }
}

struct DownloadDataCombineClass_Previews: PreviewProvider {
    static var previews: some View {
        DownloadDataCombineClass()
    }
}
