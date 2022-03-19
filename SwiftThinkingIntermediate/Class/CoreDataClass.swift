//
//  CoreDataClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 18/03/2022.
//

import SwiftUI
import CoreData

//View : UI
//Model : Data point
//ViewModel : Manages data

struct CoreDataClass: View {
    
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldtext : String = ""
    
    var body: some View {
        NavigationView {
                VStack {
                    TextField("fruits enter", text: $textFieldtext)
                        .font(.headline)
                        .frame(height : 55)
                        .cornerRadius(10)
                        .padding()
                
                    Button("Save") {
                        guard !textFieldtext.isEmpty else {return}
                        vm.addFruit(text: textFieldtext)
                        textFieldtext = ""
                    }
            
                    List {
                        ForEach(vm.savedEntities) { entity in
                            Text(entity.name ?? "No name")
                                .onTapGesture {
                                    vm.updateEntity(entity: entity)
                                }
                        }
                        .onDelete(perform: vm.deleteData)
                        
                    }
                }
            
            .navigationTitle("Fruits")
        }
    }
}

struct CoreDataClass_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataClass()
    }
}

class CoreDataViewModel : ObservableObject {
    
    let container: NSPersistentContainer
    
    @Published var savedEntities : [FruitEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error in loading CoreData \(error)")
            } else {
                print("successfully loaded coreData")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits() { // 데이터를 붙여주는 것이다.
        
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
    
        do {
           savedEntities = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching = \(error)")
        }
    }
    
    func addFruit(text : String) {
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        saveData()
    }
    // 추가해주는 것은 형태만 다르지 크게 다르지 않다.
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchFruits()
        } catch {
            print("error saving = \(error)")
        }
        //함수형 말 그대로 추가해준다라는 의미이다.
    }
    
    func deleteData(indexSet : IndexSet) {
        guard let index = indexSet.first else {return} // 인덱스를 찾고 그 다음에 지워주세염
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func updateEntity(entity : FruitEntity) {
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveData()
    }
}
