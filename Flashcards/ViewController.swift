//
//  ViewController.swift
//  Flashcards
//
//  Created by Jay Ho on 2/15/20.
//  Copyright © 2020 Jay Ho. All rights reserved.
//

import UIKit
struct Flashcard{
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}
class ViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    var flashcards = [Flashcard]()
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue"{
            creationController.initialQuestion = questionLabel.text
            creationController.initialAnswer = answerLabel.text
        }
    }
    var currentIndex = 0
    override func viewDidLoad() { //this is what happened when run the app
        super.viewDidLoad()
        
        // read saved flashcard
        readSavedFlashcards()
        if flashcards.count == 0{
            updateFlashcard(question: "What's the capital of Michigan", answer: "Lansing", extraAnswerOne: "Grand Rapids", extraAnswerTwo: "Holland")
        }else{
            updateLabels()
            updateNextPrevButton()
        }
        
        
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        questionLabel.layer.cornerRadius = 20.0
        answerLabel.layer.cornerRadius = 20.0
        questionLabel.isHidden = false
        answerLabel.isHidden = true
        questionLabel.clipsToBounds = true
        answerLabel.clipsToBounds = true
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionOne.clipsToBounds = true
        btnOptionTwo.clipsToBounds = true
        btnOptionThree.clipsToBounds = true
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if (answerLabel.isHidden == false){
            answerLabel.isHidden = true
            questionLabel.isHidden = false
            
        }
        else if (questionLabel.isHidden == true){
            questionLabel.isHidden = false
            answerLabel.isHidden = true;
        }
        else if (questionLabel.isHidden == false){
            answerLabel.isHidden = false
            questionLabel.isHidden = true
        }
        else if (answerLabel.isHidden == true){
            questionLabel.isHidden = true
            answerLabel.isHidden = false
        }
    }
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?){
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne!, extraAnswerTwo: extraAnswerTwo!)
        //adding flashcard to flashcard array
        flashcards.append(flashcard)
        //logging to console
        print("Added a new flashcard")
        print("We now have \(flashcards.count) flashcards")
        //update current index
        currentIndex = flashcards.count - 1
        print("the current index is \(currentIndex)")
        //update buttons
        updateNextPrevButton()
        // update labels
        updateLabels()
        
        
        saveAllFlashcardsToDisk()
    }
    func updateNextPrevButton(){
        // Disable the next button when reach the last flashcard
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        // Disable the prev button when reach the first flashcard
        if currentIndex == 0{
            prevButton.isEnabled = false
        }else{
            prevButton.isEnabled = true
        }
    }
    func updateLabels(){
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        // Update labels
        questionLabel.text = currentFlashcard.question
        answerLabel.text = currentFlashcard.answer
        btnOptionOne.setTitle(currentFlashcard.extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
        btnOptionThree.setTitle(currentFlashcard.extraAnswerTwo, for: .normal)

    }
    func saveAllFlashcardsToDisk(){
        //convert flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        //Save array on disk using UserDefault
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("Save flashcard to UserDisk")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            // In here we know for sure that we have a dictionary array
            let savedCards = dictionaryArray.map{dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"]!, extraAnswerTwo: dictionary["extraAnswerTwo"]!)
            }
            //Put all these cards in the flashcard array
            flashcards.append(contentsOf: savedCards)
        }
    }
    func deleteCurrentFlashcard(){
        // Delete current
        flashcards.remove(at: currentIndex)
        //Special case: Check if the last card deleted
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        updateNextPrevButton()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    @IBAction func didTapOptionTwo(_ sender: Any) {
        questionLabel.isHidden = true
        answerLabel.isHidden = false
    }
 
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    @IBAction func didTapOnPrev(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        //Update buttons
        updateNextPrevButton()
    }
    @IBAction func didTapOnNext(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex + 1
        
        //Update labels
        updateLabels()
        //Update buttons
        updateNextPrevButton()
    }
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (delete_action) in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}


