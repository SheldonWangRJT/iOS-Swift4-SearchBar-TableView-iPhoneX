//
//  ViewController.swift
//  SearchBarInTable
//
//  Created by Xiaodan Wang on 10/20/17.
//  Copyright © 2017 Xiaodan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var animalArray = [Animal]()
    var currentAnimalArray = [Animal]() //update table
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAnimals()
        setUpSearchBar()
        alterLayout()
    }
    
    private func setUpAnimals() {
        // CATS
        animalArray.append(Animal(name: "Amber", category: .cat, image:"1"))
        animalArray.append(Animal(name: "James", category: .cat, image:"2"))
        animalArray.append(Animal(name: "Peter", category: .cat, image:"3"))
        // DOGS
        animalArray.append(Animal(name: "Haywood", category: .dog, image:"4"))
        animalArray.append(Animal(name: "Shell", category: .dog, image:"5"))
        animalArray.append(Animal(name: "James", category: .dog, image:"6"))
        
        currentAnimalArray = animalArray
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Search Animal by Name"
    }
        
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell()
        }
        cell.nameLbl.text = currentAnimalArray[indexPath.row].name
        cell.categoryLbl.text = currentAnimalArray[indexPath.row].category.rawValue
        cell.imgView.image = UIImage(named:currentAnimalArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // This two functions can be used if you want to show the search bar in the section header
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return searchBar
//    }
    
//    // search bar in section header
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentAnimalArray = animalArray.filter({ animal -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return animal.name.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return animal.category == .dog }
                return animal.name.lowercased().contains(searchText.lowercased()) &&
                animal.category == .dog
            case 2:
                if searchText.isEmpty { return animal.category == .cat }
                return animal.name.lowercased().contains(searchText.lowercased()) &&
                animal.category == .cat
            default:
                return false
            }
        })
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentAnimalArray = animalArray
        case 1:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.dog
            })
        case 2:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.cat
            })
        default:
            break
        }
        table.reloadData()
    }
}

class Animal {
    let name: String
    let image: String
    let category: AnimalType
    
    init(name: String, category: AnimalType, image: String) {
        self.name = name
        self.category = category
        self.image = image
    }
}

enum AnimalType: String {
    case cat = "Cat"
    case dog = "Dog"
}


