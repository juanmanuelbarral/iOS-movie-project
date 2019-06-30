//
//  SectionHeaderView.swift
//  iOS-movie-project
//
//  Created by Manu on 30/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
