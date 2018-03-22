//
//  ViewController.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/16/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    // ingresamos al AppDelegate como un objeto y tomamos sus datos (el contexto de la base de datos)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
        
    }
    
    // MARK - Tableview Datasource Methods
    
    
    // creamos el numero de celdas que se desean con respecto a la longitud del vector (arreglo)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // funcion que permite gestionar con cada celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // seleccion de cada celda con el identificador (se estan reutilizando las celdas)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // cada item de la lista
        let item = itemArray[indexPath.row]
        
        // texto que va en cada celda - arreglo
        cell.textLabel?.text = item.title
        
        
        // ternary operator ==>
        // value = condition ? valueIfTrue : calueIfFalse
        
        // representacion de la estructura condicional de abajo con el operador ternario
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        
        return cell
        
    }
    
    // funcion que detecta cuando se ah seleccionado una fila - cuando se ha seleccionado una fila
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        // para eliminar un item del arreglo y de la base de datos primero se borra de la bd y despues del arreglo
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        // imprimimos en consola la fila que hemos selccionado
        print(itemArray[indexPath.row])
        
        
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
            // what will happen once the user clicks the add item button on our alert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.parentCategory = self.selectedCategory
            newItem.done = false
            
            // insertamos un nuevo item al arreglo con la informacion del textField
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    
    // MARK - Model Manupuation Methods
    
    // guardamos los datos en la base de datos
    func saveItems(){
        
        do{
            
            try context.save()
            
        } catch{
            print("Error saving context, \(error)")
        }
        
        // actualizamos la informacion del tableView como tambien la del arreglo con los nuevos items
        self.tableView.reloadData()
        
    }
    
    // hacemos unas solicitudes para leer y mostrar los datos, guardamos los items en el arreglo
    // para que cuando se termine la app sigan persistiendo
    // la variable request por parametro esta definifa por default para que cuando no se le pase otra variable por parametro no
    // ejecute un error al igual que predicate - ver video 260 para entender esta funcion 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray =  try context.fetch(request)
        } catch  {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}


// MARK _ Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // hacemos una solicitud para ingresar al arreglo de items
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // hacemos una consulta con el predicate, el string es muy importante ya que es texto libre
        // consultamos que el titulo del item contenga un valor
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        // organizamos el resultado de la consulta en orden alfabetico
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true )
        request.sortDescriptors = [sortDescriptor]
        
        // cargamos los itmes que se desean encontrar en la consulta con respecto a este request
        loadItems(with: request, predicate: predicate)
        
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























