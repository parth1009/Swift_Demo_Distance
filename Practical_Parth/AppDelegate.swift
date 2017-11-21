//
//  AppDelegate.swift
//  Practical_Parth
//
//  Created by Parth Thakker on 21/11/17.
//  Copyright © 2017 Parth Thakker. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import UserNotifications

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var managedObjectContext: NSManagedObjectContext?
    var managedObjectModel: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var travelledDistance: Double = 0.0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                center.delegate = self
        }
        }
        else {
            // Fallback on earlier versions
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // app active
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("test")
        print("test")
        
    }
    
    func getManagedObjectModel() -> NSManagedObjectModel
    {
        if (managedObjectModel != nil) {
            return managedObjectModel!;
        }
        let modelURL = Bundle.main.url(forResource: "Practical_Parth", withExtension: "momd")
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
        return managedObjectModel!;
    }
    
    func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        if (persistentStoreCoordinator != nil) {
            return persistentStoreCoordinator!
        }
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.getManagedObjectModel())
        var storeURL: NSURL = NSURL(fileURLWithPath: (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]))
        storeURL = storeURL.appendingPathComponent("Practical_Parth.sqlite")! as NSURL
        do {
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL as URL, options: nil)
        }
        catch {
            
        }
        
        return persistentStoreCoordinator!
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext
    {
        if (managedObjectContext != nil) {
            return managedObjectContext!
        }
        
        let persistantCoordinator: NSPersistentStoreCoordinator? = self.getPersistentStoreCoordinator()
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = persistantCoordinator
        return managedObjectContext!
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context: NSManagedObjectContext? = self.managedObjectContext!
        
        if (context != nil) {
            
            if (context?.hasChanges)! {
                do {
                    try context?.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }

}

