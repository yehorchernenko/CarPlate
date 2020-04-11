//
//  StorageService.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 01.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

protocol StorageServiceType {
    func save(carInfo: CarInfo)
    func retrieve() -> [CarInfo]
}

class StorageService: StorageServiceType {
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CarPlate")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(carInfo: CarInfo) {
        guard let data = try? JSONEncoder().encode(carInfo) else {
            print("CoreData: encoding error")
            return
        }
        let newDataObject = CarInfoData(context: context)
        newDataObject.data = data
        
        do {
            try context.save()
        } catch {
            print("CoreData: \(error)")
        }
    }
    
    func retrieve() -> [CarInfo] {
        let request = NSFetchRequest<CarInfoData>(entityName: String(describing: CarInfoData.self))
        
        do {
            let result = try context.fetch(request)
            return result.compactMap {
                guard let data = $0.data else { return nil }
                return try? JSONDecoder().decode(CarInfo.self, from: data)
            }
        } catch {
            print("CoreData: retrieving error")
            return []
        }
    }
    
    
}

struct StorageServiceKey: EnvironmentKey {
    static var defaultValue: StorageServiceType = StorageService()
}

extension EnvironmentValues {
    var storageService: StorageServiceType {
        get { self[StorageServiceKey.self] }
        set { self[StorageServiceKey.self] = newValue }
    }
}
