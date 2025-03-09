//
//  AboutView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("About ListIt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 40)

                // App Version
                VStack {
                    Text("App Version: 1.0.0")
                        .font(.title3)
                        .foregroundColor(Color("TextColor"))
                }
                .padding()
                .background(Color("CardColor"))
                .cornerRadius(10)

                // Team Members
                VStack(alignment: .leading, spacing: 5) {
                    Text("Developed By:")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))

                    Text("• Melina Behzadi Nejad - iOS Developer")
                        .foregroundColor(Color("TextColor"))
                    Text("  Student ID: 101447858")
                        .foregroundColor(Color("TextColor").opacity(0.7))

                    Text("• Samuel Gallego Rivera - iOS Developer")
                        .foregroundColor(Color("TextColor"))
                    Text("  Student ID: 101435708")
                        .foregroundColor(Color("TextColor").opacity(0.7))
                }
                .padding()
                .background(Color("CardColor"))
                .cornerRadius(10)

                // Contact Support
                VStack {
                    Text("For support, contact us at:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))

                    Text("support@listitapp.com")
                        .foregroundColor(Color.blue)
                        .underline()
                        .onTapGesture {
                            if let url = URL(string: "mailto:support@listitapp.com") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .padding()
                .background(Color("CardColor"))
                .cornerRadius(10)

                Spacer()

                // Close Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
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
            .padding()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
