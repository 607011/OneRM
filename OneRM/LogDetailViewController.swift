// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class LogDetailViewController: UITableViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var oneRMLabel: UILabel!
    @IBOutlet weak var repsAndWeightLabel: UILabel!
    @IBOutlet var starButton: [UIButton]!
    @IBOutlet weak var notesTextView: UITextView!

    var lift: Lift? {
        didSet {
            refreshUI()
        }
    }

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Locale.current.calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMY", options: 0, locale: Locale.current)
        return dateFormatter
    }()

    private func refreshUI() {
        guard let lift = lift else { return }
        loadViewIfNeeded()
        let minRating = min(Int(lift.rating), starButton.count)
        for i in 0..<minRating {
            starButton[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        for i in minRating..<starButton.count {
            starButton[i].setImage(UIImage(systemName: "star"), for: .normal)
        }
        dateLabel.text = dateFormatter.string(from: lift.date)
        exerciseLabel.text = lift.exercise.name
        oneRMLabel.text = "\(lift.oneRM.rounded(toPlaces: 1)) \(lift.unit.name)"
        repsAndWeightLabel.text = "\(lift.reps) × \(lift.weight.rounded(toPlaces: 1)) \(lift.unit.name)"
        notesTextView.text = lift.notes
    }

}
