//
//  TokenLDS.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation

class TokenLDS {
    func get(key: String) -> String {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: key)
        return token ?? ""
    }
    
    func cache(value: String, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func clear(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
