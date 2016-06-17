//
//  MovieCell.swift
//  Fresh Potatoes
//
//  Created by Jessica Choi on 6/15/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    let backView = UIView()
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None
//        backView.backgroundColor = UIColor.blueColor()
//        self.selectedBackgroundView = backView
//        self.setHighlighted(true, animated: false)
        
        // Configure the view for the selected state
    }

}
