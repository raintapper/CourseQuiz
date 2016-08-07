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

class AddCourseVC: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var subjectCategory: UITextField!
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var summaryTextField: UITextView!
    
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        let coursename = courseName.text
        let subject = subjectCategory.text
        let summary = summaryTextField.text
        
        if coursename != "" && subject != "" && summary != "" {
            
            if let moc = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                if let course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: moc) as? Course {
                    
                    course.subject = subject
                    course.name = coursename
                    course.summary = summary
                    
                    moc.performBlock{
                        do {
                            try moc.save()
                        } catch let error as NSError {
                            print("Error: \(error)")
                        }}
                    
                }}
            
            performSegueWithIdentifier("unwindToGlobalTVC", sender: self)
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
        summaryTextField.delegate = self
        summaryTextField.text = "Write a summary for your course"
        summaryTextField.textColor = UIColor.lightGrayColor()
    }

    
    // MARK: Changing the UITextField (PlaceHolder)
    
    func textViewDidBeginEditing(textView: UITextView){
        if (summaryTextField.text == "Write a summary for your course"){
            summaryTextField.text = ""
            summaryTextField.textColor = UIColor.blackColor()
            
            
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (summaryTextField.text == ""){
            summaryTextField.text = "Write a summary for your course"
            summaryTextField.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    
    
}
 