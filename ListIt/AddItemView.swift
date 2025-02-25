import SwiftUI

struct AddItemView: View {
    @Binding var items: [String]
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName: String = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack {
                Text("Add New Item")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 40)

                // Input Field
                TextField("Item Name", text: $itemName)
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(10)
                    .foregroundColor(Color("TextColor"))
                    .padding(.horizontal)

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
        if !itemName.isEmpty {
            items.append(itemName)
            presentationMode.wrappedValue.dismiss()
        }
    }
}
