//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/23/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    
    func createAlertController() {
        let actionSheetAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAlertAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            //TODO: - chooseImagePicker
            self.chooseImagePicker(source: .camera)
        }
        let photoAlertAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            //TODO: - chooseImagePicker
            self.chooseImagePicker(source: .photoLibrary)
        }
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

extension NewPlaceTableViewController {
    func chooseImagePicker(source : UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
}
