//
//  ViewUtils.swift
//  TicketMatic
//
//  Created by Kristof Van Landschoot on 23/08/2017.
//  Copyright © 2017 TicketMatic. All rights reserved.
//

import UIKit
import SwiftUI
import CoreImage.CIFilterBuiltins

class ViewUtils {
    class func viewDictionary(_ mirrorFrom: Any) -> [String:UIView] {
        var v:[String:UIView] = [:]
        let m = Mirror(reflecting: mirrorFrom)
        for case let (label?, value) in m.children {
            if let viewValue = value as? UIView {
                v[label] = viewValue
            }
        }
        return v
    }
    
    class func addShadow(_ v: UIView) {
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 1
        v.layer.shadowOpacity = 0.2
        v.clipsToBounds = false
    }
    
    class func shadowView(backgroundColor: UIColor, shadowHeight: CGFloat) -> UIView {
        let v = ViewUtils.prepare(UIView())
        v.backgroundColor = backgroundColor
        ViewUtils.addShadow(v)
        v.layer.shadowOffset = CGSize(width: 0, height: shadowHeight)
        return v
    }

    class func lineSpacedString(_ s: String,
                                spacing: Double,
                                alignment: NSTextAlignment = NSTextAlignment.left) -> NSAttributedString {
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 5
        paragraphStyle1.alignment = alignment
        
        let attributedString = NSMutableAttributedString(string: s)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle1,
                                      range:NSMakeRange(0, (s as NSString).length))
        return attributedString
    }

    class func addTopShadowView(_ vc: UIViewController, _ bgcolor: UIColor? = nil) {
        var bgcolorresolved = bgcolor
        if bgcolorresolved == nil {
            bgcolorresolved = vc.view.backgroundColor
        }
        guard let bgcolor = bgcolorresolved else { return }
        let sv = shadowView(backgroundColor: bgcolor, shadowHeight: 2)
        let cb = ConstraintsBuilder(view: vc.view)
        cb.add(.superView,.distance(0),.view(sv),.distance(0),.superView)
        cb.add(.vertical,
               .size(sv,5))
        sv.bottomAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
    }
    
    class func addBottomShadowView(_ vc: UIViewController) {
        guard let bgcolor = vc.view.backgroundColor else { return }
        let sv = shadowView(backgroundColor: bgcolor, shadowHeight: -2)
        let cb = ConstraintsBuilder(view: vc.view)
        cb.add(.superView,.distance(0),.view(sv),.distance(0),.superView)
        cb.add(.vertical,
               .size(sv,5))
        sv.topAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
    }
    
    class func alert(title: String?, message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(action)
        return alert
    }
    

    
    class func prepare<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UIView {
        v.translatesAutoresizingMaskIntoConstraints = false
        finish?(v)
        return v
    }
    
    class func prepare<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UIImageView {
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        finish?(v)
        return v
    }
    
    class func prepare<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UILabel {
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        finish?(v)
        return v
    }
    
    class func prepare<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UITextField {
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 4
        v.layer.borderWidth = 1
        finish?(v)
        return v
    }
    
    class func addScrollView(inView view: UIView) -> UIView {
        // this method sets up a scroll view in a view and a subview in that scrollview with the
        // same with as the view.
        // So the hierarchy becomes:   [view:UIView]               <--|
        //                            [scrollView:UIScrollView]       |  same width
        //                              [scrollSubview:UIView]     <--|
        // The scrollView and its superview will keep same height and width
        let scrollView = ViewUtils.prepare(UIScrollView())
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|-0-[sv]-0-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["sv":scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[sv]-0-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["sv":scrollView]))
        
        let scrollSubview = ViewUtils.prepare(UIView())
        scrollView.addSubview(scrollSubview)
        scrollView.keyboardDismissMode = .onDrag
        scrollView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|-0-[scrollSubview]-0-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil,
            views: ["scrollSubview":scrollSubview]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[scrollSubview]-0-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil,
            views: ["scrollSubview":scrollSubview]))
        view.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .width,
            relatedBy: .equal,
            toItem: scrollSubview,
            attribute: .width,
            multiplier: 1, constant: 0))
        return scrollSubview
    }
}
