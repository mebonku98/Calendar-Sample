//
//  ADVSegmentedControl.swift
//  Mega
//
//  Created by Tope Abayomi on 01/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import UIKit

@IBDesignable class ADVSegmentedControl: UIControl {
    
    static let defaultWeekday : Int = 0 //0 for 1st weekday

    private var firstLabels = [UILabel]()
    private var nextLabels = [UILabel]()
    var thumbView = UIView()
    var highlightedIndex : Int = defaultWeekday

    var firstItems: [String] = ["S\n10", "M\n11", "T\n12", "W\n13", "T\n14", "F\n15", "S\n16"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex : Int = defaultWeekday {
        didSet {
            displayNewSelectedIndex(animate: true)
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var selectedBackgroundColor : UIColor = UIColor.clear {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var highlightedThumbColor : UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    func setupView(){
        
        layer.cornerRadius = frame.height / 2
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        addIndividualItemConstraints(items: firstLabels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels(){
        
        for label in firstLabels {
            label.removeFromSuperview()
        }
            
        firstLabels.removeAll(keepingCapacity: true)
        
        for index in 1...firstItems.count {
            
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: 25, height: 70))
            label.text = firstItems[index - 1]
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.backgroundColor = index == 1 ? selectedBackgroundColor : UIColor.clear
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            firstLabels.append(label)
        }
        
        addIndividualItemConstraints(items: firstLabels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
//        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = selectFrame.size.height - 10
        selectFrame.size.height = selectFrame.size.width        
        thumbView.frame = selectFrame
        
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.width / 2
        
        displayNewSelectedIndex(animate: false)
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in firstLabels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(animate: Bool){
        for (_, item) in firstLabels.enumerated() {
            item.textColor = unselectedLabelColor
            item.backgroundColor = UIColor.clear
        }
        
        let label = selectedIndex >= 0 ? firstLabels[selectedIndex] : firstLabels[0]
        label.textColor = selectedIndex >= 0 ? selectedLabelColor : unselectedLabelColor
        label.backgroundColor = selectedIndex >= 0 ? selectedBackgroundColor : UIColor.clear
        
        UIView.animate(withDuration: animate ? 0.5 : 0.0, delay: 0.0, usingSpringWithDamping: animate ? 0.9 : 1, initialSpringVelocity: animate ? 0.8 : 1, options: .beginFromCurrentState, animations:
            {
                var tFrame = label.frame
                tFrame.size.width = tFrame.height - 10
                tFrame.size.height = tFrame.size.width
                self.thumbView.frame = tFrame
                self.thumbView.center = label.center
                self.thumbView.backgroundColor = self.selectedIndex >= 0 ? (self.selectedIndex == self.highlightedIndex ? self.highlightedThumbColor : self.thumbColor) : UIColor.clear
            }, completion: nil)
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
//        let constraints = mainView.constraints
        
        for (index, button) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -padding)
                
            }
            else {
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nextButton, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: prevButton, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in firstLabels {
            item.textColor = unselectedLabelColor
            item.backgroundColor = UIColor.clear
        }
        
        if firstLabels.count > 0 {
            firstLabels[0].textColor = selectedLabelColor
            firstLabels[0].backgroundColor = selectedBackgroundColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in firstLabels {
            item.font = font
        }
    }
}
