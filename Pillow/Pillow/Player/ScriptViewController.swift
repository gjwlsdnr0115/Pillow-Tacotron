//
//  ScriptViewController.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit

class ScriptViewController: UIViewController {

    var script = ""
    @IBOutlet weak var scriptTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scriptTextView.text = self.script
    }
}
