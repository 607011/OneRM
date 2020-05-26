/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import CDMarkdownKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var licenseTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        licenseTextView.backgroundColor = .white
        if let filepath = Bundle.main.path(forResource: "gpl-3.0", ofType: "md")  {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)) else { return }
            guard let markdown = String(bytes: data, encoding: .utf8) else { return }
            licenseTextView.attributedText = CDMarkdownParser().parse(markdown)
        }
    }

}
