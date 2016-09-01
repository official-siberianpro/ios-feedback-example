//
//  MainController.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import UIKit

let kTextFieldCell = "TextFieldCell"
let kMaskTextFieldCell = "MaskTextFieldCell"
let kTextViewCell = "TextViewCell"
let kCheckBoxCell = "CheckBoxCell"
let kButtonCell = "ButtonCell"
let kDropDownCell = "DropDownCell"

class MainController: UITableViewController, AKMaskFieldDelegate {

    typealias CellData = (cellId: String, placeHolderTitle: String, data: AnyObject)
    
    private var constants: [CellData] = [
        
        (cellId: kTextFieldCell, placeHolderTitle: "Введите Ваше ФИО", data: ""),
        (cellId: kTextFieldCell, placeHolderTitle: "Введите email", data: ""),
        (cellId: kMaskTextFieldCell, placeHolderTitle: "Введите номер телефона", data: ""),
        (cellId: kDropDownCell, placeHolderTitle: "Выберите тему обращения", data: false),
        (cellId: kDropDownCell, placeHolderTitle: "Выберите населенный пункт", data: false),
        (cellId: kDropDownCell, placeHolderTitle: "Выберите магазин", data: false),
        (cellId: kTextViewCell, placeHolderTitle: "Укажите содержание сообщения", data: ""),
        (cellId: kCheckBoxCell, placeHolderTitle: "Вы должны принять пользовательское соглашение", data: false),
        (cellId: kButtonCell, placeHolderTitle: "", data: false)
    ]
    
    private var objects: [CellData] = [
    
        (cellId: kTextFieldCell, placeHolderTitle: "Введите Ваше ФИО", data: ""),
        (cellId: kTextFieldCell, placeHolderTitle: "Введите email", data: ""),
        (cellId: kMaskTextFieldCell, placeHolderTitle: "Введите номер телефона", data: ""),
        (cellId: kDropDownCell, placeHolderTitle: "Выберите тему обращения", data: false),
        (cellId: kDropDownCell, placeHolderTitle: "Выберите населенный пункт", data: false),
        (cellId: kDropDownCell, placeHolderTitle: "Выберите магазин", data: false),
        (cellId: kTextViewCell, placeHolderTitle: "Укажите содержание сообщения", data: ""),
        (cellId: kCheckBoxCell, placeHolderTitle: "Вы должны принять пользовательское соглашение", data: false),
        (cellId: kButtonCell, placeHolderTitle: "", data: false)
    ]
    
    private var dropDownItems = Array<[Int: String]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dropDownItems.append([0: "Ивановская область", 1: "Ленинградская область", 2: "Московская область"])
        dropDownItems.append([0: "Иваново", 1: "Кинешма", 2: "Шуя"])
        dropDownItems.append([0: "ул. Генерала Белова, 34", 1: "ул. Ленина, 21", 2: "ул. Хлебникова, 9"])
        
