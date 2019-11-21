//
//  SchoolDetailViewController.swift
//  NYCSchoolChallenge
//
//  Created by Hudson Mcashan on 7/1/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SchoolDetailViewController: UIViewController {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var boroLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var numStudentsLabel: UILabel!
    @IBOutlet weak var englishScoreLabel: UILabel!
    @IBOutlet weak var mathScoreLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var school: School?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let school = school else { return }
        title = "\(school.schoolName)"
        addressLabel.text = school.location
        boroLabel.text = school.boro
        phoneNumberLabel.text = school.phoneNumber
        numStudentsLabel.text = String(school.totalStudents)
        
        // parse SAT score
        if let scores = school.satScores {
            var myStringArr: [String] = scores.components(separatedBy: " ")
            let rawEnglishScore: Substring = myStringArr[6].dropLast()
            let parsedEnglishScore1: Substring = rawEnglishScore.dropFirst()
            let parsedEnglishScore2: String = String(parsedEnglishScore1.dropLast())
            let rawMathScore: Substring = myStringArr[8].dropLast()
            let parsedMathScore: String = String(rawMathScore.dropFirst())
            englishScoreLabel.text = parsedEnglishScore2
            mathScoreLabel.text = parsedMathScore
        } else {
            englishScoreLabel.text = "N/A"
            mathScoreLabel.text = "N/A"
        }
        
    }
    
    private func showNoSchoolError() {
        let alert = UIAlertController(title: "Error", message: "There was a problem displaying details on the school", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


