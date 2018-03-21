//
//  ViewController.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/16/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()
        
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
            
            
            let newItem = Item()
            newItem.title = textField.text!
            
            
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
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
        }
        
        // actualizamos la informacion del tableView como tambien la del arreglo con los nuevos items
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
        
    }
    
    
}
























