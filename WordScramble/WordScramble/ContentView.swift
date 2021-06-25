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
                TextField("Type your new word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    .padding()
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                    
                }
                
            }
            .navigationBarTitle(rootWord)
        }
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        
        //extra validation to come
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
