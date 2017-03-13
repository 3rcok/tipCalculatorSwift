//
//  SettingsViewController.swift
//  tippy
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var tipPercent: UISegmentedControl!
    @IBOutlet weak var themeSelectSwitch: UISwitch!
/*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(UserDefaults.standard.value(forKey: "default_index"))

        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func changeDefaultPercentage(_ sender: UISegmentedControl) {
        let defaultIndex = defaultTipPercent.selectedSegmentIndex
        let defaults = UserDefaults.standard
        defaults.set(defaultIndex, forKey: "default_index")
        defaults.synchronize()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        let defaults = UserDefaults.standard
        let intValue = defaults.integer(forKey: "default_index")
        defaultTipPercent.selectedSegmentIndex = intValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
*/

  var defaultTipIndex:Int=1;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let defaults = UserDefaults.standard
        themeSelectSwitch.setOn(false, animated: false);
        if let themeIndex = defaults.object(forKey: "themeIndex") as? Bool
        {
            themeSelectSwitch.setOn(themeIndex, animated: false);
        }
        
        if let tipIndex = defaults.object(forKey: "defaultTipIndex") as? Int
        {
            tipPercent.selectedSegmentIndex=tipIndex;
        } else {
            tipPercent.selectedSegmentIndex=defaultTipIndex;//default tip is 20%
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func themeSelectToggle(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(self.themeSelectSwitch.isOn, forKey: "themeIndex");
        defaults.synchronize();
    }
    
    @IBAction func defaultTipChange(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(self.tipPercent.selectedSegmentIndex, forKey: "defaultTipIndex");
        defaults.synchronize();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }


}
