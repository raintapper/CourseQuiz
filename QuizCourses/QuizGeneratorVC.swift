//
//  StartViewController.swift
//  QuizFlow
//
//  Created by Barry Chew on 20/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit
import CoreData

class QuizGeneratorVC: UIViewController {
    
    var terms: String = ""
    var definition: String = ""
    var defineCount = 0
    var totalQuestions = 0
    var courseTerms: [Term]!
    var moc: NSManagedObjectContext! =
        (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    
    // List of unique numbers
    var listOfUniqueNumbers: [Int] = []
    // List of unique question terms based on the unique numbers
    var questionTerms: [Term] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveTerms()
        //initial conditions
        generateRandomNumbers(questionTerms, totalQuestions: 5)
    }
    
    private func retrieveTerms() {
        
        
        let request = NSFetchRequest(entityName: "Term")
        let scoreSort = NSSortDescriptor(key: "score", ascending: true)
        
        request.sortDescriptors = [scoreSort]
        
        moc.performBlockAndWait({
            if let term = try? self.moc.executeFetchRequest(request) as! [Term] {
                self.courseTerms = term
                self.defineCount = term.count
            }
        })
    }
    
    
    //after fetching from core data
    
    
    
    
    
    func alertController(defineCount: Int, totalQuestions: Int){
        
        let minimumQuestions = totalQuestions * 2
        
        let alertController = UIAlertController(title: "Oops", message: "We can't proceed, please add more than \(minimumQuestions) terms in the glossary for test!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        if defineCount >= 10 {
            performSegueWithIdentifier("showQuestions", sender: UIButton())
            
        } else {
            alertController(Int(defineCount), totalQuestions: totalQuestions)
        }
    }
    
    
    
    @IBOutlet weak var numberOfQuestionLabel: UISegmentedControl!
    @IBAction func numberOfQuestion(sender: UISegmentedControl) {
        
        // Mark - Need to get the segmentIndexNumber to bounce back to option 5 if it overselects*
        
        // need to declare self to store the variable totalQuestions?
        
        totalQuestions = Int(numberOfQuestionLabel.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)!
        
        if Int(defineCount)/totalQuestions < 2
        {
            alertController(Int(defineCount), totalQuestions: totalQuestions)
            
        } else {
            generateRandomNumbers(questionTerms, totalQuestions: totalQuestions)
        }
    }
    
    //number of questions in Core Data
    
    
    // MARK: - Generating Questions
    
    
    
    func generateRandomNumbers(terms:[Term], totalQuestions: Int){
        
        //resets listsOfUniqueNumbers whenever generateRandomNumbers is called
        listOfUniqueNumbers = []
        let difficultQuestions = totalQuestions/2
        let mediumQuestions = totalQuestions/3
        let easyQuestions = totalQuestions - mediumQuestions - difficultQuestions
        
        let difficult = UInt32(defineCount/3)
        let medium = UInt32(defineCount/2)
        let easy = UInt32(defineCount)
        var i = 0
        var k = 0
        
        while i < difficultQuestions {
            var randomNumber = Int(arc4random_uniform(difficult))
            
            while k < listOfUniqueNumbers.count{
                
                if randomNumber == listOfUniqueNumbers[k]{
                    
                    randomNumber = Int(arc4random_uniform(difficult))
                    k = -1
                }
                k += 1
            }
            listOfUniqueNumbers.append(randomNumber)
            print(listOfUniqueNumbers)
            i += 1
            k = 0
        }
        
        // reset counter
        i = 0
        
        while i < mediumQuestions {
            var randomNumber = Int(arc4random_uniform(medium))
            
            while k < listOfUniqueNumbers.count{
                
                if randomNumber == listOfUniqueNumbers[k]{
                    
                    randomNumber = Int(arc4random_uniform(medium))
                    k = -1
                }
                k += 1
            }
            listOfUniqueNumbers.append(randomNumber)
            print(listOfUniqueNumbers)
            i += 1
            k = 0
        }
        
        // reset counter
        i = 0
        
        //so far this is the correct one we need to test!
        while i < easyQuestions {
            var randomNumber = Int(arc4random_uniform(easy))
            
            while k < listOfUniqueNumbers.count{
                
                if randomNumber == listOfUniqueNumbers[k]{
                    
                    randomNumber = Int(arc4random_uniform(easy))
                    k = -1
                }
                k += 1
            }
            listOfUniqueNumbers.append(randomNumber)
            print(listOfUniqueNumbers)
            i += 1
            k = 0
        }
    }
    
    
    
    // Appending new QuestionTerms array with Randomly generated courseTerms
    
    
    private func generateUniqueQuestions(listOfUniqueNumbers: [Int]) -> [Term]{
        for i in 0...listOfUniqueNumbers.count-1{
            questionTerms.append(courseTerms[(listOfUniqueNumbers[i])])
        }

        return questionTerms
    }
    
    
    
    // MARK: - Navigation
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showQuestions" {
            let vc = segue.destinationViewController as! QuizVC
            generateUniqueQuestions(listOfUniqueNumbers)
            vc.moc = moc
            vc.questions = questionTerms
            vc.numberOfQuestions = questionTerms.count
            
        }
    }
    
    
    
}
