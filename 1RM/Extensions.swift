/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func isAlmostNull() -> Bool {
        return abs(self) <= Double.ulpOfOne
    }
}
