//
//  SortFilterMapClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct UserModel : Identifiable {
    let id = UUID()
    let name : String?
    let points : Int
    let isVerified : Bool
}

class arrayModificationViewModel : ObservableObject {
    
    @Published var dataArray : [UserModel] = []
    @Published var filteredArray : [UserModel] = []
    @Published var mappedArray : [String] = []
    
    init() {
        getUsers()
//        updateFilterArray()
    }
    
    func updateFilterArray() {
        //sort Examples
        
//        filteredArray = dataArray.sorted { (user1, user2) -> Bool in // 여기의 유저는 그냥 비교하기 위한 2개의 아이템임
//            return user1.points > user2.points
//        }
        
//        filteredArray = dataArray.sorted(by: {$0.points < $1.points }) // 위에랑 똑같은 의미이다.
        
        //filter Examples
//        filteredArray = dataArray.filter({ (user) -> Bool in
//            return user.name.contains("i")
//        })
        
//        filteredArray = dataArray.filter({$0.isVerified})
        //map
//        mappedArray = dataArray.map({ (user) -> String in
//            return user.name
//        })
        
//        mappedArray = dataArray.map({$0.name}) // 위에랑 똑같은 의미이다.
        
//        mappedArray = dataArray.map({ (user) -> String in
//            return user.name ?? ""
//        })
        
//        mappedArray = dataArray.compactMap({ (user) -> String? in
//            return user.name
//        }) // 아래의 함수랑 다 같은 말이다.
        
//        mappedArray = dataArray.compactMap{($0.name)}
//
//        let sort = dataArray.sorted(by: {$0.points > $1.points})
//        let filter = dataArray.filter({$0.isVerified})
//        let map = dataArray.map({$0.name})
        
        mappedArray = dataArray
            .sorted(by: {$0.points > $1.points})
            .filter({$0.isVerified})
            .compactMap({$0.name})
    }
    //조닌 간단한 고차함수로 깖끔하게 정리. 이건 중요합니다 :)
    
    
    func getUsers() {
        let user1 = UserModel(name: "nick", points: 5, isVerified: true)
        let user2 = UserModel(name: nil, points: 5, isVerified: false)
        let user3 = UserModel(name: "nick2", points: 3, isVerified: false)
        let user4 = UserModel(name: nil, points: 4, isVerified: true)
        let user5 = UserModel(name: "nick4", points: 5, isVerified: false)
        let user6 = UserModel(name: "nick5", points: 6, isVerified: true)
        let user7 = UserModel(name: "nick6", points: 5, isVerified: true)
        let user8 = UserModel(name: "nick7", points: 7, isVerified: true)
        let user9 = UserModel(name: "nick8", points: 5, isVerified: true)
        self.dataArray.append(contentsOf: [
        
        user1, user2, user3, user4, user5, user6, user7, user8, user9
        
        ])
    }
    
}

struct SortFilterMapClass: View {
    
    @StateObject var vm = arrayModificationViewModel()
    
    var body: some View {
        ScrollView{
            VStack(spacing: 10){
                ForEach(vm.dataArray) { user in
                    VStack(alignment: .leading) {
                        Text("username = \(user.name!)")
                        HStack {
                            Text("Point = \(user.points)")
                            Spacer()
                            
                            if user.isVerified {
                                Image(systemName: "flame.fill")
                            }
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue.cornerRadius(10))
            .padding(.horizontal)
        }
    }
}

struct SortFilterMapClass_Previews: PreviewProvider {
    static var previews: some View {
        SortFilterMapClass()
    }
}
