//
//  TextViewCell.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

@objc protocol TextViewCellDelegate {
    
    optional func textViewCell(textViewCell: TextViewCell, textViewDidChange textView: UITextView) -> Void
}

class TextViewCell: BaseTableViewCell, UITextViewDelegate, BaseTableViewCellProtocol {

    weak var delegate: TextViewCellDelegate?
    
    var textView = UITextView()
    
    var cellHeight: CGFloat {

        get {
            
            return max(48.0, self.textView.contentSize.height)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textView = UITextView()
        self.textView.delegate = self
        self.textView.scrollEnabled = false
        self.textView.font = UIFont.systemFontOfSize(14.0)
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.returnKeyType = UIReturnKeyType.Done
        
        self.contentView.addSubview(self.textView)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.textView.frame = CGRect(x: 12, y: 0, width: CGRectGetWidth(self.contentView.frame) - 24, height: CGRectGetHeight(self.contentView.frame))
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        
        self.delegate?.textViewCell?(self, textViewDidChange: textView)
        
        self.willChangeValueForKey("cellHeight")
        
        var frame = self.textView.frame
        
        self.textView.sizeToFit()
        self.textView.layoutIfNeeded()
        
        frame.size.height = max(48.0, textView.contentSize.height)
        self.textView.frame = frame
        
        self.didChangeValueForKey("cellHeight")
    }
}