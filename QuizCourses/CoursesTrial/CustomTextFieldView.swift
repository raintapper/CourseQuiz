//
//  ViewController.swift
//  CgrectQuiz
//
//  Created by Barry Chew on 19/7/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit



/*
 
 
 (A) Break it down to 2 helpers
 (1) UITextField Generator
 (2) ScoreCheck Brain
 (B) UIViewControllers only responsible in gathering the CoreData and Presenting the Views
 
 */



class CustomTextFieldView: UIView, UITextFieldDelegate {
    
    var myTextField: UITextField!
    
    
    /*
     func textField(myTextField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
     guard let text = myTextField.text else { return true }
     
     let newLength = text.characters.count + string.characters.count - range.length
     return newLength <= 1 // Bool
     }
     */
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = UIColor.lightGrayColor()
        currentPos = textField.tag
        submittedAnswers(textField.text!)
        print(currentPos)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.backgroundColor = UIColor.orangeColor()
    }
    
    
    let word = "Tell momma i love her and tell daddy i miss him!"
    
    
    // This is a delegate method from UITextFieldDelegate
    // Returns bool -> TRUE if the specified text range should be replaced; otherwise, FALSE to keep the old text.
    
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // limit to 1 characters
        let characterCountLimit = 1
        
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        return newLength <= characterCountLimit
    }
    
    var currentPos: Int!
    
    // I still dont know how getSet method works!
    var activePos: Int {
        get {
            return currentPos + 1
        }
        set {
            
        }
    }
    
    func didSelectBox(){
        box[0].becomeFirstResponder()
    }
    
    func textFieldDidChange(){
        
        if currentPos < myTextField.tag {
            if box[currentPos].text?.characters.count >= 1 {
                box[currentPos].resignFirstResponder()
                box[activePos].becomeFirstResponder()
            }
        } else {
            print("final position reached")
        }
    }
    
    
    
    func letterBox(x: Double, y: Double, w: Double, h: Double, tag: Int) -> UITextField {
        
        let textFrame = CGRect(x: x, y: y, width: w, height: h)
        myTextField = UITextField(frame: textFrame)
        myTextField.textAlignment = NSTextAlignment.Center
        myTextField.tintColor = UIColor.clearColor()
        myTextField.backgroundColor = UIColor.orangeColor()
        myTextField.placeholder = "?"
        // Adding action to UITextField, which responds to changes when there Editing Changed
        myTextField.addTarget(self, action: #selector(CustomTextFieldView.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        myTextField.layer.cornerRadius = 5.0
        myTextField.delegate = self
        myTextField.tag = tag
        
        
        //textField(myTextField, shouldChangeTextInRange: <#T##NSRange#>, replacementText: <#T##String#>)
        return myTextField
    }
    
    var box : [UITextField] = []
    
    func generatingBox(word:String){
        let xBoundary = 300.0
        let width = 30.0
        let height = 40.0
        var xSum = 0.0
        var x = 0.0
        var y = 60.0
        var tag = 0
        
        for chars in word.characters {
            if chars == " " {
                x += 10.0
                xSum += 10.0
            } else {
                // row width should be less than 350px
                if xSum < xBoundary {
                    x += width + 1.0
                    box.append(letterBox(x, y: y, w: width, h: height, tag: tag))
                    xSum += width + 1.0
                    tag += 1
                    
                    
                } else {
                    // reset x position
                    x = 40.0
                    xSum = 0
                    y += height + 20.0
                    box.append(letterBox(x, y: y, w: width, h: height, tag: tag))
                    tag += 1
                    xSum += x
                    
                }
            }
        }
        
    }
    
    func clearBox(){
        box.removeAll()
        print(box)
    }
    
    var submittedAnswer = [String]()
    
    func submittedAnswers(boxText: String){
        for chars in boxText.characters{
            submittedAnswer.append("\(chars)")
        }
    }
    
    
    
    
    
}