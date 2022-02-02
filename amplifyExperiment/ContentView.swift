//
//  ContentView.swift
//  amplifyExperiment
//
//  Created by Varela, Eddy on 1/28/22.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin


func configureAmplify() {
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
    do {
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        // simplified error handling for the tutorial
        print("Could not initialize Amplify: \(error)")
    }
}



struct ContentView: View {
    @State private var title: String = ""
    @State private var password: String = ""
    
    func queryItems(){
        Amplify.DataStore.query(Todo.self) { result in
                switch(result) {
                case .success(let todos):
                    for todo in todos {
                        print("==== Todo ====")
                        print("Name: \(todo.name)")
                        if let priority = todo.priority {
                            print("Priority: \(priority)")
                        }
                        if let description = todo.description {
                            print("Description: \(description)")
                        }
                    }
                case .failure(let error):
                    print("Could not query DataStore: \(error)")
            }
        }
    }
    
    func updateItemName(prevName:String, newName:String){
        Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.name.eq(prevName)) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, var updatedTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                updatedTodo.name = newName
                Amplify.DataStore.save(updatedTodo) { result in
                    switch(result) {
                    case .success(let savedTodo):
                        print("Updated item: \(savedTodo.name)")
                    case .failure(let error):
                        print("Could not update data in DataStore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    func saveItem(){
        let item = Todo(name: "Wash car",
                        description: "Vacuum Interior and Wax exterior.")
        Amplify.DataStore.save(item) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.name)")
            case .failure(let error):
                print("Could not save item to DataStore: \(error)")
            }
        }
        
    }
    
    func deleteItem(itemName:String){
        Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.name.eq(itemName)) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, let toDeleteTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                Amplify.DataStore.delete(toDeleteTodo) { result in
                    switch(result) {
                    case .success:
                        print("Deleted item: \(toDeleteTodo.name)")
                    case .failure(let error):
                        print("Could not update data in DataStore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        
    }
    
    var body: some View {
        
        VStack{
            
            TextField("Title", text: $title)
                .padding()
            TextField("Password", text: $password)
                .padding()
            
            HStack{
                Button("sign in") {
                    print("Sign in pressed")
                }.padding()
                Button("sign up") {
                    print("Sign up pressed")
                }
            }
            Button("Save todo") {
                saveItem()
            }
            Button("Query todos") {
                queryItems()
            }
            
            Button("Update Todo title") {
                updateItemName(prevName: "Pickup car", newName: "Wash car")
            }

            Button("Delete todo"){
                deleteItem(itemName:"Wash car")
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
