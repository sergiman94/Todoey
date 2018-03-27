//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/22/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    
    var categories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
//
//        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        
        return cell
    }
    
    //MARK - Data Manipulation Methods
    
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        
        
        tableView.reloadData()
    }
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateDataModel(at indexpath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexpath.row] {
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
            
        }
        
        
    }
    
    //MARK: - Add New Categories
    
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add New Category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
}



















