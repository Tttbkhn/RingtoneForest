//
//  ToneCacheCD.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation
import CoreData

class ToneCacheCD {
    static let shared = ToneCacheCD()
    
    func fetchTones() -> [CTone]? {
        let tonesFetch: NSFetchRequest<CTone> = CTone.fetchRequest()
        tonesFetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            let managedContext = AppDelegate.instance.toneCoreDataStack.managedContext
            let tonesCache = try managedContext.fetch(tonesFetch)
            if tonesCache.count > 0 {
                return tonesCache
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    func addNewTone(tone: MyTone) {
        let managedContext = AppDelegate.instance.toneCoreDataStack.managedContext
        let newTone = CTone(context: managedContext)
        newTone.id = tone.id
        newTone.name = tone.name
        newTone.fileName = tone.fileName
        newTone.duration = tone.duration
        newTone.timestamp = Date()
        
        AppDelegate.instance.toneCoreDataStack.saveContext()
        print("Save new tone succesfully")
    }
    
    func renameTone(tone: MyTone, newName: String, newPath: String) {
        let tonesFetch: NSFetchRequest<CTone> = CTone.fetchRequest()
        tonesFetch.predicate = NSPredicate(format: "id LIKE %@", tone.id)
        tonesFetch.fetchLimit = 1
        
        do {
            let managedContext = AppDelegate.instance.toneCoreDataStack.managedContext
            let tonesCache = try managedContext.fetch(tonesFetch)
            
            if tonesCache.count > 0 {
                let tone = tonesCache.first!
                tone.name = newName
                tone.fileName = newPath
                
                AppDelegate.instance.toneCoreDataStack.saveContext()
                print("Rename tone successfully")
            } else {
                print("No tone for this toneID \(tone.id)")
            }
        } catch let error as NSError {
            print("Rename error: \(error) description: \(error.userInfo)")
        }
    }
    
    func deleteTone(toneID: String) {
        let tonesFetch: NSFetchRequest<CTone> = CTone.fetchRequest()
        tonesFetch.predicate = NSPredicate(format: "id LIKE %@", toneID)
        tonesFetch.fetchLimit = 1
        
        do {
            let managedContext = AppDelegate.instance.toneCoreDataStack.managedContext
            let tonesCache = try managedContext.fetch(tonesFetch)
            
            if tonesCache.count > 0 {
                let tone = tonesCache.first!
                managedContext.delete(tone)
                
                AppDelegate.instance.toneCoreDataStack.saveContext()
                print("Delete tone successfully")
            } else {
                print("No tone for this toneID \(toneID)")
            }
        } catch let error as NSError {
            print("Delete error: \(error) description: \(error.userInfo)")
        }
    }
}
