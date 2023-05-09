//
//  FormField.swift
//  Zante
//
//  Created by Anshjyot Singh on 15/03/2023.
//

import SwiftUI

struct FormField: View {
  @Binding var value: String
  var icon: String
  var placeholder: String
  var isSecure = false


    var body: some View {
      Group {
        HStack{
          Image(systemName: icon).padding()
          Group{
            if isSecure {
              SecureField(placeholder, text: $value) // password
            } else {
              TextField(placeholder, text: $value)
            }

          }.font(Font.system(size: 18, design: .default))
            .foregroundColor(.black)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.leading)
            .disableAutocorrection(true)
            .autocapitalization(.none)
        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 4)).padding()
      }
    }
}


