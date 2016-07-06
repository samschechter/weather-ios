//
//  HourlyController.swift
//  Weather
//
//  Created by Sam Schechter on 3/28/16.
//  Copyright © 2016 Sam Schechter. All rights reserved.
//

import UIKit

class HourlyController: UIView {

    var buttonSize = 100
    var spacing = 5
    var ratingButtons = [UIView]()
    var stars = 5
    var hours: [Forecast.Hour] = []
//    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for _ in 0..<5 {
            
            let button = UIView()
            button.backgroundColor = UIColor.redColor();
//        
//            button.setImage(emptyStarImage, forState: .Normal)
//            button.setImage(filledStarImage, forState: .Selected)
//            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
//            
//            button.adjustsImageWhenHighlighted = false
//            
//            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents:.TouchDown)
            ratingButtons += [button]
//            
//            addSubview(button)
        }
        
        
    }
    
    override func layoutSubviews() {
        
        var buttonFrame = CGRect(x:0, y:0, width: buttonSize, height: buttonSize)
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonFrame
        }
        
//        updateButtonSelectionStates()
    }
//    
//    override func intrinsicContentSize() -> CGSize {
//        let buttonSize = Int(frame.size.height)
//        let width = (buttonSize + spacing)
//        return CGSize(width: width, height: buttonSize)
//    }
    
    func setHours(hours ahours:[Forecast.Hour]){
        self.hours = ahours
        
        for index in 0...self.hours.count {
            if let h = self.hours[index] as? Forecast.Hour {
                let hourView = HourView.instanceFromNib() as? HourView
                hourView?.tempLabel.text = String(format:"%f", h.temperature!)
                addSubview(hourView!)
            }
        }
    
    }
}