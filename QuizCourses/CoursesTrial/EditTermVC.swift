//
//  AddCourse.swift
//  CoursesTrial
//
//  Created by Barry Chew on 28/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//



import UIKit
import CoreData

class EditTermVC: UIViewController, UITextViewDelegate {
    
    var moc: NSManagedObjectContext!
    var question: Term!
    var name: String!
    var definition: String!
    
    @IBOutlet weak var termLabel: UITextField! {
        didSet{
            termLabel.text = name
        }
    }
    
    @IBOutlet weak var definitionView: UITextView! {
        didSet{
            definitionView.text = definition
        }
    }
    
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        if name != "" && definition != "" {
            
            if let moc = moc {
                
                    question.name = termLabel.text
                    question.definition = definitionView.text
                
                    moc.performBlock{
                        do {
                            try moc.save()
                        } catch let error as NSError {
                            print("Error: \(error)")
                        }
                    }
                }
            
            performSegueWithIdentifier("unwindToCourseTVC", sender: self)
            
        } else {
            
            let alert = UIAlertController(title: "Error", message: "Please fill up all fields", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        // Load the textField
        updateUI()
        
    }
    
    private func updateUI() {
        definitionView.delegate = self
        if definitionView.text == "" {
            definitionView.text = "Write a definition for your term"
            
        } else {
            definitionView.text = definition
        }
        
        definitionView.textColor = UIColor.lightGrayColor()
    }
    
    // MARK: Changing the UITextField (PlaceHolder)
    
    func textViewDidBeginEditing(textView: UITextView){
        if (definitionView.text == "Write a definition for your term"){
            definitionView.text = ""
            definitionView.textColor = UIColor.blackColor()
            
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (definitionView.text == ""){
            definitionView.text = "Write a definition for your term"
            definitionView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
}


 