//
//  AddCourse.swift
//  CoursesTrial
//
//  Created by Barry Chew on 28/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//



import Foundation
import UIKit
import CoreData

class AddTermVC: UIViewController, UITextViewDelegate {
    
    var selectedCourse: Course!
    
    @IBOutlet weak var termLabel: UITextField!
    @IBOutlet weak var definitionView: UITextView!
    
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        let termName = termLabel.text
        let definition = definitionView.text
        
        if termName != "" && definition != "" {
            
        if let moc = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            if let term = NSEntityDescription.insertNewObjectForEntityForName("Term", inManagedObjectContext: moc) as? Term {
                
                term.course = selectedCourse
                term.name = termName
                term.definition = definition
                
                moc.performBlock{
                    do {
                        try moc.save()
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                }
                
            }}
            
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
        definitionView.text = "Write a definition for your term"
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


 