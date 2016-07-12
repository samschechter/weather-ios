//
//  DayTableViewCell.swift
//  Weather
//
//  Created by Sam Schechter on 3/23/16.
//  Copyright © 2016 Sam Schechter. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var hiTime: UILabel!
    @IBOutlet weak var loLabel: UILabel!
    @IBOutlet weak var loTime: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
}
