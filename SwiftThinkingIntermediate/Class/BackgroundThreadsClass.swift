//
//  BackgroundThreadsClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

class BackgroundThreadViewModel : ObservableObject {
    
    @Published var dataArray : [String] = []
    
    func fetchingData() {
        
        DispatchQueue.global(qos: .background).async {
            let newData = self.downloadData()
            
            print("CHECK1: \(Thread.isMainThread)") // 메인스레드 작업이 아니라고 알려줌
            print("CHECK2: \(Thread.current)") // 6번 스레드에서 작업
            
            //진짜 싱기하네여. 하면 됩니다 뭐든지.
            
            
            DispatchQueue.main.async {
                self.dataArray = newData
            }
        } // 다른스레드로 작업을 옮겨준다.
    } // 작업을 옮겨주되 어디에서 이루어 지는 작업인지 정확하게 주소를 알려주기 위해서 self를 명시해준다.
    
    func downloadData() -> [String] {
        var data : [String] = []
        
        for i in 0..<100 {
            data.append("\(i)")
            print(data)
        } // 함수선언시는 ForEach가 안 먹습니다....참눼.....하나 알아가네여
        
        return data
    }
}
//thread1은 메인 스레드이다. 뷰를 그려주는데 쓰인다. 그래서 데이터를 로드하면 스레드에서 스파이크가 튀게 된다.
//이건 작업이 이루어지면서 스레드가 일을 하는 건데 여기에 부하가 많이 걸리면 앱이 죽습니다.

struct BackgroundThreadsClass: View {
    
    @StateObject var vm = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Text("Load Data")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchingData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                        .foregroundColor(.red)
                        
                }
            }
        }
    }
}

struct BackgroundThreadsClass_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundThreadsClass()
    }
}
