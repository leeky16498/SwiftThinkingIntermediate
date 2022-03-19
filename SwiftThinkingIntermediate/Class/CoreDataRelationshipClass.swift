//
//  CoreDataRelationshipClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 18/03/2022.
//

import SwiftUI
import CoreData

//3entities : Business, Department, employee

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    let container : NSPersistentContainer
    let context : NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("error = \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("error saving = \(error)")
        }
    }
}

class CoreDataRelationshipViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance // 싱글톤으로 선언
    
    @Published var businesses : [BusinessEntity] = []
    @Published var departments : [DepartmentEntity] = []
    @Published var employees : [EmployeeEntity] = []
    
    init() {
        getBusiness()
        getDepartment()
        getEmployee()
    }
    
    func addBusiness() {
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Apple"
        save()
        
        //add existing departments to the new business
        //newBusiness.departments = []
        
        //add existing employees to the new business
        //newBusiness.employees = []
        
        //add new business to existing department
        //newBusiness.addToDepartment(value : DepartmentEntity)
        
        //add new business to existing employee
        //newBusiness.addToDepartment(value : EmployeeEntity)
        
        //newBusiness.name = "MS soft"
        //newBusiness.departments = [departments[0], departments[1]]
        //존재하는 디파트 먼트를 인덱스를 통해서 넘겨서 추가해줄 수 있다.
        
        
        
        
    }
    
    func addDepartment() {
        
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name = "Marketing"
//        newDepartment.businesses = [businesses[0]]
        save()
        
//        newDepartment.employees = [employees[1]]
        newDepartment.addToEmployees(employees[1])
        //이렇게 하면 2번쨰 추가된 에밀리를 디파트먼트로 밀어줄 수 있따.
    }
    
    func addEmployee() {
        
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.age = 25
        newEmployee.dateJoined = Date()
        newEmployee.name = "Chris"
        
        newEmployee.business = businesses[0]
        newEmployee.department = departments[0]
        save()
    }
    
    func save() {
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.save()
            self.getBusiness()
            self.getDepartment()
            self.getEmployee()
        }
    }
    
    func getBusiness() {
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        //엔티티 네임을 정확하게 기입해줘야 한다. 저 단어로 코어데이터를 불러오므로
        
        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
        request.sortDescriptors = [sort] // 이렇게 하면 이름순으로 비즈니스가 정렬된다. 정렬을 시킬 수 있다.
        
        let filter = NSPredicate(format: "name == %@", "Apple")
        request.predicate = filter // 이렇게 하면 이름이 애플과 같은 친구들을 걸러서 리턴해주게 된다.
        
        do {
           businesses =  try manager.context.fetch(request)
        } catch {
            print("error fetching")
        }
    }
    
    func getDepartment() {
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        
        do {
            departments = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching departments? error = \(error.localizedDescription)")
        }
    }
    
    func getEmployee() {
        
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            employees = try manager.context.fetch(request)
        }catch {
            print("error is isssued")
        }
        
    }
    
    func getEmployee(forBusiness business : BusinessEntity) {
        
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        let filter = NSPredicate(format: "business == %@", business)
        request.predicate = filter // 이렇게 해주면 같은 비즈니스에 있는 사람들의 명단을 리턴해주는 것이 가능합니다.
        
        do {
            employees = try manager.context.fetch(request)
        }catch {
            print("error is isssued")
        }
        
    }
    
    func deleteDepartment() {
        let department = departments[2]
        manager.context.delete(department)
    }
    //삭제옵션의 널파이인경우, 상위가 지워져도 하위는 남는다
    //삭제옵션이 캐스케이드인경우, 상위가 지워지면 하위도 전부 지워진다.
    //-> 이팟먼트에 캐스케이드를 주고 삭제하니 하위 직원들도 전부 삭제되었다.
    //삭제옵션이 디나이인 경우, 하위가 살아있으면 상위가 지워지지 않는다.
}

struct CoreDataRelationshipClass: View {
    
    @StateObject var vm = CoreDataRelationshipViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 20) {
                    Button("Save") {
                        vm.addEmployee()
                        
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top) {
                            ForEach(vm.businesses) { business in
                                BusinessView(entity: business)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top) {
                            ForEach(vm.departments) { department in
                                DepartmentView(entity: department)
                            }
                        }
                    }
                }
                .padding()
            }
            
            .navigationTitle("Relationships")
        }
    }
}

struct BusinessView : View {
    
    let entity : BusinessEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("name : \(entity.name ?? "")")
                .bold()
            
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("Department: ")
                ForEach(departments) { department in
                    Text(department.name ?? "")
                }
            }
            
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("employee: ")
                ForEach(employees) { employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(.gray)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DepartmentView : View {
    
    let entity : DepartmentEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("name : \(entity.name ?? "")")
                .bold()
            
//            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
//                Text(businesses.name ?? "")
//            }
            
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("employee: ")
                ForEach(employees) { employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(.gray)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct EmployeeView : View {
    
    let entity : EmployeeEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("name : \(entity.name ?? "")")
                .bold()
            
            Text(entity.business?.name ?? "")
            
            Text(entity.department?.name ?? "")
            
//            if let business = entity.businesses as? BusinessEntity {
//                Text(business.name ?? "")
//            }
//
//            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
//                Text("employee: ")
//                ForEach(employees) { employee in
//                    Text(employee.name ?? "")
//                }
//            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(.gray)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct CoreDataRelationshipClass_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataRelationshipClass()
    }
}
