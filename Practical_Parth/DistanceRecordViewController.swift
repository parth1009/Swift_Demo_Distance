//
//  DistanceRecordViewController.swift
//  Practical_Parth
//
//  Created by Parth Thakker on 21/11/17.
//  Copyright © 2017 Parth Thakker. All rights reserved.
//

import UIKit
import CoreData

class DistanceRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tblRecord: UITableView!
    
    var arrDistance: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrDistance = NSMutableArray()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        appDelegate.managedObjectContext = appDelegate.getManagedObjectContext()
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "TblData", in: appDelegate.managedObjectContext!)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try appDelegate.managedObjectContext?.fetch(fetchRequest)
            let count: Int = try (appDelegate.managedObjectContext?.count(for: fetchRequest))!
            if (result != nil && count > 0) {
                
                arrDistance.addObjects(from: result!)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        tblRecord.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDistance.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:DistanceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DistanceTableViewCell") as! DistanceTableViewCell!
        
        let data = arrDistance![0] as! TblData
        cell.lblDate.text = data.recordDate
        return cell
    }
    
    

}
