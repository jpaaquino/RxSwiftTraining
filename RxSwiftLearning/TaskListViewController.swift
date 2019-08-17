//
//  TaskListViewController.swift
//  RxSwiftLearning
//
//  Created by Joao Paulo Aquino on 17/08/19.
//  Copyright © 2019 Joao Paulo Aquino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()

    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addTVC = navC.viewControllers.first as? AddTaskViewController else {
            return
        }
        addTVC.taskSubjectObservable.subscribe(onNext: { [unowned self] task in
            
            let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
            
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            self.tasks.accept(existingTasks)
            self.filterTasks(by: priority)
            }).disposed(by: bag)
        
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
                }).disposed(by: bag)
        }
        
    }
    
    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    


}
