//
//  ViewController.swift
//  QuizFlow
//
//  Created by Barry Chew on 19/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit
import CoreData

class QuizVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var moc: NSManagedObjectContext!
    var questions:[Term] = []
    var numberOfQuestions: Int = 0
    var submittedAnswer: [String] = []
    var responses: [[String]] = []
    var stringProcess = StringProcess()
    var textFieldView = CustomTextFieldView()
    @IBOutlet weak var boxText: CustomTextFieldView!
    
    @IBOutlet weak var defineView: UITextView!
    
    
    var i = 1
    @IBAction func submitButton(sender: UIButton) {
        
        // submittedAnswers.append(nameInput.text!)
        // this is how you pass index WOW I AM SO Cool!
        
        submittedAnswer = stringProcess.joinTextFieldToChars(textFieldView.box)
        responses.append(submittedAnswer)
        
        questions[i-1].score = updateScore(submittedAnswer, questions: questions, index: i-1)
        
        if i < numberOfQuestions {
            defineView.text = questions[i].definition
            textFieldView.clearBox()
            updateUI(textFieldView.box)
            textFieldView.generatingBox(questions[i].name!)
            updateUI(textFieldView.box)
            defineView.reloadInputViews()
            
            
        } else {
            //reset counter
            i = 1
            performSegueWithIdentifier("showSummary", sender: UIButton())
            
        }
        // need to have variable i to set the question name and definition
        i += 1
    }
    
    //I should move this update function to summary page where the score is computed and displayed
    func updateScore(submittedAnswer:[String], questions:[Term], index: Int) -> (Int){
        let i = index
        let score = questions[i].score!.integerValue
        let questionChars = stringProcess.breakdownStringToChars(questions[i].name!)
        //let answeredChars = textFieldView.answer
        
        //if submittedAnswers[i].caseInsensitiveCompare(questions[i].name!) == NSComparisonResult.OrderedSame
        
        print(questionChars)
        print(submittedAnswer)
        print("The score before saving is: \(questions[i].score)")
        
        if stringProcess.compareAndReturnBool(questionChars, answered: submittedAnswer) {
            //record if the terms were answered incorrectly
            
            questions[i].score = (integer: score + 1)
            print("The score after saving correct is: \(questions[i].score)")
            do {
                try moc.save()
            } catch let error as NSError {
                print("errors: \(error)")
            }
        } else {
            questions[i].score = (integer: score - 1)
            do {
                try moc.save()
            } catch let error as NSError {
                print("errors: \(error)")
            }
            print("The score after saving wrong is: \(questions[i].score)")
            
        }
        return (Int(questions[i].score!))
    }
    
    private func updateUI(boxes: [UITextField]){
        
        if textFieldView.box.count == 0 {
            
            for subview in self.boxText.subviews {
                
                subview.removeFromSuperview()
                
            }
            
        } else {
            
            for box in boxes {
                boxText.addSubview(box)
            }
            textFieldView.didSelectBox()
        }
        boxText.setNeedsDisplay()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.generatingBox(questions[0].name!)
        updateUI(textFieldView.box)
        textFieldView.didSelectBox()
        defineView.text = questions[0].definition
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(QuizVC.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(QuizVC.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(aNotification:NSNotification){
        
        print("Keyboard was shown")
        
        guard let info = aNotification.userInfo else {
            print("Error: No info of notification")
            return
        }
        
        //to get the keyboard size
        guard let kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size else {
            
            print("Error: No size for keyboard")
            return
        }
        
        print("Size = \(kbSize)")
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        //print("keyboard will be hidden")
        
        let contentInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        self.view.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSummary" {
            let vc = segue.destinationViewController.contentViewController as! QuizSummaryVC
            vc.questions = questions
            vc.submittedAnswers = responses
            vc.moc = moc
        }
    }
}


