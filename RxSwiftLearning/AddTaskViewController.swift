//
//  AddTaskViewController.swift
//  RxSwiftLearning
//
//  Created by Joao Paulo Aquino on 17/08/19.
//  Copyright © 2019 Joao Paulo Aquino. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex), let title = textField.text else {
            return
        }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
}
    }
    



