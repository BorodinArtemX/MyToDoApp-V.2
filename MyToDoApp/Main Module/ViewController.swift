// ViewController.swift


import UIKit
import CoreData

final class ViewController: UIViewController {
    var context: NSManagedObjectContext!
    private var viewModel: MainViewModelProtocol!
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        TableViewCell.registerWithTableView(tableView: tableView)
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = MainViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To Do"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
        style: .plain, target: self, action: #selector(deleteAllTasks))
        let leftA = navigationItem.leftBarButtonItem
        leftA?.tintColor = .black
        let rightA = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addNewTask))
        let rightB = UIBarButtonItem(image: .actions, style: .plain, target: .none, action: .none)
        rightB.tintColor = .black
        rightA.tintColor = .black
        navigationItem.rightBarButtonItems = [rightA, rightB]
        view.addSubview(mainTableView)
    }

    @objc private func deleteAllTasks() {
        let alert = UIAlertController(title: "Delete All Task's?", message: .none, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .destructive){ _ in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoTask")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.context?.execute(deleteRequest)
            } catch {
                print(error.localizedDescription)
            }
            self.viewModel.tasks.removeAll()
            self.mainTableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @objc private func addNewTask() {
        let alert = UIAlertController(title: "Task", message: "Enter new task", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text else { return }
            self?.saveTask(title)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    @objc private func didTapOnButton() {
    let randomVC = UIViewController()
    randomVC.view.backgroundColor = .white
    navigationController?.pushViewController(randomVC, animated: true )
    }

    private func saveTask(_ title: String) {
        let task = ToDoTask(context: context!)
        task.title = title
        task.date = Date()
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
        viewModel.tasks.insert(task, at: 0)
        mainTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    private func deleteTask(at index: IndexPath) {
        context?.delete(viewModel.tasks[index.row])
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
        //viewModel.tasks.remove(at: index.row)
       // mainTableView.deleteRows(at: [index], with: .automatic)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainTableViewCell = TableViewCell.getReusedCellFrom(tableView: tableView, cellForItemAt: indexPath)
        mainTableViewCell.selectionStyle = .none
        mainTableViewCell.setup(with: viewModel.tasks[indexPath.row])
        mainTableViewCell.onComplete = { [weak self] in
            self?.deleteTask(at: indexPath)
        }
        return mainTableViewCell
    }
}

