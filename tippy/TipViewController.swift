//
//  ViewController.swift
//  tippy
//
//  Created by Lei2X Wang on 9/7/16.
//  Copyright © 2016 Lei Wang. All rights reserved.
//

import UIKit

@objc(TipViewController) class TipViewController: UIViewController {
    
    
    let defaults = UserDefaults.standard
    let PreviousBill = "previous_bill"
    let PreviousBillDate = "previous_bill_date"
    let DefaultBill = 0.0

    var billTotal:Double = 0.0;
    var tippercent:Double=18;
    var doonce=0;
    var defaultTipIndex:Int=1;
    
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var billTextLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    var currencyFormatter:NumberFormatter=NumberFormatter();
    let tipPercentages = [0.18, 0.2, 0.25]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        billField.becomeFirstResponder()
        updateToPreviousTotal()
        
        NotificationCenter.default.addObserver(self, selector:#selector(TipViewController.saveCurrentState), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
   

        
    }
    
    func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        UserDefaults.standard.set(Double(billField.text!)!, forKey: PreviousBill)
    }
    
    func updateToPreviousTotal() {

        if previousBill != DefaultBill && billWasEnteredRecently() {
            billField.text = String(previousBill)
            calculateTip(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        print("Hello")
        view.endEditing(true)
    }
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        
        
        tipValueLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        previousBill = bill;
        updateView()

        
    }
    var previousBill: Double {
        get {
            return defaults.value(forKey: PreviousBill) as? Double ?? DefaultBill
        }
        
        set {
            previousBillDate = Date.timeIntervalSinceReferenceDate
            defaults.set(newValue, forKey: PreviousBill)
        }
    }
    
    func billWasEnteredRecently() -> Bool {
        let now = Date.timeIntervalSinceReferenceDate
        return (now - previousBillDate) < (10 * 60) // Ten minutes
    }
    var previousBillDate: TimeInterval {
        get {
            return defaults.value(forKey: PreviousBillDate) as? Double ?? 0.0
        }
        
        set {
            defaults.set(newValue, forKey: PreviousBillDate)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        billField.placeholder = currencyFormatter.currencySymbol;
        let intValue = defaults.integer(forKey: "default_index")
        tipControl.selectedSegmentIndex = intValue

//        self.view.backgroundColor=UIColor.gray;
//        if let theme = defaults.object(forKey: "themeIndex") as? Bool{
//            if(theme){
//                self.view.backgroundColor=UIColor.green;
//            }
//        }
        updateView()
//        self.calculateTip(self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //save input
        let defaults = UserDefaults.standard
        defaults.set(Double(billField.text!) ?? 0, forKey: "billTotal");
        defaults.synchronize()
        
        print("view will disappear")
    }
    
    func updateView() {
        var defaults = UserDefaults.standard
        if (!billField.text!.isEmpty) {
            billTotal = NSString(string: billField.text!).doubleValue;
            if (tipControl.selectedSegmentIndex == -1) {
                //no tip % selected on main screen. adopt default tip %
                if let tipPercentIdx = defaults.object(forKey: "defaultTipIndex") as? Int {
                    //Pull from Settings configuration
                    tippercent = self.tipPercentages[tipPercentIdx];
                    tipControl.selectedSegmentIndex = tipPercentIdx;
                } else {
                    //Adopt application default
                    tippercent = self.tipPercentages[defaultTipIndex];
                    tipControl.selectedSegmentIndex = defaultTipIndex;
                }
            } else {
                tippercent = tipPercentages[tipControl.selectedSegmentIndex];
            }

            var tip = billTotal * tippercent;
            var val: Double = billTotal + tip;

            //self.totalLabel.text=String(format:"$%.2f",billTotal+tip);
            var formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let nsVal = val as NSNumber
            totalLabel.text = formatter.string(from: nsVal)!

            if (self.doonce == 0) {
                print("doonce == 0")
                UIView.animate(withDuration: 0.5, animations: {
                    self.totalLabel.alpha = 1
                    self.totalTextLabel.alpha = 1
                    self.tipTextLabel.alpha = 1
                    self.tipValueLabel.alpha = 1
                    self.tipControl.alpha = 1

                    //move all fields up 100
                    self.tipControl.center.y -= 10
                    
                    self.tipTextLabel.center.y -= 10
                    self.tipValueLabel.center.y -= 10

                    self.totalLabel.center.y -= 10
                    self.totalTextLabel.center.y -= 10
                    
                    self.billField.center.y -= 10
                    self.billTextLabel.center.y -= 10
                    self.doonce = 1
                });
            }
        } else {
                        print("doonce != 0")

            billTotal = 0;
            self.totalLabel.alpha = 0;
            self.totalTextLabel.alpha = 0;
            self.tipTextLabel.alpha = 0
            self.tipValueLabel.alpha = 0
            self.tipControl.alpha = 0
            
            //Empty text so hide view
            if (self.doonce == 1) {
                                    print("doonce == 1")

                //move all fields down 100
                UIView.animate(withDuration: 0.5, animations: {
                    self.tipControl.center.y += 10
                    
                    self.billField.center.y += 10
                    self.billTextLabel.center.y += 10
                    
                    self.totalLabel.center.y += 10
                    self.totalTextLabel.center.y += 10
                    
                    self.doonce = 0
                    
                    self.totalLabel.alpha = 0
                    self.totalTextLabel.alpha = 0
                    self.tipTextLabel.alpha = 0
                    self.tipValueLabel.alpha = 0
                    self.tipControl.alpha = 0
                    
                });
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
    

}

