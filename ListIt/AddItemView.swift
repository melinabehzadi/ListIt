import SwiftUI

struct AddItemView: View {
    @Binding var items: [(name: String, price: Double, quantity: Int)]
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = "1"

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack(spacing: 15) {
                Text("Add New Item")
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
                    Text("Add Item")
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

    private func saveItem() {
        if let price = Double(itemPrice), let quantity = Int(itemQuantity), !itemName.isEmpty {
            items.append((name: itemName, price: price, quantity: quantity))
            presentationMode.wrappedValue.dismiss()
        }
    }
}
