//
//  NSCacheClass.swift
//  SwiftThinkingIntermediate
//
//  Created by Kyungyun Lee on 08/03/2022.
//

import SwiftUI

class CacheManager {
    
    static let instance = CacheManager() // singleton 오직 여기에서만 쓰이게 하겠다는 의미입니당
    
    private init() {
        
    }
    
    var imageCache : NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024*1024*100 // 100mb
        return cache
    }()
    
    func add(image : UIImage, name : String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Add to cache")
    }
    
    func remove(name : String) {
        imageCache.removeObject(forKey: name as NSString)
        print("removed from cache!")
    }
    
    func get(name : String) -> UIImage? {
        print("get from cache")
        return imageCache.object(forKey: name as NSString)
    }
    
    
}

class CacheViewModel : ObservableObject {
    
    @Published var startingImage : UIImage? = nil
    @Published var cahcedImage : UIImage? = nil
    
    let imageName : String = "picturefile"
    let manager = CacheManager.instance
    
    init() {
        getImageFromAssetFolder()
    }
    
    func getImageFromAssetFolder() {
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache() {
        guard
            let startingImage = startingImage else {
                return
            }
        manager.add(image: startingImage, name: imageName)
    }
    
    func deletefromCache() {
        manager.remove(name: imageName)
    }
    
    func getFromCache() {
        cahcedImage = manager.get(name: imageName)
    }
    
}

struct NSCacheClass: View {
    
    @StateObject var vm = CacheViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                if let image = vm.startingImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width : 200, height : 200)
                }
                
                Button(action: {
                    vm.saveToCache()
                }, label: {
                    Text("Save to cache")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                })
                
                Button(action: {
                    vm.deletefromCache()
                }, label: {
                    Text("Delete from cache")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                })
                
                Button(action: {
                    vm.getFromCache()
                }, label: {
                    Text("get from cache")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                })
                
                if let image = vm.cahcedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width : 200, height : 200)
                }
                
            }
        }
    }
}

struct NSCacheClass_Previews: PreviewProvider {
    static var previews: some View {
        NSCacheClass()
    }
}
