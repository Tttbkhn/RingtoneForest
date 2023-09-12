//
//  ProductStoreCacheCd.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation
import CoreData

class ProductStoreCacheCD {
    static let shared = ProductStoreCacheCD()
    
    func saveCachePurchase(package: Package, premiumType: EPremium) {
        let purchaseFetch: NSFetchRequest<ProductStore> = ProductStore.fetchRequest()
        
        let managedContext = AppDelegate.instance.productCoreDataStack.managedContext
        let cachePurchase: ProductStore!
        
        do {
            let purchaseCache = try managedContext.fetch(purchaseFetch)
            if purchaseCache.count > 0 {
                cachePurchase = purchaseCache.first!
            } else {
                cachePurchase = ProductStore(context: managedContext)
            }
            
            cachePurchase.name = package.name
            cachePurchase.id = package.productID
            cachePurchase.dateBuy = Calendar.current.dateComponents(in: .current, from: Date()).date
            switch premiumType {
            case .week:
                cachePurchase.dateExpired = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            case .month:
                cachePurchase.dateExpired = Calendar.current.date(byAdding: .day, value: 30, to: Date())
            case .year:
                cachePurchase.dateExpired = Calendar.current.date(byAdding: .day, value: 365, to: Date())
            }
            
            UserDefaults.standard.setValue(true, forKey: Constant.isPurchased)
            AppDelegate.instance.productCoreDataStack.saveContext()
        } catch _ as NSError {
            UserDefaults.standard.setValue(false, forKey: Constant.isPurchased)
        }
    }
    
    func restorePurchase(package: Package, dateExpired: Date) {
        let purchaseFetch: NSFetchRequest<ProductStore> = ProductStore.fetchRequest()
        
        let managedContext = AppDelegate.instance.productCoreDataStack.managedContext
        
        do {
            let purchaseCache = try managedContext.fetch(purchaseFetch)
            if purchaseCache.count > 0 {
                let cachePurchase = purchaseCache.first!
                
                cachePurchase.name = package.name
                cachePurchase.id = package.productID
                cachePurchase.dateBuy = Calendar.current.dateComponents(in: .current, from: Date()).date
                
                switch package.productID {
                case Constant.packages[0].productID:
                    cachePurchase.dateExpired = dateExpired.adding(.day, value: 7)
                case Constant.packages[1].productID:
                    cachePurchase.dateExpired = dateExpired.adding(.day, value: 30)
                case Constant.packages[2].productID:
                    cachePurchase.dateExpired = dateExpired.adding(.day, value: 365)
                default: break
                }
                
                UserDefaults.standard.setValue(true, forKey: Constant.isPurchased)
                AppDelegate.instance.productCoreDataStack.saveContext()
            }
        } catch _ as NSError {
            UserDefaults.standard.setValue(false, forKey: Constant.isPurchased)
        }
    }
    
    func getPurchased() -> ProductStore? {
        let purchaseFetch: NSFetchRequest<ProductStore> = ProductStore.fetchRequest()
        let managedContext = AppDelegate.instance.productCoreDataStack.managedContext
        
        do {
            let purchaseCache = try managedContext.fetch(purchaseFetch)
            if purchaseCache.count > 0 {
                return purchaseCache.first!
            } else {
                return nil
            }
        } catch _ as NSError {
            UserDefaults.standard.setValue(false, forKey: Constant.isPurchased)
            return nil
        }
    }
    
    func removeProductExpired() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductStore")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let managedContext = AppDelegate.instance.productCoreDataStack.managedContext
        
        do {
            try managedContext.execute(batchDeleteRequest)
            AppDelegate.instance.productCoreDataStack.saveContext()
        } catch {
            print("Delete purchase error: \(error)")
        }
    }
}
