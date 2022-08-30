//
//  CoredataService.swift
//  ToDoList
//
//  Created by Hassan Qureshi on 8/27/22.
//

import Foundation
import UIKit
import CoreData

class CoredataService {
    static let shared = CoredataService()
    private var appdelegate = UIApplication.shared.delegate
    
    private init(){}
    
    //MARK: - Save Task
    func saveTask(myTask: Task) {
        guard let appdelegate = appdelegate as? AppDelegate else {
            print("App delegate nil")
            return
        }

        let managedContext = appdelegate.persistentContainer.viewContext
        let todoListEntity = NSEntityDescription.entity(forEntityName: "TodoList", in: managedContext)!
        let task = NSManagedObject(entity: todoListEntity, insertInto: managedContext)
        task.setValue(myTask.title, forKey: "title")
        task.setValue(myTask.isCompleted, forKey: "isCompleted")
        task.setValue(myTask.id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    //MARK: - Fetch Task
    func fetchTask () -> [Task] {
        guard let appdelegate = appdelegate as? AppDelegate else {
            print("App delegate nil")
            return []
        }
        
        var tasks: [Task] = []
        let managedContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as! String
                let isCompleted = data.value(forKey: "isCompleted") as! Bool
                let id = data.value(forKey: "id") as! String
                let task = Task(title: title, isCompleted: isCompleted, id: id)
                tasks.append(task)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return tasks
    }
    
    func updateData(task: Task) {
        guard let appdelegate = appdelegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(task.isCompleted, forKey: "isCompleted")
            objectUpdate.setValue(task.title, forKey: "title")

            do {
                try managedContext.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(id: String) {
        guard let appdelegate = appdelegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectDelete = test[0] as! NSManagedObject
            managedContext.delete(objectDelete)
            
            do {
                try managedContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
