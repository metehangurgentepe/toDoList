//
//  Reminder.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import Foundation


struct Reminder: Codable {
    var id: String?
    var title: String
    var date: Date?
    var notes: String?
    
    init(id: String? = nil, title: String, date: Date? = nil, notes: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.date = date
        self.notes = notes
    }
}
