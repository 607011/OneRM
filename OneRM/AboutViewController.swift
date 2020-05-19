/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextView.backgroundColor = .white
        if let filepath = Bundle.main.path(forResource: "About-1RM", ofType: "rtf")  {
            let attributedStringWithRtf = try? NSAttributedString(
                url: URL(fileURLWithPath: filepath),
                options: [.documentType : NSAttributedString.DocumentType.rtf],
                documentAttributes: nil)
            aboutTextView.attributedText = attributedStringWithRtf
        }
    }

}
