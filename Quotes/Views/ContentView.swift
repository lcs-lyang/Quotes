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
            
            Button(action: {
                print("Button was pressed")
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
                
        
            
            List {
                Text("I believe that every person is born with talent. -Maya Angelou")
                Text("The bird of paradise alights only upon the hand that does not grasp. - John Berry")
                Text("Do not follow where the path may lead. Go, instead, where there is no path and leave a trail. - Ralph Waldo Emerson")
            }
            
            Spacer()
                        
        }
        // When the app opens, get a new joke from the web service
        .task {
            
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
                
            } catch {
                print("Could not retrieve or decode the JSON from endpoint.")
                // Print the contents of the "error" constant that the do-catch block
                // populates
                print(error)
            }
            
        }
        
        .navigationTitle("Quotes")
        .padding()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        ContentView()
        }
    }
}
