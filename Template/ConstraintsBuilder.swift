//
//  ConstraintsBuilder.swift
//  TicketMatic
//
//  Created by Kristof Van Landschoot on 23/08/2017.
//  Copyright © 2017 TicketMatic. All rights reserved.
//

import UIKit

extension NSLayoutConstraint.FormatOptions: Hashable {
    public var hashValue: Int {
        return Int(rawValue)
    }
}

class ConstraintsBuilder {    
    var constraints: [NSLayoutConstraint] = []
    var views: [String:UIView] = [:]
    static let minimumTapSize: CGFloat = 44
    private weak var view: UIView!
    
    // take views from introspection, add constraints to vc.view
    init(viewController vc: UIViewController, inScrollView: Bool) {
        if inScrollView {
            view = ViewUtils.addScrollView(inView: vc.view)
        } else {
            view = vc.view
        }
        views = ViewUtils.viewDictionary(vc)
    }
    
    // set up views yourself after init, add constraints to view
    init(view v: UIView) {
        view = v
        views = ViewUtils.viewDictionary(v)
    }
    
    deinit {
        view.addConstraints(constraints)
    }
    
    func getScrollView() -> UIScrollView? {
        return view.superview as? UIScrollView
    }
    
    func flushConstraints() {
        view.addConstraints(constraints)
        constraints = []
    }
    
    static func pin(_ v1: UIView, _ v2: UIView) {
        v1.topAnchor.constraint(equalTo: v2.topAnchor).isActive = true
        v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor).isActive = true
        v1.leftAnchor.constraint(equalTo: v2.leftAnchor).isActive = true
        v1.rightAnchor.constraint(equalTo: v2.rightAnchor).isActive = true
    }
    
    func pin(_ v: UIView) {
        if v.superview == nil {
            view.addSubview(v)
        }
        ConstraintsBuilder.pin(v,view)
    }
    
    private func bind(horizontal: Bool,
                      v: UIView,
                      lastConstraintViewItem: ConstraintItem?,
                      distanceToLastView: CGFloat?) -> [NSLayoutConstraint] {
        if v.superview == nil && v != view {
            view.addSubview(v)
        }
        v.translatesAutoresizingMaskIntoConstraints = false
        if let lci = lastConstraintViewItem {
            let c: NSLayoutConstraint
            var dlv: CGFloat? = distanceToLastView
            if horizontal {
                let xAnchorView = v.leftAnchor
                let xAnchorLV = lci.getRightAnchor(superView: view)!
                if dlv == nil {
                    dlv = lci.getRightMargin(superView: view)
                }
                c = xAnchorView.constraint(
                    equalTo: xAnchorLV,
                    constant: dlv ?? 0)
            } else {
                let yAnchorView = v.topAnchor
                let yAnchorLV = lci.getBottomAnchor(superView: view)!
                if dlv == nil {
                    dlv = lci.getBottomMargin(superView: view)
                }
                c = yAnchorView.constraint(
                    equalTo: yAnchorLV,
                    constant: dlv ?? 0)
            }
            return [c]
        }
        return []
    }
    
    @discardableResult func add(_ constraintArray: ConstraintItem...) -> [NSLayoutConstraint] {
        let horizontal = !((constraintArray.first ?? .horizontal) == .vertical)
        var newconstraints: [NSLayoutConstraint] = []
        var lastConstraintViewItem: ConstraintItem? = nil
        var distanceToLastView: CGFloat? = nil
        //var distanceType: ConstraintDistanceType = .equal
        var allViews: Set<UIView> = []
        var finalConstraints: Set<NSLayoutConstraint.FormatOptions> = []
        constraintArray.forEach { element in
            switch element {
            case .size(let v, let s):
                newconstraints.append(contentsOf: bind(
                    horizontal: horizontal,
                    v: v,
                    lastConstraintViewItem: lastConstraintViewItem,
                    distanceToLastView: distanceToLastView))
                if horizontal {
                    newconstraints.append(v.widthAnchor.constraint(equalToConstant: s))
                } else {
                    newconstraints.append(v.heightAnchor.constraint(equalToConstant: s))
                }
                lastConstraintViewItem = element
                distanceToLastView = nil
                allViews.insert(v)
            case .view(let v):
                newconstraints.append(contentsOf: bind(
                    horizontal: horizontal,
                    v: v,
                    lastConstraintViewItem: lastConstraintViewItem,
                    distanceToLastView: distanceToLastView))
                lastConstraintViewItem = element
                distanceToLastView = nil
                allViews.insert(v)
            case .safeLayout:
                allViews.insert(view)
                if let lvi = lastConstraintViewItem {
                    if horizontal {
                        let rightAnchor = lvi.getRightAnchor(superView: view)!
                        newconstraints.append(view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: rightAnchor, constant: distanceToLastView ?? 0))
                    } else {
                        let bottomAnchor = lvi.getBottomAnchor(superView: view)!
                        newconstraints.append(view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: distanceToLastView ?? 0))
                    }
                }
                lastConstraintViewItem = element
                distanceToLastView = nil
            case .superView:
                allViews.insert(view)
                if let lci = lastConstraintViewItem {
                    if horizontal {
                        var dlv: CGFloat? = distanceToLastView
                        if dlv == nil {
                            dlv = view.layoutMargins.right
                        }
                        let rightAnchor = lci.getRightAnchor(superView: view)!
                        newconstraints.append(view.rightAnchor.constraint(equalTo: rightAnchor, constant: dlv ?? 0))
                    } else {
                        var dlv: CGFloat? = distanceToLastView
                        if dlv == nil {
                            dlv = lci.getBottomMargin(superView: view)
                        }
                        let bottomAnchor = lci.getBottomAnchor(superView: view)!
                        newconstraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: dlv ?? 0))
                    }
                }
                lastConstraintViewItem = element
                distanceToLastView = nil
            case .distance(let d):
                distanceToLastView = d
