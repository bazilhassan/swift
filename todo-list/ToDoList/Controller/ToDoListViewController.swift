//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Hassan Qureshi on 8/27/22.
//

import UIKit
import Foundation

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListApp: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.emptyListLabel.isHidden = !CoredataService.shared.fetchTask().isEmpty
    }
    
    private func setupUI() {
        self.toDoListApp.delegate = self
        self.toDoListApp.dataSource = self
        self.btnAdd.layer.cornerRadius = self.btnAdd.frame.height / 2
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main",
                              bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoredataService.shared.fetchTask().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.toDoListApp.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.populateData(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = CoredataService.shared.fetchTask()[indexPath.row]
        task.isCompleted = !task.isCompleted
        CoredataService.shared.updateData(task: task)
        self.toDoListApp.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
            CoredataService.shared.deleteData(id: CoredataService.shared.fetchTask()[indexPath.row].id)
            self.toDoListApp.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ToDoListViewController: AddTask {
    func addTaskIntoList(title: String) {
        let task = Task(title: title, isCompleted: false, id: UUID().uuidString)
        CoredataService.shared.saveTask(myTask: task)
        self.emptyListLabel.isHidden = !CoredataService.shared.fetchTask().isEmpty
        self.toDoListApp.reloadData()
    }
}

extension UINavigationController {
    func popViewController(
        animated: Bool,
        completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
