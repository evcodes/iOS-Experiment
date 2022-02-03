//
//  ContentView.swift
//  amplifyExperiment
//
//  Created by Varela, Eddy on 1/28/22.
//

import SwiftUI
import Amplify
import Combine



struct ContentView: View {
    @State private var todoTitle: String = ""
    @State private var todoDetails: String = ""
    @State private var todoItemsQueried: [String] = []
    @State var todoSubscription: AnyCancellable?

    func performOnAppear(){
//        subscribeTodos()
    }
    
    func subscribeTodos() {
        print("subscribeOnTodos called")
        self.todoSubscription
            = Amplify.DataStore.publisher(for: Todo.self)
                .sink(receiveCompletion: { completion in
                    print("Subscription has been completed: \(completion)")
                }, receiveValue: { mutationEvent in
                    print("Subscription got this value: \(mutationEvent)")

                    do {
                      let todo = try mutationEvent.decodeModel(as: Todo.self)

                      switch mutationEvent.mutationType {
                      case "create":
                        print("Created: \(todo)")
                      case "update":
                        print("Updated: \(todo)")
                      case "delete":
                        print("Deleted: \(todo)")
                      default:
                        break
                      }

                    } catch {
                      print("Model could not be decoded: \(error)")
                    }
                })
    }
    
    func queryItems(){
        Amplify.DataStore.query(Todo.self) { result in
                todoItemsQueried = []
                switch(result) {
                case .success(let todos):
                    print(todos)
                    for todo in todos {
                        todoItemsQueried.append(todo.name)
//
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
        let item = Todo(name: todoTitle,
                        description: todoDetails)
        Amplify.DataStore.save(item) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.name)")
                todoTitle = ""
                todoDetails = ""
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
            TextField("Todo title", text: $todoTitle)
                .frame(width: 350, height: 50, alignment: .center)
                .onAppear(perform: performOnAppear)
            TextField("Todo details", text: $todoDetails)
                .frame(width: 350, height: 250, alignment: .center)
                
            
//            HStack{
//                Button("sign in") {
//                    print("Sign in pressed")
//                }.padding()
//                Button("sign up") {
//                    print("Sign up pressed")
//                }
//            }
                
            
            Button(action: {
                   saveItem()
               }) {
                   Text("Save Item")
                       .frame(minWidth: 0, maxWidth: 300)
                       .font(.system(size: 18))
                       .padding()
                       .foregroundColor(.white)
                       .overlay(
                           RoundedRectangle(cornerRadius: 25)
                               .stroke(Color.white, lineWidth: 2)
                   )
               }
               .background(Color.blue) // If you have this
               .cornerRadius(25)
                
            Button(action: {
                queryItems()
                
            }){
                    Text("Query items")
                        .frame(minWidth: 0, maxWidth: 300)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.yellow, lineWidth: 2)
                    )
                
                } .background(Color.orange) // If you have this
                .cornerRadius(25)
                 
            
//            Button("Update Todo title") {
//                updateItemName(prevName: "Pickup car", newName: "Wash car")
//            }
//
//            Button("Delete todo"){
//                deleteItem(itemName:"Wash car")
//            }
            
            Text("Our todo list contains: ")
                        
                ForEach(todoItemsQueried, id: \.self) { todo in
                    Text(todo)
                }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
