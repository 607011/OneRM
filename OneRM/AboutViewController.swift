// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import CDMarkdownKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextView.backgroundColor = .white
        if let filepath = Bundle.main.path(forResource: "About", ofType: "md"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)),
            let markdown = String(bytes: data, encoding: .utf8) {
            aboutTextView.attributedText = CDMarkdownParser().parse(markdown)
        }
    }

}
