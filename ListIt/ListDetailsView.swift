//
//  ListDetailsView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import SwiftUI

struct ListDetailsView: View {
    @ObservedObject var dataManager: DataManager // Use DataManager for persistence
    var category: String
    var list: ShoppingList

    @State private var listName: String
    @State private var checkedItems: Set<UUID> = []
    @State private var isAddingItem = false
    @State private var isEditingItem = false
    @State private var selectedItemIndex: Int? = nil
    @State private var sortedItems: [ShoppingListItem] = []

    var totalCost: Double {
        list.items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var tax: Double {
        totalCost * 0.13 // Example: 13% tax
    }
    
    var totalCostAfterTax: Double {
        totalCost + tax
    }

    init(dataManager: DataManager, category: String, list: ShoppingList) {
        self.dataManager = dataManager
        self.category = category
        self.list = list
        _listName = State(initialValue: list.name)
        _sortedItems = State(initialValue: list.items)
    }

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack {
                // Editable List Name
                TextField("Enter List Name", text: $listName, onCommit: updateListName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Total Cost Section
                VStack {
                    Text("Total Cost: $\(totalCost, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                    Text("Tax (13%): $\(tax, specifier: "%.2f")")
                        .foregroundColor(Color("TextColor"))
                    Text("Total After Tax: $\(totalCostAfterTax, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                }
                .padding()
                .background(Color("CardColor"))
                .cornerRadius(10)
                .padding(.horizontal)

                // Items List with Swipe-to-Delete, Check-Off, and Edit
                List {
                    ForEach(sortedItems, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(checkedItems.contains(item.id) ? .gray : Color("TextColor"))
                                    .strikethrough(checkedItems.contains(item.id), color: .gray)

                                Text("Price: $\(item.price, specifier: "%.2f") • Qty: \(item.quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("TextColor").opacity(0.7))
                            }
                            .onTapGesture {
                                toggleItemCheck(item: item)
                            }

                            Spacer()

                            // Edit Button
                            Button(action: {
                                if let index = sortedItems.firstIndex(where: { $0.id == item.id }) {
                                    selectedItemIndex = index
                                    isEditingItem = true
                                }
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color("AccentColor"))
                                    .padding()
                            }
                        }
                        .listRowBackground(Color("CardColor"))
                    }
                    .onDelete(perform: deleteItem)
                }
                .background(Color("BackgroundColor"))
                .scrollContentBackground(.hidden)

                Spacer()

                // Floating Add Item Button
                HStack {
                    Spacer()
                    Button(action: {
                        isAddingItem = true
                    }) {
                        Circle()
                            .fill(Color("AccentColor"))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .shadow(radius: 6)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $isAddingItem) {
                AddItemView(dataManager: dataManager, category: category, listName: list.name)
            }
            .sheet(isPresented: $isEditingItem) {
                if let index = selectedItemIndex {
                    EditItemView(dataManager: dataManager, category: category, listName: list.name, itemIndex: index)
                }
            }
            .onAppear {
                sortItems()
            }
        }
    }

    // Update list name when changed
    private func updateListName() {
        if !listName.isEmpty {
            if let listIndex = dataManager.allShoppingLists[category]?.firstIndex(where: { $0.id == list.id }) {
                dataManager.allShoppingLists[category]?[listIndex].name = listName
                dataManager.saveLists()
            }
        }
    }

    // Toggle check-off (strikethrough effect) and move checked items to the end
    private func toggleItemCheck(item: ShoppingListItem) {
        withAnimation {
            if checkedItems.contains(item.id) {
                checkedItems.remove(item.id)
            } else {
                checkedItems.insert(item.id)
            }
            sortItems()
        }
    }

    // Sort items: unchecked first, checked last
    private func sortItems() {
        sortedItems = list.items.sorted { (item1, item2) in
            let isChecked1 = checkedItems.contains(item1.id)
            let isChecked2 = checkedItems.contains(item2.id)
            return isChecked1 == isChecked2 ? false : !isChecked1
        }
    }

    // Swipe-to-delete
    private func deleteItem(at offsets: IndexSet) {
        if let listIndex = dataManager.allShoppingLists[category]?.firstIndex(where: { $0.id == list.id }) {
            dataManager.allShoppingLists[category]?[listIndex].items.remove(atOffsets: offsets)
            dataManager.saveLists()
            sortItems()
        }
    }
}
