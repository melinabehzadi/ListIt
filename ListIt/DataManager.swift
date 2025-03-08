//
//  DataManager.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import Foundation

struct ShoppingListItem: Codable, Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var quantity: Int
}

struct ShoppingList: Codable, Identifiable {
    var id = UUID()
    var name: String
    var items: [ShoppingListItem]
}

class DataManager: ObservableObject {
    @Published var allShoppingLists: [String: [ShoppingList]] = [:] // Dictionary of categories and lists

    private let storageKey = "shoppingLists"

    init() {
        loadLists()
    }

    // Save data to UserDefaults
    func saveLists() {
        if let encoded = try? JSONEncoder().encode(allShoppingLists) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    // Load data from UserDefaults
    func loadLists() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedLists = try? JSONDecoder().decode([String: [ShoppingList]].self, from: savedData) {
            allShoppingLists = decodedLists
        }
    }

    // Add new category
    func addCategory(_ category: String) {
        if allShoppingLists[category] == nil {
            allShoppingLists[category] = []
            saveLists()
        }
    }

    // Add new list to category
    func addList(to category: String, listName: String) {
        let newList = ShoppingList(name: listName, items: [])
        allShoppingLists[category, default: []].append(newList)
        saveLists()
    }

    // Add new item to list
    func addItem(to category: String, listName: String, item: ShoppingListItem) {
        if let listIndex = allShoppingLists[category]?.firstIndex(where: { $0.name == listName }) {
            allShoppingLists[category]?[listIndex].items.append(item)
            saveLists()
        }
    }

    // Edit item in list
    func editItem(in category: String, listName: String, itemIndex: Int, newItem: ShoppingListItem) {
        if let listIndex = allShoppingLists[category]?.firstIndex(where: { $0.name == listName }) {
            allShoppingLists[category]?[listIndex].items[itemIndex] = newItem
            saveLists()
        }
    }

    // Delete item from list
    func deleteItem(from category: String, listName: String, itemIndex: Int) {
        if let listIndex = allShoppingLists[category]?.firstIndex(where: { $0.name == listName }) {
            allShoppingLists[category]?[listIndex].items.remove(at: itemIndex)
            saveLists()
        }
    }
}

