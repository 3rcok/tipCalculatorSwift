//
//  SettingsViewController.swift
//  tippy
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var tipPercent: UISegmentedControl!
    @IBOutlet weak var themeSelectSwitch: UISwitch!

  var defaultTipIndex: Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        themeSelectSwitch.setOn(false, animated: false);
        if let themeIndex = defaults.object(forKey: "themeIndex") as? Bool
        {
            themeSelectSwitch.setOn(themeIndex, animated: false)
        }
        
        if let tipIndex = defaults.object(forKey: "defaultTipIndex") as? Int
        {
            tipPercent.selectedSegmentIndex=tipIndex;
        } else {
            tipPercent.selectedSegmentIndex=defaultTipIndex        }
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
        defaults.set(self.tipPercent.selectedSegmentIndex, forKey: "defaultTipIndex")
        defaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 2
    }


}
