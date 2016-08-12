//
//  ViewTermVC.swift
//  CoursesTrial
//
//  Created by Barry Chew on 10/8/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit
import CoreData


class ViewDetailTermVC: UIViewController {
    
    var question: Term!
    var moc: NSManagedObjectContext!
    var name: String!
    var definition: String!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    @IBAction func backButton(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = "\(name)"
    }
    
    @IBOutlet weak var nameLabel: UITextField! {
        didSet {
            nameLabel.text = question.name
        }
    }
    @IBOutlet weak var definitionLabel: UITextView! {
        didSet {
            definitionLabel.text = question.definition
        }
    }
    
    @IBAction func editTermButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editTermVC", sender: self)
    }

    
    
    @IBAction func unwindToDetailTermVC(segue:UIStoryboardSegue) {
    }
    
    
    @IBAction func closeFromEdit(segue:UIStoryboardSegue) {
        let sourceViewController = segue.sourceViewController
        switch sourceViewController {
        case is EditTermVC:
            if let moc = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                moc.performBlock{
                    do {
                        try moc.save()
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                }
            }
            
        default:
            break
        }
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        
        if identifier == "editTermVC" {
            let dc = segue.destinationViewController.contentViewController as! EditTermVC
            dc.question = question
            dc.name = name
            dc.definition = definition
            dc.moc = moc
        }
    }
}
