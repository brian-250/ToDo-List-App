//
//  ViewController.swift
//  ToDo App
//
//  Created by csuftitan on 10/30/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        // setup initial saving mechanism
        if !UserDefaults().bool(forKey: "setup") {
            // setup initial default (by default we have zero tasks)
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }

        
        // Get all current saved tasks
        updateTasks()
    }
    
    // We recreate task array
    func updateTasks() {
        
        // Before we update, removes all the elements in tasks array to not showe duplicates
        tasks.removeAll()
        
        // Get count
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        // For loop to interate through zero up until count(inclusive of count)-we are going to get each of our tasks and add it to our tasks array
        for x in 0..<count {
            
            // Add tasks to tasks array
            // we start at zero, we never actually use zero because we add one to it every time we add
            // if this task we pull out isn't empty, we are going to add it to our tasks array
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                tasks.append(task)
            }
        }
        // We also want to reload out table view
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        // We want to call this function in this class
        vc.update = {
            // We want to make sure that we prioritize updating the actual tasks (by calling the updateTasks function)
            DispatchQueue.main.async {
                self.updateTasks()
            }
                
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}




extension ViewController: UITableViewDelegate {
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
}
