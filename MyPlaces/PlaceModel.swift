//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/23/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type : String?
    @objc dynamic var imageDataq : Data?
    
    convenience init(name : String, location: String?, type: String?, imageDataq : Data?){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageDataq = imageDataq
    }
}
