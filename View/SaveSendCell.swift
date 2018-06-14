//
//  SaveSendCell.swift
//  HydroSoft
//
//  Created by Filip Kment on 05.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit

class SaveSendCell: UITableViewCell {

    @IBOutlet weak var saveSendLabel: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func confgiureCell(post: Post) {
        if post.uploaded {
            successImageView.isHidden = false
            saveSendLabel.textColor = #colorLiteral(red: 0.368627451, green: 0.6901960784, blue: 0.6235294118, alpha: 1)
            saveSendLabel.text = "Záznam byl úspěšně odeslán na server"
        } else {
            successImageView.isHidden = true
            saveSendLabel.textColor = #colorLiteral(red: 0.1411764706, green: 0.2078431373, blue: 0.9607843137, alpha: 1)
        }
    }
    
}
