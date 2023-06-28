import SwiftUI

struct User {
    let id = UUID()
    var name: String
    var age: String
}

class UserListViewModel: ObservableObject {
    @Published var users = [
        User(name: "Lionel Messi", age: "81"),
        User(name: "Ronaldo de Lima", age: "26")
    ]
    
    func addUser(name: String, age: String) {
        let newUser = User(name: name, age: age)
        users.append(newUser)
    }
    
    func deleteUser(at index: Int) {
        users.remove(at: index)
    }
    
    func updateUser(at index: Int, withName name: String, age: String) {
        users[index].name = name
        users[index].age = age
    }
}

struct UserListView: View {
    @ObservedObject var viewModel = UserListViewModel()
    @State private var newName = ""
    @State private var newAge = ""
    
    var body: some View {
        VStack {
            ForEach(viewModel.users.indices, id: \.self) { index in
                let user = viewModel.users[index]
                HStack {
                    TextField("Name", text: Binding(
                        get: { user.name },
                        set: { viewModel.updateUser(at: index, withName: $0, age: user.age) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Age", text: Binding(
                        get: { user.age },
                        set: { viewModel.updateUser(at: index, withName: user.name, age: $0) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.deleteUser(at: index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            HStack {
                TextField("Name", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Age", text: $newAge)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add User") {
                    viewModel.addUser(name: newName, age: newAge)
                    newName = ""
                    newAge = ""
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            UserListView()
                .navigationBarTitle("User List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





