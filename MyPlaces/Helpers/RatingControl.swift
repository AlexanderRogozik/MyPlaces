//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/25/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: - Proporties
    
    private var ratingArrayButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }

    @IBInspectable var starSize : CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButton()
        }
    }
    @IBInspectable var starCount : Int = 5 {
        didSet {
            setupButton()
        }
    }
    
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super .init(coder: coder)
        setupButton()

    }
    //MARK: - Private Methods
    
    private func setupButton(){
        
        for button in ratingArrayButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingArrayButtons.removeAll()
        
        //Load button image
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount{
            //Create button
            
            let button = UIButton()
            
            //Set button image
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])


            //Add constraint
            
            button.translatesAutoresizingMaskIntoConstraints = false // откл констраинты автоматом
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //setupButtonAction
            
            button.addTarget(self, action: #selector(ratingButtonAction), for: .touchUpInside)
            
            //Add button to the stack
            
            addArrangedSubview(button)
            
            //add the new button on the rating button array
            
            ratingArrayButtons.append(button)
        }
        updateButtonSelectionState()
        
    }
    
    //MARK: - Button Action
    
    @objc func ratingButtonAction(button : UIButton){
        guard let index = ratingArrayButtons.firstIndex(of: button) else {
            return
        }
        
        //Calculate the rating of the selected button
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        }else{
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingArrayButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
