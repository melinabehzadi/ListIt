//
//  AddListView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-02-25.
//

import SwiftUI

struct AddListView: View {
    @ObservedObject var dataManager: DataManager // Use DataManager for persistence
    @Binding var selectedCategory: String
    @Environment(\.presentationMode) var presentationMode

    @State private var listName: String = ""
    @State private var newCategory: String = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack {
                Text("Create New List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 40)

                // Input Field for List Name
                VStack(alignment: .leading, spacing: 5) {
                    Text("List Name:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)

                    TextField("Enter list name", text: $listName)
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(10)
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }

                // Category Selector
                VStack(alignment: .leading, spacing: 5) {
                    Text("Select Category:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)

                    Picker("Select Category", selection: $newCategory) {
                        ForEach(dataManager.allShoppingLists.keys.sorted(), id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(10)
                    .foregroundColor(Color("TextColor"))
                    .padding(.horizontal)
                }

                Spacer()

                // Save Button
                Button(action: saveList) {
                    Text("Add List")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            newCategory = selectedCategory // Default to the currently selected category
        }
    }

    private func saveList() {
        if !listName.isEmpty && !newCategory.isEmpty {
            dataManager.addList(to: newCategory, listName: listName) // Save list using DataManager
            presentationMode.wrappedValue.dismiss()
        }
    }
}
