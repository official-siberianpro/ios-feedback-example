//
//  BaseTableViewCell.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

protocol BaseTableViewCellProtocol {
    
    var cellHeight: CGFloat { get }
}

class BaseTableViewCell: UITableViewCell {
    
    var view = UIView()
    
    var topBorder = false
    var bootomBorder = false
    
    override func drawRect(rect: CGRect) {

        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        view.removeFromSuperview()
        
        var frame = self.contentView.bounds
        frame.origin.x += 8.0
        frame.size.width -= 16.0
        
        self.view = UIView(frame: frame)
        self.view.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight]
        self.view.backgroundColor = UIColor(red: 0.945, green: 0.946, blue: 0.945, alpha: 1)
        self.contentView.insertSubview(view, atIndex: 0)
        
        if topBorder { self.view.addBorder(edges: .Top, colour: UIColor.lightGrayColor(), thickness: 1.0) }
        self.view.addBorder(edges: .Left, colour: UIColor.lightGrayColor(), thickness: 1.0)
        self.view.addBorder(edges: .Right, colour: UIColor.lightGrayColor(), thickness: 1.0)
        if bootomBorder { self.view.addBorder(edges: .Bottom, colour: UIColor.lightGrayColor(), thickness: 1.0) }
    }
}

extension UIView {
    
    func addBorder(edges edges: UIRectEdge, colour: UIColor = UIColor.whiteColor(), thickness: CGFloat = 1) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            
            let border = UIView(frame: CGRectZero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            
            return border
        }
        
        if edges.contains(.Top) || edges.contains(.All) {
            
            let top = border()
            
            addSubview(top)
            
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[top(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[top]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["top": top]))
            
            borders.append(top)
        }
        
        if edges.contains(.Left) || edges.contains(.All) {
            
            let left = border()
            
            addSubview(left)
            
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[left(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[left]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["left": left]))
            
            borders.append(left)
        }
        
        if edges.contains(.Right) || edges.contains(.All) {
            
            let right = border()
            
            addSubview(right)
            
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:[right(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[right]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["right": right]))
            
            borders.append(right)
        }
        
        if edges.contains(.Bottom) || edges.contains(.All) {
            
            let bottom = border()
            
            addSubview(bottom)
            
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:[bottom(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bottom]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["bottom": bottom]))
            
            borders.append(bottom)
        }
        
        return borders
    }
}
