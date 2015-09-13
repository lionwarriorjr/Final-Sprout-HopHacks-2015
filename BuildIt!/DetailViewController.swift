//
//  DetailViewController.swift
//  BuildIt!
//
//  Created by Srihari Mohan on 7/25/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var this_pin_object: pinObject!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var baseImage: UIImageView!
    @IBOutlet weak var detailedDescLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descLabel.text = this_pin_object.title
        self.baseImage.image = this_pin_object.baseImage
        self.detailedDescLabel.text = this_pin_object.pinDescription
        self.detailedDescLabel.scrollRangeToVisible(NSRange(location: 0,length: 0))
    }
}
