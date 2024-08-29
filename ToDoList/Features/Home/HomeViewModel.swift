//
//  HomeViewModel.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import Foundation


final class HomeViewModel: NSObject {
    var reminders = [Reminder]()
    private var reminderService: ReminderServiceProtocol
    
    var reloadTableView: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var reminderCellViewModels = [ReminderCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init(reminderService: ReminderServiceProtocol = ReminderService()) {
        self.reminderService = reminderService
    }
    
    func getReminders(){
        reminderService.getReminders { success, results, error in
            if success, let reminders = results {
                self.fetchData(reminders: reminders)
            } else if let error = error  {
                self.showError?(error.localizedDescription)
            }
        }
        
    }
    
    func fetchData(reminders: [Reminder]) {
        self.reminders = reminders
        var rms = [ReminderCellViewModel]()
        for reminder in reminders {
            rms.append(createCellModel(reminder: reminder))
        }
        reminderCellViewModels = rms
    }
    
    func createCellModel(reminder: Reminder) -> ReminderCellViewModel {
        let date = reminder.date
        let title = reminder.title
        let id = reminder.id
        
        return ReminderCellViewModel(title: title, date: date ?? Date(), id: id ?? "")
    }
    
    
    func getCellViewModel(at indexPath: IndexPath) -> ReminderCellViewModel {
        return reminderCellViewModels[indexPath.row]
    }
    
    func deleteReminder(_ reminder: ReminderCellViewModel) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders.remove(at: index)
        }
        
        reminderCellViewModels = reminderCellViewModels.filter { $0.id != reminder.id }
        
        reminderService.deleteReminder(reminder.id) { success, error in
            if let error = error {
                self.showError?(error.localizedDescription)
            }
        }
    }
    
    
}
