/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation

protocol OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double
    func rm(for reps: Int, with oneRM: Double) -> Double
}

class Epley: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return reps == 1
            ? weight
            : weight * (1 + Double(reps) / 30.0)
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return reps == 1
            ? oneRM
            : oneRM / (1 + Double(reps) / 30.0)
    }
}

class Brzycki: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return reps == 1
            ? weight
            : weight * 36.0 / Double(37 - reps)
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return oneRM * Double(37 - reps) / 36.0
    }
}

class McGlothin: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return reps == 1
            ? weight
            : 1e2 * weight / (101.3 - 2.67123 * Double(reps))
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return reps == 1
            ? oneRM
            : 1e-2 * oneRM * (101.3 - 2.67123 * Double(reps))
    }
}

class Lombardi: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return weight * pow(Double(reps), 0.1)
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return oneRM / pow(Double(reps), 0.1)
    }
}

class Mayhew: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return reps == 1
            ? weight
            : 1e2 * weight / (52.2 + 41.9 * exp(-0.055 * Double(reps)))
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return reps == 1
            ? oneRM
            : 1e-2 * oneRM * (52.2 + 41.9 * exp(-0.055 * Double(reps)))
    }
}

class OConner: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return reps == 1
            ? weight
            : weight * (1 + Double(reps) / 40.0)
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return reps == 1
            ? oneRM
            : oneRM / (1 + Double(reps) / 40.0)
    }
}

class Wathen: OneRMFormula {
    func oneRM(weight: Double, reps: Int) -> Double {
        return reps == 1
            ? weight
            : 1e2 * weight / (48.8 + 53.8 * exp(-0.075 * Double(reps)))
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        return reps == 1
            ? oneRM
            : 1e-2 * oneRM * (48.8 + 53.8 * exp(-0.075 * Double(reps)))
    }
}

class MixedOneRM: OneRMFormula {
    var formulas: [Formula] = []
    init(formulas: [Formula]) {
        self.formulas = formulas
    }
    init(formulas: [String]) {
        self.formulas = formulas.map { Formula(rawValue: $0) ?? .brzycki }
    }
    func oneRM(weight: Double, reps: Int) -> Double {
        let sum = formulas.map({ DefaultFormulas[$0]!.oneRM(weight: weight, reps: reps) }).reduce(0, +)
        return sum / Double(formulas.count)
    }
    func rm(for reps: Int, with oneRM: Double) -> Double {
        let sum = formulas.map({ DefaultFormulas[$0]!.rm(for: reps, with: oneRM) }).reduce(0, +)
        return sum / Double(formulas.count)
    }
}

enum Formula: String {
    case epley = "Epley"
    case brzycki = "Brzycki"
    case mcglothin = "McGlothin"
    case lombardi = "Lombardi"
    case mayhew = "Mayhew et al."
    case oconner = "O'Conner et al."
    case wathen = "Wathen"
}

let DefaultFormulas: [Formula:OneRMFormula] = [
    .epley: Epley(),
    .brzycki: Brzycki(),
    .mcglothin: McGlothin(),
    .lombardi: Lombardi(),
    .mayhew: Mayhew(),
    .oconner: OConner(),
    .wathen: Wathen(),
]
