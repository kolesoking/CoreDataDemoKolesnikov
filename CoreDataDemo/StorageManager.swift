//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by катя on 23.05.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func fetchData(complition: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            complition(.success(tasks))
        } catch let error {
            complition(.failure(error))
        }
    }
    
    func save(_ taskName: String, complition: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        complition(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
