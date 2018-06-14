//
//  ImageCell.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit
import AlamofireImage

let imageDownloader = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .fifo,
    maximumActiveDownloads: 4,
    imageCache: AutoPurgingImageCache()
)

class ImageCell: UITableViewCell {

    @IBOutlet weak var imageDetail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(post: Post) {
        print(post.imageUrl)
        
        if  post.imageUrl == "" {
            imageDetail.image = post.image
        } else {
            Service.sharedInstance.downloadImageAndPutItToCache(url: post.imageUrl) { (image) in
                self.imageDetail.image = image
            }
        }
        
    }
    
    
}

