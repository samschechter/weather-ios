//
//  HourView.swift
//  Weather
//
//  Created by Sam Schechter on 7/6/16.
//  Copyright © 2016 Sam Schechter. All rights reserved.
//

import UIKit

class HourView: UIView {
    
    @IBOutlet weak var tempLabel: UILabel!

    class func instanceFromNib() -> HourView {
        return UINib(nibName: "HourlyView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HourView
    }
}