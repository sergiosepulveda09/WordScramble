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
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingError: Bool = false
    @State private var scoreCounter: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                TextField("Type your new word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                    
                }
                HStack {
                    Text("Words found: ")
                    Text("\(scoreCounter)")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .overlay(
            Button(action: {
                startGame()
                usedWords.removeAll()
                newWord = ""
            }, label: {
                Image(systemName: "arrow.counterclockwise")
            })
            .padding()
            .foregroundColor(.black)
            ,alignment: .topLeading
        )
    
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!?")
            return
        }
        guard isReal(word: answer) else {
            var title: String = ""
            var message: String = ""
            if answer.count < 3 {
                title = "Word is too short"
                message = "The word should have three or more characters"
            } else if answer == rootWord {
                title = "That word is the title!"
                message =  "Please use a different one"
                
            } else {
                title = "Word not possible"
                message = "That isn't a real word"
            }
            
            wordError(title: title, message: message)
            return
        }
        
        usedWords.insert(answer, at: 0)
        scoreCounter += 1
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startsWords = try? String(contentsOf: startWordsURL) {
                let allwords = startsWords.components(separatedBy: "\n")
                rootWord = allwords.randomElement() ?? "silkworm"
                return
            }
            
        }
        
        fatalError("Could not load start.text from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 || word == rootWord {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
