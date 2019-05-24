//
//  ViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/22/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var places : Results<Place>!
    
    @IBAction func unwidSegue(_ segue : UIStoryboardSegue) {
        guard  let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
        newPlaceVC.saveNewPlace()
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    
}
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        cell.placeImageView.image = UIImage(data: place.imageDataq!)
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
//            self.array.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
        
        let place = places[indexPath.row]
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
