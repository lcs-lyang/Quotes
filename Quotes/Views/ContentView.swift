//
//  ContentView.swift
//  Quotes
//
//  Created by Lillian Yang on 2022-02-22.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: Stored Properties
    
    @State var currentQuote: Quote = Quote(quoteText: "I don't know what to do...", quoteAuthor: "Lillian", sendername: "", senderlink: "", quoteLink: "http://forismatic.com/en/98e551a8e4/")
    
    @State var favorite: [Quote] = []
    
    @State var currentQuoteAddedToFavorite: Bool = false
    
    
    //MARK: Computed Properties
    
    
    var body: some View {
        VStack {
            
            VStack{
                Text(currentQuote.quoteText)
                    .multilineTextAlignment(.leading)
                
                HStack{
                    Spacer()
                    Text("-\(currentQuote.quoteAuthor)")
                }
            }
            .padding(30)
            .overlay(
                Rectangle()
                    .stroke(Color.primary, lineWidth: 4)
            )
            .padding(10)
            
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(currentQuoteAddedToFavorite == true ? .red : .secondary)
                .onTapGesture {
                    if currentQuoteAddedToFavorite == false{
                        
                        favorite.append(currentQuote)
                        
                        currentQuoteAddedToFavorite = true
                    }
                    
                }
            
            
            Button(action: {
                Task{
                    await loadNewQuote()
                }
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
                .padding()
            
            HStack {
                Text("Favourites")
                    .font(.title2)
                    .bold()
                    .padding()
                Spacer()
            }
            
            
            
            List(favorite, id: \.self) { currentFavorite in
                Text(currentFavorite.quoteText)
            }
            
            Spacer()
            
        }
        // When the app opens, get a new joke from the web service
        .task {
            
            await loadNewQuote()
        }
        
        .navigationTitle("Quotes")
        .padding()
    }
    
    //MARK: Functions
    
    func loadNewQuote() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentQuote = try JSONDecoder().decode(Quote.self, from: data)
            
            currentQuoteAddedToFavorite = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
