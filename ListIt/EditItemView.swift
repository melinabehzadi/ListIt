//
//  EditItemView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import SwiftUI

struct EditItemView: View {
    @Binding var items: [(name: String, price: Double, quantity: Int)]
    var itemIndex: Int

    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack(spacing: 15) {
                Text("Edit Item")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 40)

                // Item Name Input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Item Name:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)

                    TextField("Enter item name", text: $itemName)
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(10)
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }

                // Item Price Input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Price for the Item:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)

                    TextField("Enter item price", text: $itemPrice)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(10)
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }

                // Item Quantity Input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Quantity:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)

                    TextField("Enter quantity", text: $itemQuantity)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(10)
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }

                Spacer()

                // Save Button
                Button(action: saveItem) {
                    Text("Save Changes")
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
            let item = items[itemIndex]
            itemName = item.name
            itemPrice = String(format: "%.2f", item.price)
            itemQuantity = "\(item.quantity)"
        }
    }

    private func saveItem() {
        if let price = Double(itemPrice), let quantity = Int(itemQuantity), !itemName.isEmpty {
            items[itemIndex] = (name: itemName, price: price, quantity: quantity)
            presentationMode.wrappedValue.dismiss()
        }
    }
}
