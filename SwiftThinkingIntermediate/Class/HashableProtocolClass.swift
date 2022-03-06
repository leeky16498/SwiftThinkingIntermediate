//
//  HashableProtocolClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct MyCustomModel : Hashable {
    
    let title : String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    } // 유니트한 해셔블 밸류를 만들어 준다.
    
}

struct HashableProtocolClass: View {
    
    let data : [MyCustomModel] = [
       MyCustomModel(title: "One"),
       MyCustomModel(title: "two"),
       MyCustomModel(title: "three"),
       MyCustomModel(title: "four"),
       MyCustomModel(title: "One"),
    ]
    
    //스트링이 해셔블 해셔블 프로토콜을 통해서 변한다.
    
    var body: some View {
        
       ScrollView{
            VStack{
                ForEach(data, id: \.self) { item in
                    Text(item.hashValue.description)
                        .font(.headline)
                }
                
//                ForEach(data) { item in
//                    Text(item.title.hashValue.description)
//                        .font(.headline)
//                    //해셔블과 UUID는 비슷한 속성을 갖고 있다.
//
//                    //뒤에 해쉬밸류, 디스크립션이라는 단어를 쓰게되면 다음과 같이 숫자화 되어 저장된다.
//                }
            }
       }
    }
}

struct HashableProtocolClass_Previews: PreviewProvider {
    static var previews: some View {
        HashableProtocolClass()
    }
}
