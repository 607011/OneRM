// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import CDMarkdownKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var licenseTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let filepath = Bundle.main.path(forResource: "gpl-3.0", ofType: "md"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)),
            let markdown = String(bytes: data, encoding: .utf8) {
            licenseTextView.backgroundColor = .white
            licenseTextView.attributedText = CDMarkdownParser().parse(markdown)
        }
    }

}
