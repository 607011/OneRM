// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class DetailLogViewController: UIViewController {

    var lift: Lift? {
        didSet {
            refreshUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func refreshUI() {
        loadViewIfNeeded()

    }

}

extension DetailLogViewController: LiftSelectionDelegate {
    func liftSelected(_ newLift: Lift) {
        lift = newLift
    }
}
