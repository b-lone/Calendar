//
//  MonthCollectionViewCell.swift
//  YCalendar
//
//  Created by Archie on 2022/7/17.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gridLine: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var todayFlagView: UIView!
    private var dayModel: DayModel?
    
    func update(_ dayModel: DayModel, isFirstRow: Bool) {
        self.dayModel = dayModel
        
        gridLine.isHidden = dayModel.isPlaceholder || isFirstRow
        
        dayLabel.isHidden = dayModel.isPlaceholder
        dayLabel.text = "\(dayModel.day)"
        
        dayLabel.textColor = dayModel.weekday.isWeekend ? .blue : .white
        todayFlagView.isHidden = !dayModel.isToday
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gridLine.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        todayFlagView.layer.cornerRadius = 20
        todayFlagView.backgroundColor = .brown.withAlphaComponent(0.5)
    }
}
