/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet private weak var exerciseLabel: UILabel!

    var exercise: Exercise? {
        didSet {
            guard let exercise = exercise else { return }
            exerciseLabel.text = exercise.name
        }
    }
}

