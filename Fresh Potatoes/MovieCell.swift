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
    
    @IBOutlet weak var ratingsView: UIImageView!
    
    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    let backView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        selectedBackgroundView=UIView(frame: frame)
        selectedBackgroundView!.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.5)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.selectionStyle = .None
        self.setHighlighted(false, animated: false)
        
        // Configure the view for the selected state
    }

}
