//
//  DropDownMenu.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

typealias block = ((index: Int) -> Void)?

class DropDownMenu: UIView {

    private var tableView = UITableView()
    
    var selectionIndex = -1
    private var currentTitle: String?

    private var completionHandler: block
    
    var items = Dictionary<Int, String>()

    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showMenu(height: CGFloat, inView view: UIView, superview: UIView?, items: Dictionary<Int, String> = Dictionary<Int, String>(), animation: Bool = true, completionHandler: block) -> Void {
        
        self.completionHandler = completionHandler
        
        if items.count > 0 { self.items = items }
        
        let rect = view.convertRect(view.frame, toView: superview)
        
        self.frame = CGRect(x: CGRectGetMinX(view.frame) + 8, y: CGRectGetMinY(rect) + CGRectGetHeight(rect) - 8, width: CGRectGetWidth(view.frame) - 16, height: 0)
        
        self.layer.shadowOffset = CGSizeMake(5, 5)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.3
        
        tableView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(view.frame) - 16, height: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        tableView.tableFooterView = UIView()
        
        if animation {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
        }
        
        self.frame.size.height = height
        self.tableView.frame.size.height = height
        
        if animation {
            
            UIView.commitAnimations()
        }
        
        superview?.addSubview(self)
        self.addSubview(tableView)
        
        if selectionIndex >= 0 && selectionIndex < self.items.count { currentTitle = self.items[selectionIndex] }
        
        tableView.reloadData()
        
        if selectionIndex >= 0 && selectionIndex < self.items.count {
            
            let indexPath = NSIndexPath(forRow: selectionIndex, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    func hideMenu(animation: Bool = false) -> Void {
        
        if animation {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
        }
        
        self.frame.size.height = 0
        self.tableView.frame.size.height = 0
        
        if animation {
            
            UIView.commitAnimations()
        }
    }
}

extension DropDownMenu: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if let view = tableView.dequeueReusableCellWithIdentifier("Cell") {
            
            cell = view
            
        } else {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel?.textColor = UIColor.blackColor()

        cell.accessoryView = currentTitle == items[indexPath.row] ? UIImageView(image: UIImage(named: "Checkmark")) : nil
        
        return cell
    }
    
    //MARK: - UITableView Delegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.respondsToSelector(Selector("setSeparatorInset:")) {
            
            tableView.separatorInset = UIEdgeInsetsZero
        }
        
        if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        completionHandler?(index: indexPath.row)
        hideMenu()
    }
}