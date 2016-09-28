//
//  ViewController.swift
//  tippy
//
//  Created by Lei2X Wang on 9/7/16.
//  Copyright © 2016 Lei Wang. All rights reserved.
//

import UIKit

@objc(TipViewController) class TipViewController: UIViewController {
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let PreviousBill = "previous_bill"
    let PreviousBillDate = "previous_bill_date"
    let DefaultBill = 0.0


    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    let tipPercentages = [0.18, 0.2, 0.25]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        billField.becomeFirstResponder()
        updateToPreviousTotal()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(TipViewController.saveCurrentState), name: UIApplicationDidEnterBackgroundNotification, object: nil)
   

        
    }
    
    func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        NSUserDefaults.standardUserDefaults().setDouble(Double(billField.text!)!, forKey: PreviousBill)
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

    @IBAction func onTap(sender: AnyObject) {
        print("Hello")
        view.endEditing(true)
    }
    @IBAction func calculateTip(sender: AnyObject) {
        
        
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        previousBill = bill;

        
    }
    var previousBill: Double {
        get {
            return defaults.valueForKey(PreviousBill) as? Double ?? DefaultBill
        }
        
        set {
            previousBillDate = NSDate.timeIntervalSinceReferenceDate()
            defaults.setDouble(newValue, forKey: PreviousBill)
        }
    }
    
    func billWasEnteredRecently() -> Bool {
        let now = NSDate.timeIntervalSinceReferenceDate()
        return (now - previousBillDate) < (10 * 60) // Ten minutes
    }
    var previousBillDate: NSTimeInterval {
        get {
            return defaults.valueForKey(PreviousBillDate) as? Double ?? 0.0
        }
        
        set {
            defaults.setDouble(newValue, forKey: PreviousBillDate)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        let intValue = defaults.integerForKey("default_index")
        tipControl.selectedSegmentIndex = intValue
        

        self.calculateTip(self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

