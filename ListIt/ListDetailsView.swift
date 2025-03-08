//
//  ListDetailsView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-02-25.
//
import SwiftUI

struct ListDetailsView: View {
    @State var listName: String
    @State private var items: [(name: String, price: Double, quantity: Int)] = [
        ("Soap", 2.50, 2),
        ("Sponges", 1.20, 1),
        ("Disinfectant", 4.75, 1)
    ]
    @State private var checkedItems: Set<String> = []
    @State private var isAddingItem = false
    @State private var isEditingItem = false
    @State private var selectedItemIndex: Int? = nil

    var totalCost: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var tax: Double {
        totalCost * 0.13 // Example: 13% tax
    }

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack {
                // Editable List Name
                TextField("Enter List Name", text: $listName)
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
                }
                .padding()
                .background(Color("CardColor"))
                .cornerRadius(10)
                .padding(.horizontal)

                // Items List with Swipe-to-Delete, Check-Off, and Edit
                List {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]

                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(checkedItems.contains(item.name) ? .gray : Color("TextColor"))
                                    .strikethrough(checkedItems.contains(item.name), color: .gray)

                                Text("Price: $\(item.price, specifier: "%.2f") • Qty: \(item.quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("TextColor").opacity(0.7))
                            }
                            .onTapGesture {
                                toggleItemCheck(item: item.name)
                            }

                            Spacer()

                            // Edit Button
                            Button(action: {
                                selectedItemIndex = index
                                isEditingItem = true
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
                AddItemView(items: $items)
            }
            .sheet(isPresented: $isEditingItem) {
                if let index = selectedItemIndex {
                    EditItemView(items: $items, itemIndex: index)
                }
            }
        }
    }
    
    // Toggle check-off (strikethrough effect)
    private func toggleItemCheck(item: String) {
        withAnimation {
            if checkedItems.contains(item) {
                checkedItems.remove(item)
            } else {
                checkedItems.insert(item)
                moveToBottom(item: item)
            }
        }
    }

    // Move checked items to bottom
    private func moveToBottom(item: String) {
        if let index = items.firstIndex(where: { $0.name == item }) {
            let removedItem = items.remove(at: index)
            items.append(removedItem)
        }
    }

    // Swipe-to-delete
    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
