//
//  EscapingClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 06/03/2022.
//

import SwiftUI

class EscapingViewModel : ObservableObject {
    
    @Published var text : String = "Hello"
    
    func getData() {
//        let newData = downloadData()
//        text = newData
         //여기 함수는 즉시 바로 결과를 뱉어낸다.
//        downloadData3 { [weak self] data in
//            self?.text = data
//        downloadData4 { results in
//            self.text = results.data
//        }
        
        downloadData5 { result in
            self.text = result.data
        }
    }
        
    
    func downloadData() -> String {
        return "New Data"
    }
    
    func downloadData2(completionHandler: (_ data : String) -> Void) {
        completionHandler("New Data")
//        return "NEW DATA"
         // 원래함수는 즉시 결과를 뱉지만, 지금 같이 시간차를 주는 경우 그렇지가 못하다. 특히 통신을 하는 경우에는 통신 지연으로 인해서 바로 데이터가 나오지 않는다.
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5 {
//            return "New Data"
        }
    
    func downloadData3(completionHandler: @escaping (_ data : String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            completionHandler("New Data")
        }
//        return "NEW DATA"
         // 원래함수는 즉시 결과를 뱉지만, 지금 같이 시간차를 주는 경우 그렇지가 못하다. 특히 통신을 하는 경우에는 통신 지연으로 인해서 바로 데이터가 나오지 않는다.
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5 {
//            return "New Data"
        //클로저를 호출할 때 시간차를 둬야할 때 탈출 클로저를 사용한다.
        }
    
    func downloadData4(completionHandler: @escaping (DownloadResult) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let result = DownloadResult(data: "New Data")
            completionHandler(result)
        }
    }
    
    func downloadData5(completionHandler: @escaping DownloadCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let result = DownloadResult(data: "New Data SHOT")
            completionHandler(result)
        }
    }
    //이게 진짜 효과적인 코딩이다.
    
    func doSomething(_ data : String) -> () {
        print(data)
        //() 이거도 결국은 Void랑 같은 말이다.
    }
    
}

struct DownloadResult {
    let data : String
}

typealias DownloadCompletion = (DownloadResult) -> ()

struct EscapingClass: View {
    
    @StateObject var vm : EscapingViewModel = EscapingViewModel()
    
    var body: some View {
        Text(vm.text)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .onTapGesture {
                vm.getData()
            }
    }
}

struct EscapingClass_Previews: PreviewProvider {
    static var previews: some View {
        EscapingClass()
    }
}
