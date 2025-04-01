//
//  AddCategoryView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode

    var editingCategoryName: String?

    @State private var categoryName: String = ""
    @State private var showDuplicateAlert: Bool = false // 👈 Alert trigger

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack {
                Text(editingCategoryName == nil ? "Create New Category" : "Edit Category")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 40)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Category Name:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)

                    TextField("Enter category name", text: $categoryName)
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(10)
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }

                Spacer()

                Button(action: saveCategory) {
                    Text(editingCategoryName == nil ? "Add Category" : "Update Category")
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
            if let editingCategoryName = editingCategoryName {
                categoryName = editingCategoryName
            }
        }
        .alert(isPresented: $showDuplicateAlert) {
            Alert(
                title: Text("Duplicate Category"),
                message: Text("A category with this name already exists."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func saveCategory() {
        guard !categoryName.isEmpty else { return }

        // 👇 Prevent renaming to a duplicate name (unless it's the same one)
        if dataManager.allShoppingLists.keys.contains(categoryName),
           categoryName != editingCategoryName {
            showDuplicateAlert = true
            return
        }

        if let oldName = editingCategoryName {
            dataManager.renameCategory(oldName: oldName, newName: categoryName)
        } else {
            dataManager.addCategory(categoryName)
        }

        presentationMode.wrappedValue.dismiss()
    }
}
