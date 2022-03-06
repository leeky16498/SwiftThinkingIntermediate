//
//  WeakselfClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

struct WeakselfClass: View {
    
    @AppStorage("count") var count : Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate", destination: WeakSelfSecondScreen())
        }
        .overlay(
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
            ,alignment: .topTrailing
        )
    }
}

struct WeakSelfSecondScreen : View {
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        Text("Second View")
            .font(.largeTitle)
            .foregroundColor(.red)
        
        if let data = vm.data {
            Text(data)
        }
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    
    @Published var data : String? = nil
    
    init() {
        print("initialized now")
        
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        
        getData()
    }
    
    deinit {
        print("Deinitialized now")
        
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
        DispatchQueue.global().async {
            self.data = "new Data!" // 아주 강한 레퍼런스이다. 이거는 시스템에게 이거는 무조건 기억해! 라고 말하고 있는 것이다.
            //하지만 인터넷 작업을 할 경우에, 유저는 이거를 내비두고 다른 걸 할수도 있다.
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 500) { [weak self] in
            self?.data = "NEW DATA!"
        }
    //이렇게 하면 디이셜라이즈가 호출이 안되어서 currentCount가 올라간다. 뭔 말이냐 그렇게 되면 저 500초 간의 작업을 유저는 기다려야 한다. 계에속~~
    //이게 개발자에게는 매우 중요하다. 앱의 쾌적함과 관련이 있기 때문이다.
    //자 이제 weak self 를 통해서 선언을 해주게 되면, 레퍼런스가 증가하지를 않는다. 저렇게 해주면 메모리가 증가하지 않는다.
    }
    
}

struct WeakselfClass_Previews: PreviewProvider {
    static var previews: some View {
        WeakselfClass()
    }
}
