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
    private var aDay: ADay?
    
    func update(_ aDay: ADay, isFirstRow: Bool) {
        self.aDay = aDay
        
        gridLine.isHidden = !aDay.isValid || isFirstRow
        
        dayLabel.isHidden = !aDay.isValid
        if let day = aDay.day {
            dayLabel.text = "\(day)"
        } else {
            dayLabel.text = "-"
        }
        
        dayLabel.textColor = aDay.weekday?.isWeekend == true ? .blue : .white
        todayFlagView.isHidden = !aDay.isToday
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gridLine.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        todayFlagView.layer.cornerRadius = 20
        todayFlagView.backgroundColor = .brown.withAlphaComponent(0.5)
    }
}
