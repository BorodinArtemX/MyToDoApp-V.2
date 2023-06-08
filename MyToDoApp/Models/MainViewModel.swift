//
//  MainViewModel.swift
//  MyToDoApp
//
//  Created by Артем Бородин on 22/05/2023.
//

import UIKit
import CoreData

protocol MainViewModelProtocol {
    var tasks: [ToDoTask] { get set }
    func fetchData()
}

final class MainViewModel: MainViewModelProtocol {
    var tasks = [ToDoTask]()
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    init() {
        fetchData()
    }
    func fetchData() {
        let fetchRequest: NSFetchRequest<ToDoTask> = ToDoTask.fetchRequest()
        do {
            tasks = try context!.fetch(fetchRequest).reversed()
        } catch {
            print(error.localizedDescription)
        }
    }
}

