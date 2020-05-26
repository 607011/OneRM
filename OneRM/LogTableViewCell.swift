/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet private weak var repsAndWeightLabel: UILabel!
    @IBOutlet private weak var oneRMLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var exerciseLabel: UILabel!

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Locale.current.calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMY", options: 0, locale: Locale.current)
        return dateFormatter
    }()

    var lift: LiftData? {
        didSet {
            guard let lift = lift else { return }
            exerciseLabel.text = lift.exercise.name
            dateLabel.text = dateFormatter.string(from: lift.date)
            oneRMLabel.text = "\(lift.oneRM.rounded(toPlaces: 1)) \(lift.unit.name) 1RM"
            repsAndWeightLabel.text = "\(lift.reps) × \(lift.weight.rounded(toPlaces: 1)) \(lift.unit.name)"
        }
    }
}
