//
//  FilemanagerClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager() // 싱글톤 선언
    let folderName : String = "My_app_images"
    
    init() {
        createFolders()
    }
    
    func createFolders() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path
        else {return}
        
        if !FileManager.default.fileExists(atPath: path) { // 이미 폴더가 있으면 재생성 안함
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("There is error..")
            }
        }
    }
    
    func saveImage(image: UIImage, name : String) {
        guard
            let data = image.jpegData(compressionQuality: 0.5), // 파일에 맞는 데이터 형태 설정
            let path = getPath(name: name)
        else {
            print("error getting data")
            return
        }

        do {
            try data.write(to: path)
            print("success saving")
        } catch let error{
            print("Error saving. \(error)")
        }
    }
        
        func getImage(name : String) -> UIImage? {
            guard
                let path = getPath(name: name)?.path,
                FileManager.default.fileExists(atPath: path) else {
                    print("error getting path")
                    return nil
                }
            
            return UIImage(contentsOfFile: path)
        }
        
        func getPath(name : String) -> URL? {
            guard
                let path = FileManager
                    .default
                    .urls(for: .cachesDirectory, in: .userDomainMask)
                    .first?
                    .appendingPathComponent(folderName)
                    .appendingPathComponent("\(name).jpg") else {
                    return nil
                }
            return path
        }
    
        func deleteImage(name: String) {
            guard
                let path = getPath(name: name)?.path,
                FileManager.default.fileExists(atPath: path) else {
                    print("error getting path")
                    return
                }
            
            do {
                try FileManager.default.removeItem(atPath: path)
                print("successfully deleted")
            }catch let error {
                print("error in deleting picture")
            }
        }
    
    func deleteFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path
                    else {
                return
            }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("successs to delete folders")
        }catch let error {
            print("error to delete")
        }
    }
}

class FilemanagerViewModel : ObservableObject {
    
    @Published var image : UIImage? = nil
    
    let imageName : String = "picturefile"
    let manager = LocalFileManager.instance
    
    init() {
//        getImagefromAsset() // 이거는 앱 어셋에서 파일매니저로 가져오는거
        getImageFromFileManager()
    }
    
    func getImageFromFileManager() {
        image = manager.getImage(name: imageName) // 이건 파일매니저에서 가져오는 거
        //어셋에서 파일을 지워도 앱 실행 간 그림이 그대로 뜬다.
    }
    
    func getImagefromAsset() {
        image = UIImage(named: imageName)
    }
    
    func saveImage() {
        guard let image = image else {return}
        manager.saveImage(image: image, name: imageName)
    }
    
    func deleteImage() {
        manager.deleteImage(name: imageName)
    }
    
}


struct FilemanagerClass: View {
    
    @StateObject var vm = FilemanagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width : 200, height :200)
                        .cornerRadius(20)

                    Button(action: {
                        vm.saveImage()
                    }, label: {
                        Text("Save to FM")
                            .foregroundColor(.blue)
                            
                    })
                    .padding()
                    
                    Button(action: {
                        vm.deleteImage()
                    }, label: {
                        Text("Delete to FM")
                            .foregroundColor(.red)
                    })
                    .padding()
                    
                }
            }
                .navigationTitle("filemanager")
        }
    }
}

struct FilemanagerClass_Previews: PreviewProvider {
    static var previews: some View {
        FilemanagerClass()
    }
}
