//
//  UIControlEventHandling.swift
//  Dial
//
//  Created by Michael Vitrano on 6/22/14.
//  Copyright (c) 2014 Vitrano. All rights reserved.
//

import Foundation
import UIKit

class EventHandlerHelper : NSObject {
    let action: (UIControl) -> ()
    init(action:(UIControl) -> ()) {
        self.action = action
    }
    func action(sender:UIControl) {
        self.action(sender)
    }
}

extension UIControl {
    
    func on(events: UIControlEvents, action: ((UIControl) -> ())?) {
        
        let pointer = UnsafePointer<Void>(events.value.asSigned())
        
        var oldEventHelper = objc_getAssociatedObject(self, pointer) as? EventHandlerHelper
        if let concreteOldHelper = oldEventHelper {
            self.removeTarget(concreteOldHelper, action: "action:", forControlEvents: events)
        }
        
        var eventHelper: AnyObject?
        if let concreteAction = action {
            eventHelper = EventHandlerHelper(concreteAction)
            self.addTarget(eventHelper, action: "action:", forControlEvents: events)
        }
        
        objc_setAssociatedObject(self, pointer, eventHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC.asUnsigned())
    }
}
