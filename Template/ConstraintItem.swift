//
//  ConstraintItem.swift
//  TicketMatic
//
//  Created by Kristof Van Landschoot on 09/11/2017.
//  Copyright © 2017 TicketMatic. All rights reserved.
//

import UIKit

//enum ConstraintDistanceType {
//    case equal
//    case lessThanOrEqualTo
//    case greaterThanOrEqualTo
//}

enum ConstraintItem {
    case vertical
    case horizontal
    case size(UIView,CGFloat)
    case view(UIView)
    case distance(CGFloat)
    //case typedDistance(CGFloat,ConstraintDistanceType)
    case superView
    case safeLayout
    case alignAllCenterY
    case alignAllCenterX

    func getRightAnchor(superView: UIView) -> NSLayoutXAxisAnchor? {
        switch self {
        case .size(let v, _):
            return v.rightAnchor
        case .view(let v):
            return v.rightAnchor
        case .safeLayout:
            return superView.safeAreaLayoutGuide.leftAnchor
        case .superView:
            return superView.leftAnchor
        default:
            return nil
        }
    }
    
    func getRightMargin(superView: UIView) -> CGFloat? {
        switch self {
        case .size(let v, _):
            return v.layoutMargins.right
        case .view(let v):
            return v.layoutMargins.right
        case .safeLayout:
            return superView.layoutMargins.left
        case .superView:
            return superView.layoutMargins.left
        default:
            return nil
        }
    }
    
    func getBottomAnchor(superView: UIView) -> NSLayoutYAxisAnchor? {
        switch self {
        case .size(let v, _):
            return v.bottomAnchor
        case .view(let v):
            return v.bottomAnchor
        case .safeLayout:
            return superView.safeAreaLayoutGuide.topAnchor
        case .superView:
            return superView.topAnchor
        default:
            return nil
        }
    }
    
    func getBottomMargin(superView: UIView) -> CGFloat? {
        switch self {
        case .size(let v, _):
            return v.layoutMargins.bottom
        case .view(let v):
            return v.layoutMargins.bottom
        case .safeLayout:
            return superView.layoutMargins.top
        case .superView:
            return superView.layoutMargins.top
        default:
            return nil
        }
    }
}

func ==(lhs:ConstraintItem, rhs:ConstraintItem) -> Bool {
    switch (lhs,rhs) {
    case (.vertical,.vertical): return true
    case (.horizontal,.horizontal): return true
    case (.safeLayout,.safeLayout): return true
    case (.superView,.superView): return true
    default: return false
    }
}


