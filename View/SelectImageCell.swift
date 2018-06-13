//
//  SelectImageCell.swift
//  HydroSoft
//
//  Created by Filip Kment on 06.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit

protocol ImageCellProtocol {
    func takePhoto()
}

class SelectImageCell: UITableViewCell {

    @IBOutlet weak var takePhotoView: UIView!
    
    var delegate : ImageCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnTakeImage(_:)))
        takePhotoView.addGestureRecognizer(tap)
        takePhotoView.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    @objc func handleTapOnTakeImage(_ sender: UITapGestureRecognizer) {
        delegate?.takePhoto()
    }
}
