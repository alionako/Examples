//
//  TaskService.swift
//  MyFirstWidget
//
//  Created by Aliona on 25/07/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import Foundation

private extension String {
    static let tasksKey = "tasks"
}

class TaskService {

    private let sharedDefaults = UserDefaults(suiteName: "group.com.myFirstWidget")

    var taskKeys: [String] {
        return Array(allTasks.keys)
    }

    var allTasksDone: Bool {
        return allTasks.count == accomplishedTasksCount
    }

    var accomplishedTasksCount: Int {
        let accomplished = allTasks.filter { $0.value == true }
        return accomplished.count
    }

    var allTasks: [String: Bool] {
        get {
            return sharedDefaults?.dictionary(forKey: .tasksKey) as? [String: Bool] ?? [:]
        }
        set {
            sharedDefaults?.set(newValue, forKey: .tasksKey)
        }
    }

    func complete(task: String) {
        guard allTasks[task] != nil else {
            return
        }
        var saved = allTasks
        saved[task] = true
        allTasks = saved
    }

    func addTask(with text: String) {
        var saved = allTasks
        saved[text] = false
        allTasks = saved
    }
}
