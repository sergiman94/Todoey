//
//  ViewController.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/16/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    
    // funcion que se ejecuta justo despues del viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.name
        
        guard let colourHex = selectedCategory?.colour else { fatalError()}
        
        updateNavBar(withHexCode: colourHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    // MARK: - nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist.")
        }
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }
    
    // MARK - Tableview Datasource Methods
    
    // creamos el numero de celdas que se desean con respecto a la longitud del vector (arreglo)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // funcion que permite gestionar con cada celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // cada item de la lista
        if let item = todoItems?[indexPath.row] {
            
            // texto que va en cada celda - arreglo
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString:selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            // ternary operator ==>
            // value = condition ? valueIfTrue : calueIfFalse
            
            // representacion de la estructura condicional de abajo con el operador ternario
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        }else{
            //            cell.accessoryType = .none
            //        }
            
        }else{
            
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    // funcion que detecta cuando se ah seleccionado una fila - cuando se ha seleccionado una fila
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        
        tableView.reloadData()
        
        
        // no dejamos seleccionada cada fila que oprimimos
        tableView.deselectRow(at: indexPath, animated: true)
        
        //         // si ya marcamos con un accesorio (chulo) la fila que hemos seleccionado
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            // no marque otra vez, quitala
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else{
        //            // marca
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        
    }
    
    // MARK - Add new items
    @IBAction func AddButoPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // creamos una alerta que contenga una accion
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // accion que contiene la alerta para agregar un nuevo item - action ejecuta la accion del addItem
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIalert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Error saving new Items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
            
        }
        
        // entrada de texto donde podemos darle un nombre al nuevo item que se va a agregar
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            // guardamos la info de el textfield de la alerta en la variable textfield
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        // mostramos la alerta
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // hacemos unas solicitudes para leer y mostrar los datos, guardamos los items en el arreglo
    // para que cuando se termine la app sigan persistiendo
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        tableView.reloadData()
        
    }
    
    override func updateDataModel(at indexpath: IndexPath) {
        if let item = todoItems?[indexpath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error deleting itme, \(error)" )
            }
        }
    }
    
}


// MARK _ Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

       // actualizamos cambios
        tableView.reloadData()

    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}























