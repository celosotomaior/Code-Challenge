//
//  DetailTableViewCell.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import UIKit
import MapKit

class DetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var studentsLabel: UILabel!
    
    @IBOutlet weak var gradesLabel: UILabel!

    @IBOutlet weak var writingLabel: UILabel!
    
    @IBOutlet weak var mathLabel: UILabel!
    
    
    @IBOutlet weak var criticalReadingLabel: UILabel!
    
    @IBOutlet weak var schoolOverviewLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var graduationRateLabel: UILabel!
    //Properties
    static let reuseIdentifier = "DetailTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setUpWith(school: School?, score: ScoreOnSAT?) {
        schoolNameLabel.text = school?.schoolName ?? ""
        criticalReadingLabel.text = score?.satCriticalReadingAvgScore ?? "n/a"
        schoolOverviewLabel.text = school?.overviewParagraph ?? ""
        gradesLabel.text = school?.finalGrades ?? ""
        studentsLabel.text = score?.numOfSatTestTakers ?? "n/a"
        graduationRateLabel.text = school?.graduationRate?.toPercentage() ?? "n/a"

        mathLabel.text = score?.satMathAvgScore ?? "n/a"
        writingLabel.text = score?.satWritingAvgScore ?? "n/a"

        
    
    }
    
}
