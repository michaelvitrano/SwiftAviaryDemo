//
//  AutoLayoutHelpers.swift
//  Dial
//
//  Created by Michael Vitrano on 6/22/14.
//  Copyright (c) 2014 Vitrano. All rights reserved.
//

import Foundation
import UIKit

func constraintsWithBindings(bindings: Dictionary<String, UIView>, #metrics: Dictionary<String, Float>?, #formats: String[]) -> NSLayoutConstraint[] {
    var constraintArray = NSLayoutConstraint[]()
    
    for format in formats {
        let newConstraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: metrics, views: bindings) as NSLayoutConstraint[]
        constraintArray.extend(newConstraints)
    }
    
    return constraintArray
}

func constraintToSetLayoutAttribute(layoutAttr:NSLayoutAttribute, ofView view:UIView, equalToView otherView:UIView, constant:Float = 0.0, multiplier: Float = 1.0) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: view, attribute: layoutAttr, relatedBy: .Equal, toItem: otherView, attribute: layoutAttr, multiplier: multiplier, constant: constant);
}

func constraintToSetLayoutAttribute(layoutAttr:NSLayoutAttribute, ofView view:UIView, equalToConstant constant:Float) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: view, attribute: layoutAttr, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: constant)
}

func constraintToSetLayoutAttribute(layoutAttr:NSLayoutAttribute, ofViewEqualToSuperview view:UIView) -> NSLayoutConstraint {
    return constraintToSetLayoutAttribute(layoutAttr, ofView: view, equalToView: view.superview)
}

func constraintToCenterViewHorizontallyInSuperview(view:UIView) -> NSLayoutConstraint {
    return constraintToSetLayoutAttribute(.CenterX, ofViewEqualToSuperview: view)
}

func constraintToCenterViewVerticallyInSuperview(view:UIView) -> NSLayoutConstraint {
    return constraintToSetLayoutAttribute(.CenterX, ofViewEqualToSuperview: view)
}

func constraintsToCenterViewInSuperview(view:UIView) -> NSLayoutConstraint[] {
    return [constraintToCenterViewHorizontallyInSuperview(view), constraintToCenterViewVerticallyInSuperview(view)];
}

func constraintToSetViewWidth(view: UIView, width:Float) -> NSLayoutConstraint {
    return constraintToSetLayoutAttribute(.Width, ofView: view, equalToConstant: width)
}

func constraintToSetViewHeight(view: UIView, height:Float) -> NSLayoutConstraint {
    return constraintToSetLayoutAttribute(.Height, ofView: view, equalToConstant: height)
}

func constraintsToSetViewSize(view: UIView, width:Float, height:Float) -> NSLayoutConstraint[] {
    return [constraintToSetViewWidth(view, width), constraintToSetViewHeight(view, height)]
}

func constraintsToSetViewSize(view: UIView, size:CGSize) -> NSLayoutConstraint[] {
    return constraintsToSetViewSize(view, size.width, size.height)
}

