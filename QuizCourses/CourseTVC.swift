//
//  GlobalTVC.swift
//  CoursesTrial
//
//  Created by Barry Chew on 27/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit
import CoreData

class CourseTVC: CoreDataTVC {
    
    // didSet is used to respond to changes and automatically replace the get method once new set is activated
    
    var moc: NSManagedObjectContext! =
        (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    private func updateUI() {
        let context = moc
        let request = NSFetchRequest(entityName: "Course")
        let subjectSort = NSSortDescriptor(key: "subject", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        let coursenameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        
        request.sortDescriptors = [subjectSort, coursenameSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "subject", cacheName: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    var selectedCourse: NSManagedObject!
    
    //Swipe Row Actions
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var courseName: String?
        
        
        if let course = fetchedResultsController?.objectAtIndexPath(indexPath) as? Course {
            moc.performBlockAndWait({
                courseName = course.name!
                self.selectedCourse = course
            })}
        
        let shareAction = UITableViewRowAction(style: .Default, title: "Share", handler: { (action, indexPath) -> Void in
            let defaultText = "Check out the new course released! \(courseName)"
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
            
        })
        
        let editAction = UITableViewRowAction(style: .Default, title: "Edit", handler: { (action, indexPath) -> Void in
            self.performSegueWithIdentifier("showEdit", sender: indexPath)
        })
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) -> Void in
            self.moc.deleteObject(self.selectedCourse)
            
            do {
                try self.moc.save()
                
            } catch let error as NSError {
                print("Error: \(error)")
            }
            
        })
        
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        editAction.backgroundColor = UIColor(red: 246.0/255, green: 178.0/255, blue: 107.0/255, alpha: 1.0)
        
        return [shareAction, editAction, deleteAction]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let course = fetchedResultsController?.objectAtIndexPath(indexPath) as? Course {
            var courseName: String!
            var curator: String!
            
            moc.performBlockAndWait {
                // it's easy to forget to do this on the proper queue
                curator = course.curator
                courseName = course.name
                // we're not assuming the context is a main queue context
                // so we'll grab the screenName and return to the main queue
                // to do the cell.textLabel?.text setting
            }
            
            cell.textLabel!.text = courseName
            cell.detailTextLabel!.text = curator
            
            
        }
        return cell
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        let sourceViewController = segue.sourceViewController
        
        switch sourceViewController {
        case is AddCourseVC:
            if let moc = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                moc.performBlock{
                    do {
                        try moc.save()
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }}
            }
            /*
             case is AddTermViewController:
             if let moc = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
             
             
             do {
             try moc.save()
             } catch let error as NSError {
             print("Error: \(error)")
             }
             }
             
             */
            
        default:
            break
        }
        
    }
    
    
    @IBAction func unwindToGlobalTVC(segue:UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showCourse":
                if let indexPath = tableView.indexPathForSelectedRow{
                    let dc = segue.destinationViewController.contentViewController as! TermTVC
                    if let selectedCourse = fetchedResultsController?.objectAtIndexPath(indexPath) as? Course {
                        print(selectedCourse.name!)
                        dc.selectedCourse = selectedCourse
                    }
                    
                }
            default:
                break
            }
            
        }
    }
}
