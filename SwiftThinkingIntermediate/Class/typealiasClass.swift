//
//  typealiasClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct MovieModel {
    let title : String
    let director : String
    let count : Int
}

typealias TvModel = MovieModel

//struct TvModel {
//    let title : String
//    let director : String
//    let count : Int
//}

//자 보게되면, 타입앨리어스는 구조체의 형태가 같을 경우 그대로 복사해내는 거라고 보면 될 거 같아. 대단히 단순하고 쉬운 거였다리. 보면 무비모델의 구조체에 따라서 데이터 기입이 가능하다.

struct typealiasClass: View {
    
//    @State var item : MovieModel = MovieModel(title: "타이틀", director: "조", count: 5)
    
    @State var item : TvModel = TvModel(title: "티비 타이틀", director: "에밀리", count: 10)
    
    var body: some View {
        VStack{
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
    }
}
//typealias는 새로운 별명을 정해주는 거랑 비슷하다고 보면 된다.
//넷플릭스에는 무비모델 같은 것들이 있다고 볼 수 있지?
//근데 생각해보면 티비쇼도 대충 비슷한 자료들의 구성을 가지고 있을 거야?

struct typealiasClass_Previews: PreviewProvider {
    static var previews: some View {
        typealiasClass()
    }
}
