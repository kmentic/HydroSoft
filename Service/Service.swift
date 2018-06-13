//
//  Service.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import UIKit

let url = ""



var imageCache: NSCache<NSString, UIImage> = NSCache()


class Service  {
    
    static let sharedInstance = Service()
    
    func downloadImageAndPutItToCache(url: String,downloadCompleted: ((UIImage) -> Swift.Void)? = nil) {
        if let img = imageCache.object(forKey: url as NSString) {
            downloadCompleted!(img)
        } else {
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    imageCache.setObject(image, forKey: url as NSString)
                    downloadCompleted!(image)
                }
            }
        }
    }
    
    func getRecords(completitionHandler : @escaping (_ posts: [Post])->()) {
        Alamofire.request("http://www.wmap.cz/ords/work/test/media/list").responseSwiftyJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)")
                 let items = json["items"].arrayValue
                    // serialized json response
                var posts = [Post]()
                for item in items {
                    let name = item["file_name"].stringValue
                    let des = item["file_ds"].stringValue
                    let id = item["id"].stringValue
                    let latitude = item["wgs_e"].doubleValue
                    let longitude = item["wgs_n"].doubleValue
                    let created = item["file_dt"].stringValue.fromIsoToDate()
                    let uploadedToDB = item["file_dt_db"].stringValue.fromIsoToDate()
                    let imageUrl = "http://www.wmap.cz/ords/work/test/media/\(name)"
                    
                    print(latitude)
                    
                    var post = Post(id: id, name: name, imageName: name, note: des, date: created, uploaded: true, image: #imageLiteral(resourceName: "raci"))
                    post.imageUrl = imageUrl
                    posts.append(post)
                }
                completitionHandler(posts)
            }
            
 
        }
    }
    
    func upload(Record record: Post) {
        let url = "http://www.wmap.cz/ords/work/test/media/"
        if let imageData = UIImageJPEGRepresentation(record.image, 1.0) {

//            let parameters : Parameters = ["data" : imageData, "content_type": "image/jpeg", "Content-Type" : "image/jpeg"]
        
        let headers: HTTPHeaders = ["file_name": "Record9.jpg","content_type": "image/jpeg", "file_ds" : record.note,"file_date" : record.date.toIso(),"wgs_n" : "14.6689172","wgs_e" : "50.05245"]


            
            Alamofire.upload(multipartFormData: { (multipart) in
//                multipartFormData.appendBodyPart(fileURL: imagePathUrl!, name: "photo")
//                multipart.append(imageData, withName: "data")
//                    multipart.append(imageData, withName: "Record9.jpeg", mimeType: "image/jpeg")
                multipart.append(imageData, withName: "Record9.jpeg", fileName: "Record9.jpeg", mimeType: "image/jpeg")
            }, usingThreshold: 0, to: url, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        dump(Progress)
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            print(JSON)
                            
                        }else{
                            print("Error")
                        }
                    }
                    
                case .failure(let encodingError):
                    print("Error")
                    print(encodingError.localizedDescription)
                }
                
            }
            

        } else {
            print("Cannot convert")
        }
    }
}
