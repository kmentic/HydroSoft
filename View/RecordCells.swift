//
//  RecordCells.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit

class RecordCells: UITableViewCell {

    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var buttonNext: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(post: Post) {
        labelText.text = post.name
      
        dateLbl.text = post.stringDate
        
        if  post.imageUrl == "" {
            imageDetail.image = post.image
        } else {
            Service.sharedInstance.downloadImageAndPutItToCache(url: post.imageUrl) { (image) in
                self.imageDetail.image = image
            }
        }

    }
    
}
