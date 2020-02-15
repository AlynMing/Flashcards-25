//
//  ViewController.swift
//  Flashcards
//
//  Created by Jay Ho on 2/15/20.
//  Copyright © 2020 Jay Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    override func viewDidLoad() { //this is what happened when run the app
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        questionLabel.isHidden = true
    }
}

