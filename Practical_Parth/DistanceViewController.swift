//
//  DistanceViewController.swift
//  Practical_Parth
//
//  Created by Parth Thakker on 21/11/17.
//  Copyright © 2017 Parth Thakker. All rights reserved.
//

import UIKit

class DistanceViewController: UIViewController {

    @IBOutlet var lblDistance: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.travelledDistanceByUser()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func travelledDistanceByUser()
    {
        lblDistance.text = String(appDelegate.travelledDistance)
    }
}
