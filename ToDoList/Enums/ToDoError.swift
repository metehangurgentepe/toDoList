//
//  ToDoError.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import Foundation


enum UserDefaultsError: Error {
    case jsonDecodeError
    case jsonEncodeError
    case invalidKey
}

extension UserDefaultsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .jsonDecodeError:
            return NSLocalizedString("Unable to decode to data", comment: "")
        case .jsonEncodeError:
            return NSLocalizedString("Unable to encode to data", comment: "")
        case .invalidKey:
            return NSLocalizedString("Invalid key", comment: "")
        }
    }
}
