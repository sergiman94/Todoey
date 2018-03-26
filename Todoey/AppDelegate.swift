//
//  AppDelegate.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/16/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // priemera funcion que se ejecuta en toda la aplicacion
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ruta donde esta el archivo de la base de datos de realm, se abre con realm browser
        print(Realm.Configuration.defaultConfiguration.fileURL)
 
        do{
            let realm = try Realm()
            
        }catch{
            print("Error Initializing new realm, \(error)")
        }
        
        
        return true
    }
    
    // cuando la aplicacion se termina, cuando estamos en otra aplicacion con muchos mas procesos la de nosotros termina, cuando la cerramos tambien
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // con esta variable estamos creando un conetenedor que basicamente es la base de datos que hemos creado
    // especificamente NSPersistentContainer trabaja como SQL, contiene las entidades y sus atributos con las relaciones
    lazy var persistentContainer: NSPersistentContainer = {
        
        
        // name : debe de coincidir con el archivo CoreData creado
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // en esta funcion la variable context contiene lo que es probable que se guarde, como en git es la face de escenario
    // en donde se mira que es lo que se va a guardar antes de guardarlo definitivamente, una vez seguros de lo que se
    // va a guardar se pasa al context.save()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}