        self.title = "Обратная связь"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 48.0
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "cellHeight" {
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    //MARK: - Helpers
    
    func hideKeyboard() -> Void {
        
        self.view.endEditing(true)
    }

    func textFieldBeginEditing(textField: UITextField) {
        
        self.hideDropDownMenu()
    }
    
    func textFieldEditingChanged(textField: UITextField) {
        
        if let text = textField.text {
            
            self.changeCellData(text, atIndex: textField.tag)
        }
    }
    
    func maskFieldDidBeginEditing(maskField: AKMaskField) {
        
        self.textFieldBeginEditing(maskField)
    }
    
    func maskField(maskField: AKMaskField, didChangeCharactersInRange range: NSRange, replacementString string: String, withEvent event: AKMaskFieldEvent) {
        
        self.textFieldEditingChanged(maskField)
    }

    func changeCellDataPlaceholder(placeholder: String, atIndex index: Int) -> Void {

        var cellData = self.objects[index]
        cellData.placeHolderTitle = placeholder
        
        self.objects.replaceAtIndex(cellData, atIndex: index)
    }
    
    func changeCellData(data: AnyObject, atIndex index: Int) -> Void {
        
        var cellData = self.objects[index]
        cellData.data = data
        
        self.objects.replaceAtIndex(cellData, atIndex: index)
    }
    
    func buttonCellAction(sender: UIButton) -> Void {

        self.hideKeyboard()
        
        if sender.tag == 0 {
            
            for (index, cellData) in self.objects.enumerate() {
                
                if cellData.data is String {
                    
                    self.changeCellData("", atIndex: index)
                    
                } else if cellData.data is Bool {
                    
                    self.changeCellData(false, atIndex: index)
                }
            }
            
            self.tableView.reloadData()
            
        } else {
            
            let email = self.objects[1].data as! String
            
            if isValidEmail(email) {
                
                let alertController = UIAlertController(title: nil, message: "Отправлено", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                
                    self.objects = self.constants
                    self.tableView.reloadData()
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                
                let alertController = UIAlertController(title: "Ошибка ввода", message: "При заполнении поля использованы недопустимые символы", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func isValidEmail(testStr: String) -> Bool {

        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
    }
    
    func configureCell(cellData: CellData, indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = BaseTableViewCell()
        
        if indexPath.row != 2 && cellData.cellId == kTextFieldCell {
            
            if let view = self.tableView.dequeueReusableCellWithIdentifier(cellData.cellId, forIndexPath: indexPath) as? TextFieldCell {
                
                view.textField.tag = indexPath.row
                view.textField.placeholder = cellData.placeHolderTitle
                view.textField.text = cellData.data as? String
                view.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
                view.textField.addTarget(self, action: #selector(textFieldBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
                
                cell = view
            }
            
        } else if cellData.cellId == kMaskTextFieldCell {
            
            if let view = self.tableView.dequeueReusableCellWithIdentifier(cellData.cellId, forIndexPath: indexPath) as? MaskTextFieldCell {
                
                view.maskTextField.maskDelegate = self
                view.maskTextField.tag = indexPath.row
                view.maskTextField.placeholder = cellData.placeHolderTitle
                view.maskTextField.addTarget(self, action: #selector(hideKeyboard), forControlEvents: UIControlEvents.EditingDidEndOnExit)
                if cellData.data as? String != view.maskTextField.maskTemplate {
                    
                    view.maskTextField.text = cellData.data as? String
                }

                cell = view
            }
        
        } else if cellData.cellId == kCheckBoxCell {
            
            if let view = self.tableView.dequeueReusableCellWithIdentifier(cellData.cellId, forIndexPath: indexPath) as? CheckBoxCell {
                
                view.checked = cellData.data as! Bool
                
                cell = view
            }
        
        } else if cellData.cellId == kButtonCell {
            
            if let view = self.tableView.dequeueReusableCellWithIdentifier(cellData.cellId, forIndexPath: indexPath) as? ButtonCell {
                
                view.clearAllButton.addTarget(self, action: #selector(buttonCellAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                view.submitButton.addTarget(self, action: #selector(buttonCellAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                view.submitButton.enabled = cellData.data as! Bool
                view.submitButton.backgroundColor = view.submitButton.enabled ? UIColor.blueColor() : UIColor.lightGrayColor()
                
                cell = view
            }
        
        } else if cellData.cellId == kDropDownCell {
            
            if let view = self.tableView.dequeueReusableCellWithIdentifier(cellData.cellId, forIndexPath: indexPath) as? DropDownCell {

                view.delegate = self
                view.titleLabel.text = cellData.placeHolderTitle
                view.drop = cellData.data as! Bool

                view.items = self.dropDownItems[indexPath.row - 3]
                
                cell = view
            }
        
        } else if cellData.cellId == kTextViewCell {
            
            if let view = self.tableView.dequeueReusableCellWithIdentifier(cellData.cellId, forIndexPath: indexPath) as? TextViewCell {

                view.delegate = self
                
                view.textView.tag = indexPath.row
                
                view.textView.attributedPlaceholder = NSAttributedString(string: cellData.placeHolderTitle, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14.0), NSForegroundColorAttributeName: UIColor(red: 0.778, green: 0.778, blue: 0.796, alpha: 1)])
                view.textView.text = cellData.data as! String
                
                view.addObserver(self, forKeyPath: "cellHeight", options: NSKeyValueObservingOptions.New, context: nil)
                
                cell = view
            }
        }
        
        if indexPath.row == 0 {
            
            cell.topBorder = true
            cell.bootomBorder = true
            
        } else {
            
            cell.bootomBorder = true
        }
        
        return cell
    }
    
    func hideDropDownMenu() -> Void {

        var indexPaths = Array<NSIndexPath>()
        
        for (index, cellData) in self.objects.enumerate() {
            
            if cellData.data is Bool && index != 7 {
                
                self.changeCellData(false, atIndex: index)

                indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
}

extension MainController {
    
    //MARK: - UITableViewData Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellData = objects[indexPath.row]
        
        return configureCell(cellData, indexPath: indexPath)
    }
    
    //MARK: - UITableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 7 || (indexPath.row >= 3 && indexPath.row <= 5) {
        
            self.hideDropDownMenu()
            
            let cellData = self.objects[indexPath.row]
            let checked = cellData.data as! Bool
            
            self.changeCellData(!checked, atIndex: indexPath.row)
            
            if indexPath.row == 7 {
                
                self.changeCellData(!checked, atIndex: indexPath.row + 1)
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 6 {
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TextViewCell {

                return cell.cellHeight
            }
        }
        
        return 48.0
    }
}

extension MainController: TextViewCellDelegate {
    
    //MARK: - TextViewCell Delegate
    
    func textViewCell(textViewCell: TextViewCell, textViewDidChange textView: UITextView) {
        
        if let text = textView.text {
            
            self.changeCellData(text, atIndex: textView.tag)
        }
    }
}

extension MainController: DropDownCellDelegate {
    
    //MARK: - DropDownCell Delegate
    
    func dropDownCell(dropDownCell: DropDownCell, didChangeTitleText text: String?) {
        
        if let text = text, indexPath = self.tableView.indexPathForCell(dropDownCell) {

            self.changeCellDataPlaceholder(text, atIndex: indexPath.row)
        }
    }
}