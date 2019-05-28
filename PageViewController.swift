//
//  PageViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/28/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var textLabalArray = ["Создай свой список любимых мест", "Найдите и отметьте на карте свои любимые места"]
    var imageArray = ["fonpage", "mapPage"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < textLabalArray.count else { return nil }
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {
            return nil
        }
        
        controller.image = imageArray[index]
        controller.presentText = textLabalArray[index]
        controller.currentPage = index
        
        return controller
    }
    func nextVC(at Index: Int){
        if let controller = displayViewController(atIndex: Index + 1) {
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        }
    }
}
extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).currentPage
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).currentPage
        index += 1
        return displayViewController(atIndex: index)
    }
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return textLabalArray.count
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController
//        return controller!.currentPage
//    }
}
