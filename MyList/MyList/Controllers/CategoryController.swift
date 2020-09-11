//
//  ViewController.swift
//  ToDoList
//
//  Created by Engy Samy on 10/9/2020.
//
import UIKit
import CoreData
import SwipeCellKit

class CategoryController : UITableViewController, SwipeTableViewCellDelegate {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationItem.title = "To Do List"
        loadCategories()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryID") as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteCategory(at: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return [deleteAction]
    }
  
    func deleteCategory(at indexPath: IndexPath){
        context.delete(categories[indexPath.row])
        categories.remove(at: indexPath.row)
        saveCategory()
        loadCategories()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
        }
    }
    
    func loadCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch {
            print("Error loading categories \(error)")
        }
       
        tableView.reloadData()
        
    }
    
    func saveCategory(){
        do{
            try context.save()
            
        }
        catch{
            print("Error \(Error.self)")
        }
        tableView.reloadData()
    }
     
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catgegory", style: .default){ (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text
            self.categories.append(newCategory)
            self.saveCategory()
        }
        alert.addAction(action)
        alert.addTextField{(field) in
        textfield = field
        textfield.placeholder = "Add Category"
                           
        }
        present(alert, animated: true, completion: nil)
    }
}
    
