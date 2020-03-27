//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Jay Ho on 3/5/20.
//  Copyright © 2020 Jay Ho. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    var flashcardsController: ViewController!
    var questionText: String = ""
    var answerText: String = ""
    var extraAnswer1: String = ""
    var extraAnswer2: String = ""
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    var initialQuestion: String?
    var initialAnswer: String?
    @IBOutlet weak var extraAnswer1TextField: UITextField!
    
    @IBOutlet weak var extraAnswer2TextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        let extraAnswer1 = extraAnswer1TextField.text
        let extraAnswer2 = extraAnswer2TextField.text
        // See if it's existing
        var isExisting = false
        if initialQuestion != nil{
            isExisting = true
        }
        // check if empty, nil means the variable means empty and no value assigned
        if (questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty || extraAnswer1 == nil || extraAnswer2 == nil || extraAnswer1!.isEmpty || extraAnswer2!.isEmpty){
            let alert = UIAlertController(title: "Missing Text!", message: "You need to enter both a question and an answer.", preferredStyle: .alert)
            present(alert, animated: true)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
        }else{
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswer1, extraAnswerTwo: extraAnswer2, isExisting: isExisting)
            dismiss(animated: true)
        }
    }


}