//                distanceType = .equal
//            case .typedDistance(let d, let dtype):
//                distanceToLastView = d
//                distanceType = dtype
            case .vertical:
                break
            case .horizontal:
                break
            case .alignAllCenterX:
                finalConstraints.insert(.alignAllCenterX)
            case .alignAllCenterY:
                finalConstraints.insert(.alignAllCenterY)
            }
        }
        if let firstView = allViews.first {
            let otherViews = allViews.dropFirst()
            otherViews.forEach({ v in
                finalConstraints.forEach({ options in
                    if options == .alignAllCenterX {
                        let c = firstView.centerXAnchor.constraint(equalTo: v.centerXAnchor)
                        newconstraints.append(c)
                    } else if options == .alignAllCenterY {
                        let c = firstView.centerYAnchor.constraint(equalTo: v.centerYAnchor)
                        newconstraints.append(c)
                    }
                })
            })
        }
        constraints.append(contentsOf: newconstraints)
        return newconstraints
    }
    
    @discardableResult func add(_ constraint: String,
                                options: [NSLayoutConstraint.FormatOptions]? = nil) -> [NSLayoutConstraint] {
        var optionsOrred = NSLayoutConstraint.FormatOptions(rawValue: 0)
        options?.forEach { (o: NSLayoutConstraint.FormatOptions) in
            optionsOrred = NSLayoutConstraint.FormatOptions(rawValue: optionsOrred.rawValue | o.rawValue)
        }
        
        let addedConstraints = NSLayoutConstraint.constraints(withVisualFormat: constraint,
                                                              options: optionsOrred,
                                                              metrics: [:],
                                                              views: views)
        constraints.append(contentsOf: addedConstraints)
        return addedConstraints
    }
    
    @discardableResult func addRelation(_ view1: UIView, _ view2: UIView, _ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
//        if view1.superview == nil && view1 != view {
//            view.addSubview(view1)
//        }
//        if view2.superview == nil && view2 != view {
//            view.addSubview(view2)
//        }
        let c = NSLayoutConstraint(item: view1, attribute: attribute, relatedBy: relation,
                                   toItem: view2, attribute: attribute, multiplier: 1, constant: 0)
        constraints.append(c)
        return c
    }
    
    func addSubviews(_ h: [UIView]) {
        h.forEach { view?.addSubview($0) }
    }
    
    func addAllSubviews() {
        views.forEach { view?.addSubview($0.value) }
    }
}
