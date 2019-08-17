//
//  TaskListViewController.swift
//  RxSwiftLearning
//
//  Created by Joao Paulo Aquino on 17/08/19.
//  Copyright © 2019 Joao Paulo Aquino. All rights reserved.
//

import UIKit
import RxSwift

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addTVC = navC.viewControllers.first as? AddTaskViewController else {
            return
        }
        addTVC.taskSubjectObservable.subscribe(onNext: { task in
            print(task)
            }).disposed(by: bag)
        
    }


}
