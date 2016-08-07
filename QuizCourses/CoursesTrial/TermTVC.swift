//
//  CourseTVC.swift
//  CoursesTrial
//
//  Created by Barry Chew on 28/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//
//

import UIKit
import CoreData

class TermTVC: CoreDataTVC {
    
    var selectedCourse: Course!
    var moc: NSManagedObjectContext! =
        (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var searchController: UISearchController!
    
    private func updateUI(){
        
        let context = moc
        let request = NSFetchRequest(entityName: "Term")
        let filter = NSPredicate(format: "course.name == %@", selectedCourse.name! )
        
        let courseSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector (NSString.localizedCaseInsensitiveCompare(_:)))
        let scoreSort = NSSortDescriptor(key: "score", ascending: true)
        
        request.sortDescriptors = [courseSort, scoreSort]
        request.predicate = filter
        
        // didSet at work!
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    @IBAction func testButton(sender: UIBarButtonItem) {
        
    }
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        navigationBar.title = selectedCourse.name
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        if let term = fetchedResultsController?.objectAtIndexPath(indexPath) as? Term {
            
            var termName: String?
            var definition: String?
            
            moc.performBlockAndWait {
                definition = term.definition
                termName = term.name
                
            }
            
            cell.textLabel?.text = termName
            cell.detailTextLabel?.text = definition
            
            }
        return cell
    }
    
    //Swipe Row Actions
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var termName: String?
        var termObject: Term!
        
        if let term = fetchedResultsController?.objectAtIndexPath(indexPath) as? Term {
            moc.performBlockAndWait({
                termName = term.name
                termObject = term
                
                
            })}
        
        let shareAction = UITableViewRowAction(style: .Default, title: "Share", handler: { (action, indexPath) -> Void in
            let defaultText = "Check out the new course released! \(termName)"
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
            
        })
        
        let editAction = UITableViewRowAction(style: .Default, title: "Edit", handler: { (action, indexPath) -> Void in
            self.performSegueWithIdentifier("showEdit", sender: indexPath)
        })
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) -> Void in
            self.moc.deleteObject(termObject)
            
            self.moc.performBlock{
                do {
                    try self.moc.save()
                    
                } catch let error as NSError {
                    print("Error: \(error)")
                }}
            
        })
        
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        editAction.backgroundColor = UIColor(red: 246.0/255, green: 178.0/255, blue: 107.0/255, alpha: 1.0)
        
        return [shareAction, editAction, deleteAction]
    }
    
    
    @IBAction func unwindToCourseTVC(segue:UIStoryboardSegue) {
    }
    
    
    
    
    @IBAction func close(segue:UIStoryboardSegue) {
        let sourceViewController = segue.sourceViewController
        
        switch sourceViewController {
        case is AddTermVC:
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "showQuizGeneratorVC":
                break
                
            case "showAddTermVC":
                let dc = segue.destinationViewController.contentViewController as! AddTermVC
                dc.selectedCourse = selectedCourse
                print(dc.selectedCourse)
                
            default:
                break
            }
            
        }
        
        
    }
    
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
        
    }
    
}