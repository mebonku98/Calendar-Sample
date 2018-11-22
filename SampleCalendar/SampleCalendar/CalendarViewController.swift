//
//  CalendarViewController.swift
//  SampleCalendar
//
//  Created by Ankita Ghosh on 22/11/18.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- IBOutlets
    @IBOutlet weak var monthAndYearLbl: UILabel!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var showTodayButton: UIButton!
    
    //MARK:- Private vars
    private var firstOfMonthDate : Date = Date()
    private var datesList : [Date?] = []
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTodayButton.layer.borderColor = UIColor.gray.cgColor
        
        self.setupCalendarData(for: Date())
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Collection view delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDateCell", for: indexPath as IndexPath) as! CalendarDateCell
        
        let cellDate = indexPath.row < datesList.count ? datesList[indexPath.row] : nil
        dCell.setupDateCell(for: cellDate, hasEvent: ((indexPath.row + 1) % 9) == 0)
        
        // Gray for saturday & sunday
        if ((indexPath.row + 1) % 7) == 0 || (indexPath.row % 7) == 0 {
            dCell.dateLabel.textColor = .gray
        }
        return dCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 60) / 7
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ((indexPath.row + 1) % 9) == 0 {
            let weekView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarWeekViewController") as! CalendarWeekViewController
            self.navigationController?.pushViewController(weekView, animated: true)
            
        }
    }
    
    //MARK:- IBAction methods
    @IBAction func loadPrevMonthAction(_ sender: Any) {
        self.setupCalendarData(for: getFirstDateOfPrevMonth(from: self.firstOfMonthDate))
        self.monthCollectionView.reloadData()
    }
    
    @IBAction func loadNextMonthAction(_ sender: Any) {
        self.setupCalendarData(for: getFirstDateOfNextMonth(from: self.firstOfMonthDate))
        self.monthCollectionView.reloadData()
    }
    
    @IBAction func showTodayAction(_ sender: Any) {
        self.setupCalendarData(for: Date())
        self.monthCollectionView.reloadData()
    }
    
    //MARK:- Helper methods
    func setupCalendarData(for date: Date) {
        (self.firstOfMonthDate ,self.datesList) = self.getAllDatesOfMonth(for: date)
        
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        monthAndYearLbl.text = fmt.string(from: date).uppercased()
    }
    
    //MARK: get required dates
    //TODO: move to implementation
    func getAllDatesOfMonth(for date:Date) -> (Date, [Date?]) {
        var datesArray : [Date?] = []
        
        let calendar = NSCalendar.current
        let startComponents = calendar.dateComponents([.year, .month], from: date)
        var startOfMonth : Date! = calendar.date(from: startComponents)
        let firstDateOfMonth = startOfMonth
        
        // Adding nil buffer items if the month doesnt start from sunday.
        let startWeekDay = calendar.dateComponents([.weekday], from: startOfMonth)
        //        print("startWeekDay: \(startWeekDay)")
        if startWeekDay.weekday! > 1 {
            for _ in 1...(startWeekDay.weekday! - 1) {
                datesArray.append(nil)
            }
        }
        
        var endComponents = DateComponents()
        endComponents.month = 1
        endComponents.day = -1
        let endOfMonth : Date! = calendar.date(byAdding: endComponents, to: startOfMonth!)
        
        while startOfMonth <= endOfMonth {
            datesArray.append(startOfMonth)
            startOfMonth = calendar.date(byAdding: .day, value: 1, to: startOfMonth)!
        }
        //        print("dates array: \(datesArray)")
        return (firstDateOfMonth!, datesArray)
    }
    
    func getFirstDateOfPrevMonth(from date:Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let lastMonthDate = NSCalendar.current.date(byAdding: dateComponents, to: date)
        return lastMonthDate!
    }
    
    func getFirstDateOfNextMonth(from date:Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let nextMonthDate = NSCalendar.current.date(byAdding: dateComponents, to: date)
        return nextMonthDate!
    }
    
}


