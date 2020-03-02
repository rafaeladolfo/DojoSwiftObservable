//
//  ContentView.swift
//  SwiftUI-MVVMObservable
//
//  Created by Rafael Adolfo on 01/03/20.
//  Copyright © 2020 Rafael Adolfo. All rights reserved.
//

import SwiftUI

let apiUrl = "url"

struct User: Identifiable, Decodable {
    let id = UUID()
    let firstName: String
    let lastName : String
}

class UsersViewModel: ObservableObject {
    @Published var names = "Names from VM observable object"

    @Published var users: [User] = [
    .init(firstName: "andreas", lastName: "kisser"),
    .init(firstName: "ozzy", lastName: "osbourne")
    ]

    func updateNames(){
        self.names = "update names"
    }
    
    func getUsers(){
        guard let url = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            DispatchQueue.main.async {
                self.users = try! JSONDecoder().decode([User].self, from: data!)
            }
            
        }.resume()
    }
}

struct ContentView: View {
    
    @ObservedObject var usersViewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(usersViewModel.users) { user in
                    Text(user.firstName + " " + user.lastName)
                }
            }
            .navigationBarTitle("Data")
            .navigationBarItems(trailing: Button(action: {
                print("Get new data")
                self.usersViewModel.getUsers()
                    
                }, label: {
                    Text("Get data")
                } ))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
