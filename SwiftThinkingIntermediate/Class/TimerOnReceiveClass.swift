//
//  TimerOnReceiveClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 07/03/2022.
//

import SwiftUI

struct TimerOnReceiveClass: View {
    
    @State var currentDate : Date = Date()
    @State var count : Int = 0
    
    /*current time
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
        formatter.timeStyle = .full
        return formatter
    }
     */
    
    /*countDown
    @State var count : Int = 10
    @State var finishedText : String? = nil
     */
    
    /*countDown to date
    @State var timeRemaining : String = ""
    let futureDate : Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    // '하루'의 '데이'만큼을 더해라. 1일 더 더해라.
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureDate)
//        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(minute):\(second)"
    
     */
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    //메인을 택하는 이유는 메인스레드에서 작업을 처리할 것이기 때문이다.
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.blue, .white]), center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
            
//            Text(dateFormatter.string(from: currentDate))
//            HStack {
//                Circle()
//                    .offset(y: count == 1 ? -20 : 0)
//                Circle()
//                    .offset(y: count == 2 ? -20 : 0)
//                Circle()
//                    .offset(y: count == 3 ? -20 : 0)
//            }
            
            TabView(selection: $count){
                Rectangle()
                    .fill(.red)
                    .tag(1)
                Rectangle()
                    .fill(.blue)
                    .tag(2)
                Rectangle()
                    .fill(.green)
                    .tag(3)
                Rectangle()
                    .fill(.orange)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height : 200)
            
        }
        .onReceive(timer, perform: { _ in // 안에 있는 변수가 뭘 생산하는지를 따라간다.
            withAnimation(.default) {
                count = count == 3 ? 0 : count + 1
            } // 이렇게 해서 로딩애니메이션을 만들기도 한다.
            //이런식으로 페이지 뷰에 셀렉션을 추적하게 해서 자동 애니매이션을 만들기도 한다.
        })
    }
}

struct TimerOnReceiveClass_Previews: PreviewProvider {
    static var previews: some View {
        TimerOnReceiveClass()
    }
}
