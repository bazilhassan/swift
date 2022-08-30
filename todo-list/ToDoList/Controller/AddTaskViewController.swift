//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Hassan Qureshi on 8/27/22.
//

import UIKit

protocol AddTask: AnyObject {
    func addTaskIntoList(title: String)
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    
    weak var delegate: AddTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Task"
    }
    
    @IBAction func addTaskBtnTapped(_ sender: UIButton) {
        if taskTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty == true {
            print("Task is empty")
        } else {
            self.navigationController?.popViewController(animated: true, completion: {
                [weak self] in
                self?.delegate?.addTaskIntoList(title: (self?.taskTextField.text!)!)
            })
        }
    }
    
}
