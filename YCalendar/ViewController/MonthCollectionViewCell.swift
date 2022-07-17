//
//  MonthCollectionViewCell.swift
//  YCalendar
//
//  Created by Archie on 2022/7/17.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    private var dayModel: DayModel?
    
    func update(_ dayModel: DayModel) {
        self.dayModel = dayModel
        
        dayLabel.isHidden = dayModel.isPlaceholder
        dayLabel.text = "\(dayModel.day)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
