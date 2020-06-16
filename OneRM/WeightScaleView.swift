// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

@IBDesignable class WeightScaleView: UIView {

    @IBInspectable var minWeight: CGFloat = 0.0
    @IBInspectable var maxWeight: CGFloat = 1000.0
    @IBInspectable var majorStep: CGFloat = 5.0
    @IBInspectable var minorStep: CGFloat = 0.5
    @IBInspectable var unit: String = defaultMassUnit

    @IBInspectable var majorTickWidth: CGFloat = 2.0
    @IBInspectable var minorTickWidth: CGFloat = 1.0
    @IBInspectable var majorTickHeight: CGFloat = 20.0
    @IBInspectable var minorTickHeight: CGFloat = 10.0
    @IBInspectable var majorTickColor: UIColor = .blue
    @IBInspectable var minorTickColor: UIColor = .lightGray

    override func draw(_ rect: CGRect) {
    }

}
