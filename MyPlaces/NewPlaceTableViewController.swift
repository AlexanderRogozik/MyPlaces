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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
   

}

//MARK TextFieldDelegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    // Hide Keybord
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - ImagePicker

extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageVIew.image = info[.editedImage] as? UIImage
        imageVIew.contentMode = .scaleAspectFill
        imageVIew.clipsToBounds = true
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
}
