//
//  ContentView.swift
//  WordScramble
//
//  Created by Sergio Sepulveda on 2021-06-16.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord: String = ""
    @State private var newWord: String = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Type your new word", text: $newWord)
                List(usedWords, id: \.self) {
                    Text($0)
                    
                }
                
            }
            .navigationBarTitle(rootWord)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
