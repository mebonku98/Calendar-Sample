//
//  ViewController.swift
//  CalculatorSample
//
//  Created by Ankita Ghosh on 06/02/19.
//  Copyright © 2019 Ankita Ghosh. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var formulaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func numberButtonTouched(_ sender: UIButton) {
        var input : String = formulaLabel.text ?? "0"
        if input == "0."  || input == "0" {
            input = ""
        }
        if input.contains(".") && sender.titleLabel?.text == "." {
            //do nothing
        } else {
            input = input + (sender.titleLabel?.text)! as String
            formulaLabel.text = input
        }
        self.logAnalytics(name: (sender.titleLabel?.text)! as String, content: "number value")
    }
    
    @IBAction func formulaButtonTouched(_ sender: UIButton) {
        var input : String = formulaLabel.text ?? "0"
        if input == "0."  || input == "0" {
            // do nothing
        } else {
            if input.contains("x") || input.contains("÷") || input.contains("+") || input.contains("-") {
                // do nothing
            }
            else {
                input = input + " "+(sender.titleLabel?.text)! as String+" "
                formulaLabel.text = input
            }
        }
        self.logAnalytics(name: (sender.titleLabel?.text)! as String, content: "formula value")
    }
    
    @IBAction func clearButtonTouched(_ sender: Any) {
        formulaLabel.text = "0."
        self.logAnalytics(name: "clear", content: "entry cleared")
    }
    
    func logAnalytics(name: String, content: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(name)",
            AnalyticsParameterItemName: name,
            AnalyticsParameterContentType: content
            ])
    }
}

