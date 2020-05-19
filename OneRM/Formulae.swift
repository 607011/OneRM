/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation

func epley(weight: Double, reps: Int) -> Double {
    return weight * (1 + Double(reps) / 30.0)
}

func brzycki(weight: Double, reps: Int) -> Double {
    return weight * 36.0 / Double(37 - reps)
}
func brzycki_rev(maxWeight: Double, reps: Int) -> Double {
    return maxWeight * Double(37 - reps) / 36.0
}

func mcglothin(weight: Double, reps: Int) -> Double {
    return 100 * weight / (101.3 - 2.67123 * Double(reps))
}
func lombardi(weight: Double, reps: Int) -> Double {
    return weight * pow(Double(reps), 0.10)
}
func mayhew(weight: Double, reps: Int) -> Double {
    return 100 * weight / (52.2  + 41.9*exp(-0.055 * Double(reps)))
}
func oconner(weight: Double, reps: Int) -> Double {
    return weight * (1 + Double(reps) / 40.0)
}
func wathen(weight: Double, reps: Int) -> Double {
    return 100 * weight / (48.8 + 53.8 * exp(-0.075 * Double(reps)))
}
