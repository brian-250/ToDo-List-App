//
//  EntryViewController.swift
//  ToDo App
//
//  Created by csuftitan on 10/30/23.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    // 
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }
    
    @objc func saveTask() {
        
        // Checking to see if the field if NOT empty
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        // Guarding against count being "nil" or empty or nothing
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        // Increment counter by 1 to say that we have more things in our tasks
        let newCount = count + 1
        
        // Set new count again
        UserDefaults().set(newCount, forKey: "count")
        // Save our tasks by calling 'text', saving our new count
        // each time we save this new task, it will be unique
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        // if this update function exists, lets call it
        update?()
        
        // Once we called update, lets dismiss this viewcontroller
        navigationController?.popViewController(animated: true)
    }

}
