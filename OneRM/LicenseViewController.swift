/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var licenseTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        licenseTextView.backgroundColor = .white
        if let filepath = Bundle.main.path(forResource: "gpl-3.0", ofType: "rtf")  {
            let attributedStringWithRtf = try? NSAttributedString(
                url: URL(fileURLWithPath: filepath),
                options: [.documentType : NSAttributedString.DocumentType.rtf],
                documentAttributes: nil)
            licenseTextView.attributedText = attributedStringWithRtf
        }
    }

}
