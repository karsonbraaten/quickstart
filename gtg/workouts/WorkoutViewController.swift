//
//  WorkoutViewController.swift
//  gtg
//
//  Created by Karson Braaten on 2017-11-15.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import UIKit
import FirebaseFirestore

class WorkoutViewController: UITableViewController {
    
    private var sets = [WorkoutSet]()
    private var documents = [DocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Firestore.firestore()
            .collection("users")
            .document(AuthService.shared.currentUser!.uid)
            .collection("sets")
            .order(by: "timestamp", descending: true)
            .whereField("workoutId", isEqualTo: "HgzsuD7467h80fan4yZN")
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                
                let items = snapshot.documents.map { doc -> WorkoutSet in
                    if let model = WorkoutSet(dictionary: doc.data()) {
                        return model
                    } else {
                        fatalError("Unable to initialize type \(WorkoutSet.self) with dictionary \(doc.data())")
                    }
                }
                
                print("\n from cache: \(snapshot.metadata.isFromCache), \(items.count) items\n")
                
                self.sets = items
                self.documents = snapshot.documents
                self.tableView.reloadData()
            }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)
        let set = sets[indexPath.row]
        cell.textLabel?.text = set.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = documents[indexPath.row].documentID
            Firestore.firestore()
                .collection("users")
                .document(AuthService.shared.currentUser!.uid)
                .collection("sets")
                .document(id)
                .delete()
        }
    }
    
    @IBAction func create(_ sender: Any) {
        let exercises = [Exercise(movement: "Push-ups", reps: 20)]
        let set = WorkoutSet(exercises: exercises, timestamp: Date(), workoutId: "HgzsuD7467h80fan4yZN")
        Firestore.firestore()
            .collection("users")
            .document(AuthService.shared.currentUser!.uid)
            .collection("sets")
            .addDocument(data: set.dictionary)
    }

}
