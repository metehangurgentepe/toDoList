//
//  AddToDoViewModel.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import Foundation

class AddToDoViewModel: NSObject {
    private var reminderService: ReminderServiceProtocol
    
    var successSaving: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    var showReminder: ((Reminder) -> Void)?
    var selectedId: String?
    
    init(reminderService: ReminderServiceProtocol = ReminderService()) {
        self.reminderService = reminderService
    }
    
    func saveReminder(reminder: Reminder) {
        if reminder.title.isEmpty {
            self.showError?("Title should not be empty")
        } else {
            reminderService.saveReminders(reminder: Reminder(id: selectedId ?? "", title: reminder.title, date: reminder.date, notes: reminder.notes)) { success, error in
                if success {
                    self.successSaving?(success)
                }
                
                if let error = error {
                    self.showError?(error.localizedDescription)
                    self.successSaving?(false)
                }
            }
        }
    }
    
    func getReminder(id:String) {
        selectedId = id
        reminderService.getRemindersByID(id: id) { success, reminder, error in
            if let error = error {
                self.showError?(error.localizedDescription)
                self.successSaving?(false)
            } else {
                if let reminder = reminder {
                    self.showReminder?(reminder)
                }
            }
        }
    }
}
