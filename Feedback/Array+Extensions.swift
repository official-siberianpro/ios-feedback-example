//
//  Array+Extensions.swift
//  Feedback
//
//  Created by Aleksandr Sadikov on 31.08.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

import Foundation

extension Array {
    
    func enumerateObjectsUsingBlock(handler:(idx: Int, object: Element) -> Void) {
        
        for (index, item) in self.enumerate() {
            
            handler(idx: index, object: item)
        }
    }
    
    func enumerateObjectsUsingBlock(handler:(idx: Int, object: Element, inout stop: Bool) -> Void) {
        
        var breakLoop = false
        
        for (index, item) in self.enumerate() {
            
            handler(idx: index, object: item, stop: &breakLoop)
            
            if breakLoop { break }
        }
    }
    
    mutating func replaceAtIndex(newElement: Element, atIndex: Int) {
        
        self.removeAtIndex(atIndex)
        self.insert(newElement, atIndex: atIndex)
    }
}