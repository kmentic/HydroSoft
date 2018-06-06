//
//  BasicCell.swift
//  HydroSoft
//
//  Created by Filip Kment on 05.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
     Calculates if new textview height (based on content) is larger than a base height
     
     - parameter baseHeight: The base or minimum height
     
     - returns: The new height
     */
    func newHeight(withBaseHeight baseHeight: CGFloat) -> CGFloat {
        
        // Calculate the required size of the textview
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = frame
        
        // Height is always >= the base height, so calculate the possible new height
        let height: CGFloat = newSize.height > baseHeight ? newSize.height : baseHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        return newFrame.height
    }
}

protocol ExpandingCellDelegate {
    func updated(height: CGFloat, indexPath: IndexPath)
}

class BasicCell: UITableViewCell {

    @IBOutlet weak var basicTitle: UILabel!
    
    @IBOutlet weak var basicValue: UILabel!
    @IBOutlet weak var textView: UITextView!
    var delegate: ExpandingCellDelegate?
    var indexPath : IndexPath = IndexPath(row: 0, section: 0)
    var placeholder = ""
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
        textView.textColor = .lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(title: String, value: String, indexPath: IndexPath) {
        basicTitle.text = title
        textView.text = value
        if value == "..." {
            placeholder = value
        } else {
            textView.textColor = .black
        }
        if title == "Datum" {
            basicValue.isHidden = false
            basicValue.text = value
            textView.isHidden = true
        } else {
            basicValue.isHidden = true
            textView.isHidden = false
        }

         self.indexPath = indexPath
    }
 
}

extension BasicCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let height = textView.newHeight(withBaseHeight: 27)
        delegate?.updated(height: height, indexPath: indexPath)
        
        if basicTitle.text == "Name" {
            PostToSend.name = textView.text
        } else if basicTitle.text == "Poznámka" {
            PostToSend.note = textView.text
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}
