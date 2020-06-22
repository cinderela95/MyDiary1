//
//  ViewController.swift
//  MyDiary
//
//  Created by Apple on 6/17/20.
//  Copyright © 2020 Minh Thang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var arrItem:[Item] = []
    var selectedIndex:Int?
    //var searchItem:[String] = []
    //var searching = false
    var filteredItem:[Item] = []
    
    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! contentTableViewCell
        let date = filteredItem.reversed()[indexPath.row].date
        let time = filteredItem.reversed()[indexPath.row].time
        
        cell.textLabel?.text = filteredItem.reversed()[indexPath.row].entry
        
        if let time = time , let date = date {
            let timeStamp = "Add on \(date) at \(time)"
            cell.detailTextLabel?.text = timeStamp
        }
        //cell.detailTextLabel?.text = "Pro"
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete") { (UITableViewRowAction, indexPath) in
            
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let item = self.filteredItem[indexPath.row]
            context.delete(item)
            self.filteredItem.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {}
            
            self.tblView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        let share = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Share") { (UITableViewRowAction, indexPath) in
            print("Share")
        }
        
        return [delete, share]
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let sb = UIStoryboard(name: "Main", bundle: nil)
        //let updateItem = sb.instantiateViewController(withIdentifier: "UPDATE")
        //navigationController?.pushViewController(updateItem, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "UPDATE", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UPDATE" {
            let updateVC = segue.destination as! updateItemViewController
            updateVC.item = filteredItem.reversed()[selectedIndex!]
            
        }
    }
    override func viewDidLoad() {
        tblView.dataSource = self
        tblView.delegate = self
        createSearchBar()
        //searchBar.delegate = self
        //self.navigationItem.titleView = searchBar
        
        
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        }
    func loadData() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.returnsObjectsAsFaults = false
        
        do {
            arrItem = try context.fetch(request) as! [Item]
            filteredItem = arrItem
            self.tblView.reloadData()
            }
        catch {
            print("Error")
        }
    }
    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredItem = arrItem
            
        } else {
            
            filteredItem = arrItem.filter { ($0.entry?.lowercased().contains(searchText.lowercased()))! }
            }
        
        tblView.reloadData()
    }
    
   
   
    
        
}

