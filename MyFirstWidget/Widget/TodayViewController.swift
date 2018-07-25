//
//  TodayViewController.swift
//  Widget
//
//  Created by Aliona on 25/07/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    private let taskService = TaskService()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var label: UILabel!

    private var tasks: [String] {
        return taskService.taskKeys
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.addGestureRecognizer(gestureRecognizer)
    }

    @objc func labelTapped() {
        guard let url = URL(string: "mywidget://") else {
            return
        }
        self.extensionContext?.open(url, completionHandler: nil)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else {
            let newHeight = CGFloat(tasks.count * 44 + 66)
            self.preferredContentSize = CGSize(width: maxSize.width,
                                               height: newHeight)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        updateAllData()
        completionHandler(NCUpdateResult.newData)
    }

    func updateAllData() {
        label.text = "Выполнено\n\(taskService.accomplishedTasksCount) / \(taskService.taskKeys.count)"
        image.image = taskService.allTasksDone ? #imageLiteral(resourceName: "achievement") : nil
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.image.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] completed in
            if completed {
                self?.image.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let currentTask = tasks[indexPath.row]
        cell.textLabel?.text = currentTask
        cell.textLabel?.textColor = .white
        let currentTaskStatus = taskService.allTasks[currentTask] ?? false
        cell.imageView?.image = currentTaskStatus ? #imageLiteral(resourceName: "done") : #imageLiteral(resourceName: "undone")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskService.complete(task: tasks[indexPath.row])
        updateAllData()
    }
}
