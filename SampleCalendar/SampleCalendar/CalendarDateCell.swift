//
//  CalendarDateCell.swift
//  SampleCalendar
//
//  Created by Ankita Ghosh on 22/11/18.
//

import UIKit

class CalendarDateCell: UICollectionViewCell {
    
    //MARK:- UIOulets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventIndicator: UIImageView!
    
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    //MARK:- Public methods
    func setupDateCell(for date: Date?, hasEvent: Bool) {
        self.dateLabel.text = " "
        eventIndicator.isHidden = true
        if date != nil {
            let fmt = DateFormatter()
            fmt.dateFormat = "d"
            self.dateLabel.text = fmt.string(from: date!)
            eventIndicator.isHidden = !hasEvent
            
            if NSCalendar.current.isDateInToday(date!) {
                self.dateLabel.backgroundColor = .black
                self.dateLabel.textColor = .white
            } else {
                self.dateLabel.backgroundColor = .white
                self.dateLabel.textColor = .black
            }
        }
    }
}
