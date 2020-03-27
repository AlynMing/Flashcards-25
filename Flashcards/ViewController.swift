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
    var correctAnswerButton: UIButton!
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
            updateFlashcard(question: "What's the capital of Michigan", answer: "Lansing", extraAnswerOne: "Grand Rapids", extraAnswerTwo: "Holland", isExisting: false)
        }else{
            updateLabels()
            updateNextPrevButton()
        }
        //Styling
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // First start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        //Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
    }
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    func flipFlashcard(){
        //create a transition animation for the specified container view
        // pick this because it allows us to flip and modify the views it contains in the middle of the animation
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.questionLabel.isHidden == true{
                self.questionLabel.isHidden = false
                self.answerLabel.isHidden = false
            }
            else{
                self.questionLabel.isHidden = true
                self.answerLabel.isHidden = false
            }
            
        })
    }
    func animateCardOut(){
        //What we're basically doing there is telling iOS that you want to apply a transformation to your view. First we grab the identity transform, which is a special transform that means no transform at all, and then we're translating (moving) that transform by 300 points to the left (on the x axis).
        UIView.animate(withDuration: 0.2, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: {finished in
            //Update labels
            self.updateLabels()
            //run other animation
            self.animateCardIn()
        })
    }
    func animateCardIn(){
        //Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        //Animate card going back to its original position
        UIView.animate(withDuration: 0.2){
            self.card.transform = CGAffineTransform.identity
        }
    }
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?, isExisting: Bool){
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne!, extraAnswerTwo: extraAnswerTwo!)
        if isExisting{
            flashcards[currentIndex] = flashcard
        }else{
            //adding flashcard to flashcard array
            flashcards.append(flashcard)
            //logging to console
            print("Added a new flashcard")
            print("We now have \(flashcards.count) flashcards")
            //update current index
            currentIndex = flashcards.count - 1
            print("the current index is \(currentIndex)")
        }
        
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
    // This function is to update the text of the labels and buttons
    func updateLabels(){
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        // Update labels
        questionLabel.text = currentFlashcard.question
        answerLabel.text = currentFlashcard.answer
        //Update buttons
        let buttons = [btnOptionOne,btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        for (button, answer) in zip(buttons, answers){
            //Set the title of this random button, with a random answer
            button?.setTitle(answer, for: .normal)
            //If this is the correct answer save the button
            if answer == currentFlashcard.answer{
                correctAnswerButton = button
            }
        }
        /*
        btnOptionOne.setTitle(currentFlashcard.extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
        btnOptionThree.setTitle(currentFlashcard.extraAnswerTwo, for: .normal)
        */

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
    //This is function to delete the current flashcard
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
        //if correct answer, flip flashcard, else disable button and show front label
        if btnOptionOne == correctAnswerButton{
            flipFlashcard()
        }else{
            questionLabel.isHidden = false
            btnOptionOne.isEnabled = false
        }
        
    }
    @IBAction func didTapOptionTwo(_ sender: Any) {
        //if correct answer, flip flashcard, else disable button and show front label
        if btnOptionTwo == correctAnswerButton{
            flipFlashcard()
        }else{
            questionLabel.isHidden = false
            btnOptionTwo.isEnabled = false
        }
    }
 
    @IBAction func didTapOptionThree(_ sender: Any) {
        //if correct answer, flip flashcard, else disable button and show front label
        if btnOptionThree == correctAnswerButton{
            flipFlashcard()
        }else{
            questionLabel.isHidden = false
            btnOptionThree.isEnabled = false
        }
    }
    @IBAction func didTapOnPrev(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        //Update buttons
        updateNextPrevButton()
        animateCardIn()
    }
    // This function is for the next button
    @IBAction func didTapOnNext(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex + 1
        //Update buttons
        updateNextPrevButton()
        animateCardOut()
    }
    //This function is for the delete button
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        //create actions
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (delete_action) in
            //call delete current flashcard function out
            if self.flashcards.count != 1{
                self.deleteCurrentFlashcard()
            }
            
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}


