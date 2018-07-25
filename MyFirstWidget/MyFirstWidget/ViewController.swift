//
//  ViewController.swift
//  MyFirstWidget
//
//  Created by Aliona on 25/07/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let taskService = TaskService()

    @IBOutlet weak var textField: UITextField!

    @IBAction func addTask(_ sender: Any) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        taskService.addTask(with: text)
        textField.text = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

