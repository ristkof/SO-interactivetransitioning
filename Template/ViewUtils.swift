
import UIKit
import SwiftUI
import CoreImage.CIFilterBuiltins

class ViewUtils {
    class func configure<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UIView {
        v.translatesAutoresizingMaskIntoConstraints = false
        finish?(v)
        return v
    }
}
