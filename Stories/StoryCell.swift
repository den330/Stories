//
//  StoryCell.swift
//  Stories
//
//  Created by 330Mac on 2018-12-03.
//  Copyright © 2018 Yaxin Yuan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class StoryCell: UITableViewCell{
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    func configure(story: Story){
        self.titleLabel.text = story.title
        self.authorNameLabel.text = story.author
        if let urlStr = story.coverImageURLString{
           let imgUrl = URL(string: urlStr)!
           coverImageView.af_setImage(withURL: imgUrl)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coverImageView.af_cancelImageRequest()
        self.titleLabel.text = nil
        self.authorNameLabel.text = nil
    }
}
