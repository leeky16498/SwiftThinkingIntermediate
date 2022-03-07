//
//  CordableClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

//codable = decodable + encodable

struct CustomerModel : Identifiable, Codable {
    
    let id : String
    let name : String
    let points : Int
    let isPremium : Bool
    
//    enum CodingKeys : String, CodingKey {
//        case id, name, points, isPremium
//    }
//
//    init(id : String, name : String, points : Int, isPremium : Bool) {
//        self.id = id
//        self.name = name
//        self.points = points
//        self.isPremium = isPremium
//    } // 이니셜 라이징을 통해서 각 변수의 초기값을 지정해줄 것이다.
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.points = try container.decode(Int.self, forKey: .points)
//        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(points, forKey: .points)
//        try container.encode(isPremium, forKey: .isPremium)
//    }
    //개쩌는 것이 코더블 프로토콜을 사용하면, 여기있는 모든 이니셜라이저와 열거형이 전부..사라지게 됩니다...^^
    //그래서 그렇게 저장하고 불러오는 거였음.
}


class CordableViewModel : ObservableObject {
    
    @Published var customer : CustomerModel? = nil
    
    init() {
        getData()
    }
    
    func getData() {
      guard let data = getJsonData() else { return }
        
        do {
            self.customer = try JSONDecoder().decode(CustomerModel.self, from : data)
            //이 한 줄로 파일 디코딩이 가능해진다.싱기방기리.
        }catch {
            print("Error")
        }
        
        
//        print(data)
//        let jsonString = String(data: data, encoding: .utf8)
//        print(jsonString)
//        if let localData = try? JSONSerialization.jsonObject(with: data, options: []),
//            let dict = localData as? [String:Any],
//            let id = dict["id"] as? String,
//            let name = dict["name"] as? String,
//            let points = dict["points"] as? Int,
//            let isPremium = dict["isPremium"] as? Bool
            //as는 타입캐스팅을 해주고 있는 상태이다. 옆에 있는 물음표는 나중에 공부해보자 !
            
//        {
            
//            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremiun: isPremium) // 이렇게 할 수는 있지만 이건 안전하고 좋은 방법은 아니다.
//            customer = newCustomer
//        }
    }
    
    func getJsonData() -> Data? {
        
        let customer = CustomerModel(id: "111", name: "nick", points: 10, isPremium: false)
        
        let jsonData = try? JSONEncoder().encode(customer)
        
//        let dict: [String :Any] = [
//            "id":"12345",
//            "name":"Joe",
//            "points": 5,
//            "isPremium" : true
//        ]
        //JSON파일의 내용이 되는 딕셔너리를 제작
        
//        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
//        // 딕셔너리를 제이슨파일로 변환해줬다.
        
        return jsonData
    }
    
    
}

struct CordableClass: View {
    
    @StateObject var vm = CordableViewModel()
    
    var body: some View {
        VStack(spacing : 20){
            if let customer = vm.customer {
                Text(customer.id)
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
            }
        }
    }
}

struct CordableClass_Previews: PreviewProvider {
    static var previews: some View {
        CordableClass()
    }
}
