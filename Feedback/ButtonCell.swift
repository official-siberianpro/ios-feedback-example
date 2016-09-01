//
//  ButtonCell.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

class ButtonCell: BaseTableViewCell {

    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
