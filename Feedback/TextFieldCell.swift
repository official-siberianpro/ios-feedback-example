//
//  TextFieldCell.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

class TextFieldCell: BaseTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField! { didSet { textField.delegate = self } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}