//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/23/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var type : String
    var image : String
    
   static let arrayPlaces = ["Балкан Гриль","Бочка","Вкусные истории","Дастархан","Индокитай","Классик","Шок"]
    
   static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in arrayPlaces {
            places.append(Place(name: place, location: "Minsk", type: "Ресторан", image: place))
        }
        return places
    }
}
