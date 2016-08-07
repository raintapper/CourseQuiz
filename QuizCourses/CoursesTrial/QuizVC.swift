//
//  ViewController.swift
//  QuizFlow
//
//  Created by Barry Chew on 19/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit
import CoreData

class QuizVC: UIViewController {
    
    var moc: NSManagedObjectContext!
    var questions:[Term] = []
    var numberOfQuestions: Int = 0
    //var submittedAnswers: [String] = []
    var stringProcess = Process()
    var textFieldView = CustomTextFieldView()
    @IBOutlet weak var boxText: CustomTextFieldView!
    
    @IBOutlet weak var defineView: UITextView!
    
    var i = 1
    
    @IBAction func submitButton(sender: UIButton) {
        
        //submittedAnswers.append(nameInput.text!)
        // this is how you pass index WOW I AM SO COOL!
        questions[i-1].score = updateScore(textFieldView.submittedAnswer, questions: questions, index: i-1)
        
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
            //performSegueWithIdentifier("showSummary", sender: UIButton())
            
        }
        // need to have variable i to set the question name and definition
        i += 1
    }
    
    
    func updateScore(submittedAnswer:[String], questions:[Term], index: Int) -> (Int){
        let i = index
        let score = questions[i].score!.integerValue
        let questionChars = stringProcess.breakdownStringToChars(questions[i].name!)
        //let answeredChars = textFieldView.answer
        
        //if submittedAnswers[i].caseInsensitiveCompare(questions[i].name!) == NSComparisonResult.OrderedSame
        //
        
        if stringProcess.compareAndReturnBool(questionChars, answered: submittedAnswer) {
            //record if the terms were answered incorrectly
            questions[i].score = (integer: score + 1)
            print(questions[i].score)
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
            print(questions[i].score)
            
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
        boxText.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.generatingBox(questions[0].name!)
        updateUI(textFieldView.box)
        textFieldView.didSelectBox()
        defineView.text = questions[0].definition
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     if segue.identifier == "showSummary" {
     // let vc = segue.destinationViewController as! ResultsViewController
     
     }
     }*/
    
    
}
