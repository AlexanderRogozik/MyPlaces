//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/24/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class  StorageManager {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place : Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
