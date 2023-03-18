//
//  TodoItemRow.swift
//  Todo List Test
//
//  Created by Bouchedoub Ramzi on 18/3/2023.
//

import SwiftUI

struct TodoItem2: Identifiable {
    var id = UUID()
    var title: String
    var description: String?
    var endDate: Date?
    var isChecked = false
    var subItems: [TodoItem3]? = nil

}
struct TodoItem3: Identifiable {
    var id = UUID()
    var namr : String
    
}

struct TodoView: View {
    @State var todos:[TodoItem2] = []
    @State var showModal = false
    @State var title = ""
    @State var embedded = ""
    @State var description = ""
    @State var endDate =  Date()
    @Environment(\.presentationMode) var presentationMode
    @State var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    var body: some View {
        if isLoggedIn {
            NavigationView{
                List {
                    ForEach(todos) { todo in
                        TodoRow(todo: todo)
                    }
                    .onMove(perform: move)
                }
                .navigationBarItems(
                    trailing: Button(action: { showModal = true }) {
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $showModal) {
                    NavigationView {
                        Form {
                            TextField("Title", text: $title)
                            TextField("Description", text: $description)
                            TextField("embedded", text: $embedded)
                            DatePicker("Select a date", selection: $endDate)
                                        
                        }
                        .navigationBarTitle("Add Todo")
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                 presentationMode.wrappedValue.dismiss()
                            },
                            trailing: Button("Save") {
                                let newTodo = TodoItem2(title: title, description: description, endDate: endDate ,subItems: [
                                    TodoItem3(namr: embedded)
                                    
                                ])
                                
                                todos.append(newTodo)
                                title = ""
                                description = ""
                                embedded = ""
                            }
                                .disabled(title.isEmpty)
                        )
                    }
                }
                .navigationBarTitle("Todos")
                .navigationBarItems(trailing: EditButton())
            }
        } else {
            LoginView(loginAction: login)
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
    }
    func exampleFunction(binding: Binding<Date?>) {
        if let date = binding.wrappedValue {
            print("Selected date: \(date)")
        } else {
            print("No date selected")
        }
    }
   func login(email: String) {
            // Store the email address in UserDefaults
            UserDefaults.standard.set(email, forKey: "email")
            // Set isLoggedIn to true
            isLoggedIn = true
            
            // Store the isLoggedIn flag in UserDefaults
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
}

struct TodoRow: View {
    @State var todo: TodoItem2
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { toggleChecked() }) {
                    Image(systemName: todo.isChecked ? "checkmark.square" : "square")
                        .foregroundColor(todo.isChecked ? .green : .primary)
                }
                .buttonStyle(BorderlessButtonStyle())
                VStack{
                    Text(todo.title)
                    if let description = todo.description {
                        Text(description)
                    }
                }
                Spacer()
                if let endDate = todo.endDate {
                    Text(dateFormatter.string(from: endDate))
                }
            }
            VStack{
                HStack{
                    if (todo.subItems != nil) {
                        ForEach(todo.subItems!) { subItem in
                            HStack{
                                Image(systemName:  "circle.fill" )
                                Text(subItem.namr)
                            }
                        }
                    }
                }
                .padding(.vertical ,3)
                .padding(.horizontal ,33)
            }
        }
    }
    
    func toggleChecked() {
        todo.isChecked.toggle()
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
struct LoginView: View {
    @State var email = ""
    let loginAction: (String) -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Log in with your email address")
                .font(.title)
            TextField("Email address", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                loginAction(email)
            }) {
                Text("Log In")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
