// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextView.backgroundColor = .white
        if let filepath = Bundle.main.url(forResource: "About", withExtension: "rtf"),
            let attributedString = try? NSAttributedString(
                url: filepath,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil) {
            aboutTextView.backgroundColor = .white
            aboutTextView.attributedText = attributedString
        }
    }

}
