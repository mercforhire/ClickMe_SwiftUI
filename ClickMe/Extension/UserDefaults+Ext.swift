//
//  UserDefaults+Ext.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-14.
//

import Foundation

extension UserDefaults {
    func resetDefaults() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach({
            self.removeObject(forKey: $0)
        })
    }
}
