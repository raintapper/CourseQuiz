//
//  QuizSummaryVC.swift
//  CoursesTrial
//
//  Created by Barry Chew on 8/8/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit
import CoreData

class QuizSummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moc: NSManagedObjectContext!
    var questions:[Term] = []
    var submittedAnswers: [[String]] = [[]]
    var stringProcess = StringProcess()

    @IBOutlet weak var quizSummaryTableView: UITableView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsLabel.text = percentageCorrect()
    }
    
    // MARK: - Compare and tabulate results
    func percentageCorrect() -> String {
        
        var percent = 0.0
        var i = 0
        var answeredCorrectly = 0.0
        
        for answer in submittedAnswers {
            if stringProcess.joinCharsToString(answer).caseInsensitiveCompare(questions[i].name!) == NSComparisonResult.OrderedSame {
                answeredCorrectly += 1
                i += 1
            } else {
                i += 1
            }
        }
 
        
        percent = answeredCorrectly / Double(questions.count) * 100
        
        return "The result is \(percent)%"
    }
    
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = quizSummaryTableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! QuizSummaryTVCell
        
        
        if stringProcess.joinCharsToString(submittedAnswers[indexPath.row]).caseInsensitiveCompare(questions[indexPath.row].name!) == NSComparisonResult.OrderedSame {
            cell.tickIndicator.isCorrect = true } else {
            cell.tickIndicator.isCorrect = false}
        
            cell.correctAnswerLabel.text = "This is the correct answer: \(questions[indexPath.row].name)"
            cell.yourAnswerLabel.text = "Your submitted answer: \(stringProcess.joinCharsToString(submittedAnswers[indexPath.row]))"
            cell.scoreLabel.text = String(questions[indexPath.row].score!)
 
        return cell
    }
    

    //MARK: - NAVIGATION
    
    @IBAction func unwindToQuizSummaryVC(segue:UIStoryboardSegue) {
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "showDetailFromQuizSummary":
                
                if let indexPath = quizSummaryTableView.indexPathForSelectedRow {
                    let dc = segue.destinationViewController.contentViewController as! ViewDetailTermVC
                        dc.question = questions[indexPath.row]
                        dc.name = questions[indexPath.row].name
                        dc.definition = questions[indexPath.row].definition
                        dc.moc = moc
                
                }
                
            default:
                break
            }
        }
    }



}
