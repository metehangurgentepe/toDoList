//
//  ReminderService.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 29.08.2024.
//

import Foundation

protocol ReminderServiceProtocol {
    func getReminders(completion: @escaping (_ success: Bool, _ results: [Reminder]?, _ error: UserDefaultsError?) -> ())
    func saveReminders(reminder: Reminder, completion: @escaping (_ success: Bool, _ error: UserDefaultsError?) -> ())
    func getRemindersByID(id: String, completion: @escaping (Bool, Reminder?, UserDefaultsError?) -> ())
    func deleteReminder(_ id: String, completion: @escaping (Bool, UserDefaultsError?) -> ())
}

class ReminderService: ReminderServiceProtocol {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let key = "Reminder"
    let defaults = UserDefaults.standard
    
    func getReminders(completion: @escaping (Bool, [Reminder]?, UserDefaultsError?) -> ()) {
        if let reminders = defaults.object(forKey: key) as? Data {
            do{
               let remindersArr = try decoder.decode([Reminder].self, from: reminders)
                completion(true, remindersArr, nil)
            } catch {
                completion(false,nil,.jsonDecodeError)
            }
        }
    }
    
    func saveReminders(reminder: Reminder, completion: @escaping (Bool, UserDefaultsError?) -> ()) {
        
        if let reminders = defaults.object(forKey: key) as? Data {
            do {
                var remindersArr = try decoder.decode([Reminder].self, from: reminders)
                
                if let index = remindersArr.firstIndex(where: { $0.id == reminder.id }) {
                    remindersArr[index] = reminder
                } else {
                    remindersArr.append(reminder)
                }
                
                let encodedData = try encoder.encode(remindersArr)
                defaults.setValue(encodedData, forKey: key)
                completion(true, nil)
            } catch {
                completion(false, .jsonDecodeError)
            }

        } else {
            do {
                let arr = [reminder]
                let encodedData = try encoder.encode(arr)
                defaults.setValue(encodedData, forKey: key)
                completion(true,nil)
            } catch {
                completion(false, .jsonEncodeError)
            }
        }
    }
    
    func getRemindersByID(id: String, completion: @escaping (Bool, Reminder?, UserDefaultsError?) -> ()) {
        if let reminders = defaults.object(forKey: key) as? Data {
            do {
                let remindersArr = try decoder.decode([Reminder].self, from: reminders)
                if let reminder = remindersArr.first(where: { $0.id == id }) {
                    completion(true, reminder, nil)
                } else {
                    completion(false, nil, .jsonDecodeError)
                }
            } catch {
                completion(false, nil, .jsonDecodeError)
            }
        }
    }
    
    func deleteReminder(_ id: String, completion: @escaping (Bool, UserDefaultsError?) -> ()) {
        if let reminders = defaults.object(forKey: key) as? Data {
            do {
                var remindersArr = try decoder.decode([Reminder].self, from: reminders)
                remindersArr.removeAll { $0.id == id }
                let encodedData = try encoder.encode(remindersArr)
                defaults.setValue(encodedData, forKey: key)
                completion(true,nil)
            } catch {
                completion(false,.jsonDecodeError)
            }
        }
    }
}
