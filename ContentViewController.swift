//
//  ContentViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/28/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var presentText = ""
    var image = ""
    var currentPage = 0
    var numberOfPages = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = presentText
        imageView.image = UIImage(named: image)
        pageControl.numberOfPages = 2
        pageControl.currentPage = currentPage
        
        nextButton.layer.cornerRadius = 15
        nextButton.clipsToBounds = true
        
        switch currentPage {
        case 0:
            nextButton.setTitle("Далее", for: .normal)
        case 1:
            nextButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        switch currentPage {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(at: currentPage)
        case 1:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "watched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
