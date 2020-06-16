// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

@IBDesignable class WeightScaleView: UIView {

    @IBInspectable var minWeight: CGFloat = 0.0
    @IBInspectable var maxWeight: CGFloat = 1000.0
    @IBInspectable var majorStep: CGFloat = 100.0
    @IBInspectable var minorStep: CGFloat = 5

    @IBInspectable var unit: String = defaultMassUnit

    @IBInspectable var majorTickWidth: CGFloat = 2.0
    @IBInspectable var minorTickWidth: CGFloat = 1.0
    @IBInspectable var majorTickHeight: CGFloat = 20.0
    @IBInspectable var minorTickHeight: CGFloat = 10.0
    @IBInspectable var majorTickColor: UIColor = .blue
    @IBInspectable var minorTickColor: UIColor = .lightGray
    @IBInspectable var majorTickDistance: CGFloat = 200

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // debugPrint("WeightScaleView.draw(coder:\(rect)")
        backgroundColor = UIColor(named: "Olive")
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(majorTickColor.cgColor)
            context.setLineWidth(majorTickWidth)
            for weight in stride(from: minWeight, to: maxWeight, by: majorStep) {
                let x = (minWeight + weight / (maxWeight - minWeight)) * self.frame.width
                debugPrint(weight, x, self.frame.width)
                context.move(to: CGPoint(x: x, y: 0))
                context.addLine(to: CGPoint(x: x, y: bounds.height))
                context.strokePath()
            }
        }
    }

    required init?(coder: NSCoder) {
        debugPrint("WeightScaleView.init(coder:)")
        super.init(coder: coder)
        self.frame = CGRect(x: 0, y: 0, width: (maxWeight - minWeight) / majorStep * majorTickDistance, height: self.bounds.height)
        debugPrint(self.frame)
    }
}
