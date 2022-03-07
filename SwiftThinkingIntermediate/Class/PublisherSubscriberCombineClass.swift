//
//  PublisherSubscriberCombineClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 07/03/2022.
//

import SwiftUI
import Combine

class PubSubClassViewModel : ObservableObject {
    
    @Published var count = 0
    
//    var timer : AnyCancellable? // 언제든지 취소할 수 있다.
    var cancellables = Set<AnyCancellable>()
    
    @Published var textFieldText : String = ""
    @Published var textIsValid : Bool = false
    @Published var showButton : Bool = false
    
    init() {
        setTimer()
        addTextFieldSubscriber()
        addButtonSubscriber()
    }
    
    func addTextFieldSubscriber() {
        $textFieldText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //유저가 타자를 막 쳐대면 밑에 맵이 미친듯이 실행이 될 것이다. 하지만 디바운스를 통해서 막 타자를 치고 나서 0.5초 이후에 아래 맵을 실행하라는 모디파이어이다. CPU 과부하를 막기 위한 친구다. 멋진데?
        
            .map { (text) -> Bool in // 텍스트를 받아서 조회 하고 불리언 값을 리턴할 것이다.
                if text.count > 3 {
                    return true
                }
                return false
            }
//            .assign(to: \.textIsValid, on: self) // 이건 반면에 강한 참조라서 프로페셔널 하지 않다.
            .sink(receiveValue: { [weak self] (isValid) in
                self?.textIsValid = isValid
            })
            .store(in: &cancellables)
    }
    //텍스트 필드의 변화를 잡아내는 컴바인
    
    func setTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
        //1초마다 새로운 퍼블리셔를 생산한다.
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.count += 1
                //싱크를 통해서 발생한 행동을 함수로 소화해준다.
                if self.count >= 10 {
                    for item in self.cancellables {
                        item.cancel()
                    }
                } // 싱크의 장점은 위크셀프를 할 수 있다는 것이다.
            }
            .store(in: &cancellables)
        
    }
    //타이머를 통해 처리해보는 컴바인
    
    func addButtonSubscriber() {
        $textIsValid
            .combineLatest($count)
            .sink { [weak self] (isValid, count) in
                // isValid는 텍스트이즈벨리드에서, count는 카운트에서 넘어온다.
                guard let self = self else {return}
                
                if isValid && count >= 10 {
                    self.showButton = true
                } else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
    //두개의 컴바인을 섞어서 처리해보는 컴바인
    
}

struct PublisherSubscriberCombineClass: View {
    
    @StateObject var vm = PubSubClassViewModel()
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            
            Text("\(vm.textIsValid.description)")
            
            TextField("typesome...", text: $vm.textFieldText)
                .frame(height : 55)
                .background(.black)
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.headline)
                .overlay(
                    ZStack{
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(vm.textFieldText.count < 1 ? 0 :
                                vm.textIsValid ? 0 : 1)
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(vm.textIsValid ? 1 : 0)
                    }
                        .font(.headline)
                        .padding(.trailing)
                    ,alignment: .trailing
                )
            Button(action: {
                
            }, label: {
                Text("Submit")
                    .font(.headline)
                    .opacity(vm.showButton ? 1 : 0.5)
            })
            .disabled(!vm.showButton)
        }
    }
}

struct PublisherSubscriberCombineClass_Previews: PreviewProvider {
    static var previews: some View {
        PublisherSubscriberCombineClass()
    }
}
