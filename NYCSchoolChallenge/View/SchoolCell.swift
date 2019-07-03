//
//  SchoolCell.swift
//  NYCSchoolChallenge
//
//  Created by Hudson Mcashan on 7/1/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import UIKit

class SchoolCell: UITableViewCell {
    static let identifier = "SchoolCell"
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    func configure(with schoolName: String) {
        schoolNameLabel.text = schoolName
    }
}
