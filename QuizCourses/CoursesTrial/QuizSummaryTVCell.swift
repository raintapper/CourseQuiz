//
//  QuizSummaryTVCellTableViewCell.swift
//  CoursesTrial
//
//  Created by Barry Chew on 9/8/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit

class QuizSummaryTVCell: UITableViewCell {
    
    @IBOutlet var yourAnswerLabel: UILabel!
    @IBOutlet var correctAnswerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tickIndicator: TickCrossIndicator!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
