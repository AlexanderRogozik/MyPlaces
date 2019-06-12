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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var reversSortButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var places : Results<Place>!
    private var ascendingSorted = true
    private var filtredPlasec : Results<Place>!
    private var searchBarIsEmty : Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "watched")
        guard !wasIntroWatched else {return}
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
            present(pageVC, animated: true)
        }
    }
    
    @IBAction func unwidSegue(_ segue : UIStoryboardSegue) {
        guard  let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
        newPlaceVC.savePlace()
        
        tableView.reloadData()
    }
    
    @IBAction func sortSelectionSegmetAction(_ sender: UISegmentedControl) {
        sorting()
    }
    @IBAction func reversSortButtonPressed(_ sender: UIBarButtonItem) {
        ascendingSorted.toggle()
        
        if ascendingSorted {
            reversSortButton.image = #imageLiteral(resourceName: "AZ")
        }else{
            reversSortButton.image = #imageLiteral(resourceName: "ZA")
            
        }
        sorting()
    }
    private func sorting() {
        if segmentControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorted)
            
        }else{
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorted)
        }
        tableView.reloadData()
    }
    
    deinit {
        print("deinit", ViewController.self)
    }
}
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtredPlasec.count
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        
        let place = isFiltering ? filtredPlasec[indexPath.row] : places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.cosmosView.rating = place.rating
        cell.placeImageView.image = UIImage(data: place.imageDataq!)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let place = isFiltering ? filtredPlasec[indexPath.row] : places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredPlasec = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        
        tableView.reloadData()
    }
}
