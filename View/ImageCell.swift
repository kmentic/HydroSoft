//
//  ImageCell.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var imageDetail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(image: UIImage) {
        imageDetail.image = image
    }
    
    
}

