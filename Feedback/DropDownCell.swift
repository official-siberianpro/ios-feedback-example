//
//  DropDownCell.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

@objc protocol DropDownCellDelegate {
    
    optional func dropDownCell(dropDownCell: DropDownCell, didChangeTitleText text: String?) -> Void
}

class DropDownCell: BaseTableViewCell {

    weak var delegate: DropDownCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var menu = DropDownMenu()
    var selectionIndex = -1
    
    var items = [Int: String]()
    
    var drop: Bool = false {
        
        didSet {
            
            selectedImageView.image = UIImage(named: drop ? "ArrowTop" : "ArrowBottom")
            showDropDownMenu()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showDropDownMenu() -> Void {

        if drop {
            
            var items = Dictionary<Int, String>()
            let keys = Array(self.items.keys).sort { $0 < $1 }
            
            for (index, key) in keys.enumerate() {
                
                items.updateValue(self.items[key]!, forKey: index)
            }
            
            menu.selectionIndex = selectionIndex
            menu.items = items
            
            menu.showMenu(200.0, inView: self.contentView, superview: self.superview?.superview, animation: true) { (index) in
                
                self.titleLabel.text = items[index]
                
                self.selectionIndex = index
                self.drop = false
                
                self.menu.hideMenu()
                
                self.delegate?.dropDownCell?(self, didChangeTitleText: items[index])
            }
            
        } else {
            
            menu.hideMenu()
        }
    }
}