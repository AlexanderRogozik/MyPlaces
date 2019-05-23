//
//  ViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/22/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let places = Place.getPlaces()
    
    @IBAction func cancelAction(_segue : UIStoryboardSegue) {}
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    
}
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        cell.nameLabel.text = places[indexPath.row].name
        cell.placeImageView.image = UIImage(named: places[indexPath.row].image)
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
//            self.array.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
//            self.array.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        return [share, delete]
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
