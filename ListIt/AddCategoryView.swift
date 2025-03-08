//
//  AddCategoryView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import SwiftUI

struct AddCategoryView: View {
    @Binding var allShoppingLists: [String: [String]]
    @Environment(\.presentationMode) var presentationMode
    @State private var categoryName: String = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack {
                Text("Create New Category")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 40)

                // Input Field for Category Name
                TextField("Category Name", text: $categoryName)
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(10)
                    .foregroundColor(Color("TextColor"))
                    .padding(.horizontal)

                Spacer()

                // Save Button
                Button(action: saveCategory) {
                    Text("Add Category")
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
    }

    private func saveCategory() {
        if !categoryName.isEmpty {
            allShoppingLists[categoryName] = [] // Initialize empty list
            presentationMode.wrappedValue.dismiss()
        }
    }
}

