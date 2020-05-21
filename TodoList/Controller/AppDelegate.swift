//
//  AppDelegate.swift
//  TodoList
//
//  Created by Maryam on 2/19/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            _ = try Realm()
        } catch {
            print ("Error initializing new realm, \(error)")
        }
        print (Realm.Configuration.defaultConfiguration.fileURL)
        return true
    }
}

