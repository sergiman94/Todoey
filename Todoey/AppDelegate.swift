//
//  AppDelegate.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/16/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // priemera funcion que se ejecuta en toda la aplicacion
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ruta donde esta el archivo de la base de datos de realm, se abre con realm browser
        //print(Realm.Configuration.defaultConfiguration.fileURL)
 
        do{
            _ = try Realm()
            
        }catch{
            print("Error Initializing new realm, \(error)")
        }
        
        
        return true
    }
    
    
}

