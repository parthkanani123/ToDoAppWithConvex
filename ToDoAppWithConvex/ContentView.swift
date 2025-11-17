//
//  ContentView.swift
//  ToDoAppWithConvex
//
//  Created by Parth Kanani on 14/11/25.
//

import Combine
import ConvexMobile
import SwiftUI

struct TaskItem: Hashable, Decodable {
    let _id: String
    let isCompleted: Bool
    let text: String
}

struct ContentView: View {
    
    @State private var tasks: [TaskItem] = []
    
    let client = ConvexClient(deploymentUrl: "http://127.0.0.1:3210")
    
    func fetchTasks() async {
        do {
            for try await tasks: [TaskItem] in client.subscribe(to: "tasks:get").values
            {
                self.tasks = tasks
            }
        } catch {
            // handle error
            print("Failed to fetch tasks with error: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks, id: \.self) { task in
                    HStack {
                        Text(task.text)
                        Spacer()
                        
                        if task.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            .task {
                await fetchTasks()
            }
            .navigationTitle("Tasks")
        }
    }
}

#Preview {
    ContentView()
}
