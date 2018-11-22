//
//  CalendarWeekViewController.swift
//  SampleCalendar
//
//  Created by Ankita Ghosh on 22/11/18.
//

import UIKit

class CalendarWeekViewController: UIViewController {
    
    @IBOutlet weak var weekSegment: ADVSegmentedControl!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var currentTimeIndicator: UIImageView!
    @IBOutlet weak var dynamicTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dynamicTimeConstraint.constant = 0
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(CalendarWeekViewController.updateCurrentTime), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateCurrentTime() {
        let time = Date()
        
        dynamicTimeConstraint.constant = self.getTimePoint(time: time) - 8
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.currentTimeLbl.text = formatter.string(from: time)
        self.view.layoutIfNeeded()
    }
    
    
    func getTimePoint(time: Date) -> CGFloat {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let today : String = formatter.string(from: time) //ForDate(date: time, dateFormat: "yyyy/MM/dd") as String
        let someDateString = today + " 07:00"
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: someDateString)
        
        let interval = time.timeIntervalSince(someDateTime!)
        let timeInMins = CGFloat(interval) / 60
        
        return timeInMins - timeInMins / 60
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
