//
//  Model.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import Foundation
import UIKit

let formatter = DateFormatter()

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "cs_US")
        return formatter.string(from: self)
    }
}

class Post: NSObject, NSCoding {

    var name: String
    var date: Date
    var note : String
    var imageName : String
    var id : String
    
    var uploaded = false
    var image : UIImage
    
    var stringDate : String {
        return self.date.toString()
    }
   
    init(name: String, imageName: String, note: String, image : UIImage, uploaded: Bool) {
        self.name = name
        self.date = Date()
        self.note = note
        self.imageName = imageName
        self.image = image
        self.uploaded = uploaded
        self.id = UUID().uuidString

    }
    
    init(id: String, name: String, imageName: String, note: String, date: Date, uploaded: Bool, image: UIImage) {
        self.name = name
        self.date = date
        self.note = note
        self.imageName = imageName
        self.uploaded = uploaded
        self.image = image
        self.id = id

    }
   
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let note = aDecoder.decodeObject(forKey: "note") as! String
        let imageName = aDecoder.decodeObject(forKey: "imageName") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let uploaded = aDecoder.decodeBool(forKey: "uploaded")
        let image = aDecoder.decodeObject(forKey: "image") as! UIImage

        self.init(id: id,name: name, imageName: imageName, note: note, date: date, uploaded: uploaded, image: image)

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(note, forKey: "note")
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(uploaded, forKey: "uploaded")
        aCoder.encode(image, forKey: "image")

    }
}
