//
//  ImageManager.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit


class ImageManager {
    
    static let shared = ImageManager()
    
    private init() {}
    
    static let downloadImagePath = "http://download.glide.me/pre-login-avatars/avatars_cartoon_animals_%@.png"
    
    lazy var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()
    
    // MARK: - Public funcs
    
    func documentsDirectory() -> URL {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentsDir: URL = urls.first!
        return documentsDir
    }
    
    func saveImage(_ image: UIImage, withName name: String) -> Bool {
        guard let imageData = image.pngData() else {
            return false
        }
        
        do {
            try imageData.write(to: self.pathToImage(name))
        } catch {
            pl(error.localizedDescription)
        }
        
        return false
    }
    
    
    func imageModel(with imageName: String, completion: @escaping (ImageModel?) -> Void) {
        let imgModel = self.imageModel(with: imageName)
        if imgModel.state == .downloaded {
            completion(imgModel)
        } else {
            let imgOperation = ImageDownloader(imgModel)
            
            imgOperation.completionBlock = {
                OperationQueue.main.addOperation {
                    completion(imgModel)
                }
            }
            
            self.downloadQueue.addOperation(imgOperation)
        }
    }
    
    func saveImageData(_ data: Data?, with name: String) {
        guard let imageData = data else { return }
        do {
            try imageData.write(to: self.pathToImage(name))
        } catch {
            pl(error.localizedDescription)
        }
    }
    
    func getImage(with imageName: String) -> UIImage? {
        let imagePath = self.pathToImage(imageName)
        let image = UIImage(contentsOfFile: imagePath.path)
        return image
    }
    
    
    // MARK: Private funcs
    
    private func imageModel(with imageName: String) -> ImageModel {
        let imagePath = self.pathToImage(imageName)
        let img = UIImage(contentsOfFile: imagePath.path)
        let model = ImageModel(name: imageName, image: img)
        return model
    }
    
    private func imagesDirectoryPath() -> URL {
        let fm = FileManager.default
        
        let dirName = "Images"
        let path = self.documentsDirectory().appendingPathComponent(dirName)
        
        if fm.fileExists(atPath: path.absoluteString) == false {
            do {
                try fm.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                pl(error.localizedDescription)
            }
        }
        return path
    }
    
    private func pathToImage(_ imageName: String) -> URL {
        let path = self.imagesDirectoryPath().appendingPathComponent(imageName)
        return path
    }
    
}



class ImageModel {
    let name: String
    let url: URL
    var state: ImageDownloadState = ImageDownloadState.new
    var image: UIImage?
    
    init(name:String, state: ImageDownloadState = .new, image: UIImage? = nil) {
        self.name = name
        self.image = image
        let urlString = String(format: ImageManager.downloadImagePath, arguments: [name])
        self.url = URL(string: urlString)!
        if image != nil {
            self.state = .downloaded
        }
    }
    
    enum ImageDownloadState {
        case new
        case downloaded
        case failed
    }
}



class ImageDownloader: Operation {
    let image: ImageModel
    
    init(_ image: ImageModel) {
        self.image = image
    }
    
    override func main() {
        if isCancelled {
            return
        }

        guard let imageData = try? Data(contentsOf: image.url) else {
            image.state = .failed
            return
        }
        ImageManager.shared.saveImageData(imageData, with: image.name)
        if !imageData.isEmpty {
            image.image = ImageManager.shared.getImage(with: image.name)
            image.state = .downloaded
        } else {
            image.state = .failed
        }
    }
}
