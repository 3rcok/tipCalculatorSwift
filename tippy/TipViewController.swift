//
//  ViewController.swift
//  tippy
//
//  Created by Lei2X Wang.
//  Copyright © 2017 Lei Wang. All rights reserved.
//

import UIKit

@objc(TipViewController) class TipViewController: UIViewController, UITextFieldDelegate {
    
    
    let defaults = UserDefaults.standard
    let previousBillKey = "previous_bill"
    let previousBillDateKey = "previous_bill_date"
    let defaultBill = 0.0

    var billTotal: Double = 0.0
    var tippercent: Double = 18
    var doonce = 0
    var defaultTipIndex: Int = 1
    
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    
    var formatter: NumberFormatter = NumberFormatter()
    let tipPercentages = [0.18, 0.2, 0.25]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        billField.becomeFirstResponder()
        updateToPreviousTotal()
        
        NotificationCenter.default.addObserver(self, selector:#selector(TipViewController.saveCurrentState), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func saveCurrentState() {
        print("***************saveCurrent")
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        UserDefaults.standard.set(Double(billField.text!) ?? 0 , forKey: previousBillKey)
    }
    
    func updateToPreviousTotal() {

        if previousBill != defaultBill && billWasEnteredRecently() {
            billField.text = String(previousBill)
            calculateTip(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {

        let bill = Double(billField.text!) ?? 0
        previousBill = bill

        updateView()
    }

    var previousBill: Double {
        get {
            return defaults.value(forKey: previousBillKey) as? Double ?? defaultBill
        }
        set {
            previousBillDate = Date.timeIntervalSinceReferenceDate
            defaults.set(newValue, forKey: previousBillKey)
        }
    }
    
    func billWasEnteredRecently() -> Bool {
        let now = Date.timeIntervalSinceReferenceDate
        return (now - previousBillDate) < (10 * 60) // Ten minutes
    }

    var previousBillDate: TimeInterval {
        get {
            return defaults.value(forKey: previousBillDateKey) as? Double ?? 0.0
        }
        set {
            defaults.set(newValue, forKey: previousBillDateKey)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        billField.placeholder = formatter.currencySymbol
        formatter.numberStyle = .currency

        let intValue = defaults.integer(forKey: "defaultTipIndex")
        tipControl.selectedSegmentIndex = intValue

        self.view.backgroundColor=UIColor.yellow
        if let theme = defaults.object(forKey: "themeIndex") as? Bool{
            if(theme){
                self.view.backgroundColor=UIColor.green
            } else {
                self.view.backgroundColor=UIColor.yellow
            }
        }
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //save input
        let defaults = UserDefaults.standard
        defaults.set(Double(billField.text!) ?? 0, forKey: previousBillKey)
        defaults.synchronize()

        print("view will disappear")
    }
    
    func updateView() {
        let defaults = UserDefaults.standard
        if (!billField.text!.isEmpty) {
//                let bill = Double(billField.text!) ?? 0

            billTotal = NSString(string: billField.text!).doubleValue

            if (tipControl.selectedSegmentIndex == -1) {
                //no tip % selected on main screen. adopt default tip %
                if let tipPercentIdx = defaults.object(forKey: "defaultTipIndex") as? Int {
                    //Pull from Settings configuration
                    tippercent = self.tipPercentages[tipPercentIdx]
                    tipControl.selectedSegmentIndex = tipPercentIdx
                } else {
                    //Adopt application default
                    tippercent = self.tipPercentages[defaultTipIndex]
                    tipControl.selectedSegmentIndex = defaultTipIndex
                }
            } else {
                tippercent = tipPercentages[tipControl.selectedSegmentIndex]
            }

            let tip: Double = billTotal * tippercent
            let val: Double = billTotal + tip


            totalLabel.text = formatter.string(from: val as NSNumber)!
            tipValueLabel.text = formatter.string(from: tip as NSNumber)!

            if (self.doonce == 0) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.totalLabel.alpha = 1
                    self.totalTextLabel.alpha = 1
                    self.tipTextLabel.alpha = 1
                    self.tipValueLabel.alpha = 1
                    self.tipControl.alpha = 1

                    //move all fields up 100
                    self.tipControl.center.y -= 100
                    
                    self.tipTextLabel.center.y -= 100
                    self.tipValueLabel.center.y -= 100

                    self.totalLabel.center.y -= 100
                    self.totalTextLabel.center.y -= 100
                    
                    self.billField.center.y -= 100
                    self.doonce = 1
                })
            }
        }
        else {

            billTotal = 0

            self.billField.alpha = 1
            self.totalLabel.alpha = 0
            self.totalTextLabel.alpha = 0
            self.tipTextLabel.alpha = 0
            self.tipValueLabel.alpha = 0
            self.tipControl.alpha = 0
            
            //Empty text so hide view
            if (self.doonce == 1) {
                //move all fields down 100
                UIView.animate(withDuration: 0.5, animations: {
                    self.tipControl.center.y += 100
                    
                    self.billField.center.y += 100
                    
                    self.totalLabel.center.y += 100
                    self.totalTextLabel.center.y += 100
                    
                    self.tipTextLabel.center.y += 100
                    self.tipValueLabel.center.y += 100
                    
                    self.doonce = 0
                    
                    self.totalLabel.alpha = 0
                    self.totalTextLabel.alpha = 0
                    self.tipTextLabel.alpha = 0
                    self.tipValueLabel.alpha = 0
                    self.tipControl.alpha = 0
                    
                })
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if let decimalSeparator = Locale.current.decimalSeparator {
            let stringArray = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            newString = stringArray.joined(separator: "")
            newString.insert(contentsOf: decimalSeparator.characters, at: newString.index(newString.endIndex, offsetBy: -2))
            self.billTotal = Double(newString)!
            self.previousBill = billTotal
        } else {
            if let billAmount = formatter.number(from: newString) as? Double {
                self.billTotal = billAmount
                self.previousBill = billTotal
            }


        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        billField.resignFirstResponder()
        return true
    }

}

