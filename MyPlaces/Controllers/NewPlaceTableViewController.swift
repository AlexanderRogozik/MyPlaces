//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/23/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeNameLabel: UITextField!
    @IBOutlet weak var locationPlaceLabal: UITextField!
    @IBOutlet weak var typePlaceLabel: UITextField!
    
    @IBOutlet weak var ratingControl: RatingControl!
    var currentPlace : Place!
    var imageIsChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        saveButton.isEnabled = false
        placeNameLabel.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        setupEditSceen()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func createAlertController() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        let actionSheetAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAlertAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            //TODO: - chooseImagePicker
            self.chooseImagePicker(source: .camera)
        }
        cameraAlertAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        cameraAlertAction.setValue(cameraIcon, forKey: "image")
        let photoAlertAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            //TODO: - chooseImagePicker
            self.chooseImagePicker(source: .photoLibrary)
        }
        photoAlertAction.setValue(photoIcon, forKey: "image")
        photoAlertAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetAlert.addAction(cameraAlertAction)
        actionSheetAlert.addAction(photoAlertAction)
        actionSheetAlert.addAction(cancelAlertAction)
        present(actionSheetAlert, animated: true)
    }

    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            createAlertController()
        }else{
            view.endEditing(true)
        }
    }
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifire = segue.identifier, let mapVC = segue.destination as? MapViewController else {
            return
        }
        mapVC.mapViewControllerDelegate = self
        mapVC.incomeSegueIndentifire = identifire
        if identifire == "showPlace"{
            mapVC.place.name = placeNameLabel.text!
            mapVC.place.location = locationPlaceLabal.text
            mapVC.place.type = typePlaceLabel.text
            mapVC.place.imageDataq = imageVIew.image?.pngData()
        }
        
    }

}

//MARK TextFieldDelegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    // Hide Keybord
    
    @objc private func textFieldChange() {
        if placeNameLabel.text?.isEmpty == false {
            saveButton.isEnabled = true
        }else {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func savePlace() {
        
        let image = imageIsChange ? imageVIew.image : #imageLiteral(resourceName: "imagePlaceholder")

        let imageData = image?.pngData()
    
        let newPlace = Place(name: placeNameLabel.text!, location: locationPlaceLabal.text, type: typePlaceLabel.text, imageDataq: imageData, rating: Double(ratingControl.rating))
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageDataq = newPlace.imageDataq
                currentPlace?.rating = newPlace.rating
            }
        }else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    
}


//MARK: - ImagePicker

extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageVIew.image = info[.editedImage] as? UIImage
        imageVIew.contentMode = .scaleAspectFill
        imageVIew.clipsToBounds = true
        
        imageIsChange = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func chooseImagePicker(source : UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    
    private func setupEditSceen() {
        
        if currentPlace != nil {
            imageIsChange = true
            guard let data = currentPlace?.imageDataq, let image = UIImage(data: data) else {return}
            imageVIew.image = image
            imageVIew.contentMode = .scaleAspectFill
            placeNameLabel.text = currentPlace?.name
            locationPlaceLabal.text = currentPlace?.location
            typePlaceLabel.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
            self.setupNavBar()
        }
    }
    
    private func setupNavBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
}
extension NewPlaceTableViewController : MapViewControllerDelegate {
    func getAddress(_ address: String?) {
        locationPlaceLabal.text = address
    }
    
    
}
