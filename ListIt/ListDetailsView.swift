//
//  ListDetailsView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-02-25.
//
import SwiftUI

struct ListDetailsView: View {
    @State var listName: String
    @State private var items: [String] = ["Soap", "Sponges", "Disinfectant"]
    @State private var checkedItems: Set<String> = []
    @State private var isAddingItem = false

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

                // Items List with Swipe-to-Delete
                List {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.headline)
                                .foregroundColor(checkedItems.contains(item) ? .gray : Color("TextColor"))
                                .strikethrough(checkedItems.contains(item), color: .gray)
                                .padding()
                                .onTapGesture {
                                    toggleItemCheck(item: item)
                                }
                            Spacer()
                        }
                        .listRowBackground(Color("CardColor"))
                    }
                    .onMove(perform: moveItem) // Enables drag-to-rearrange
                    .onDelete(perform: deleteItem) // Swipe-to-delete
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
        if let index = items.firstIndex(of: item) {
            let removedItem = items.remove(at: index)
            items.append(removedItem)
        }
    }

    // Move items manually
    private func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }

    // Swipe-to-delete
    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
