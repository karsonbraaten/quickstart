//
//  FirestoreCollection.swift
//  gtg
//
//  Created by Karson Braaten on 2017-11-01.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import FirebaseFirestore

typealias CollectionChangesBlock<T: DocumentSerializable> = (_ items: [T], _ documents: [DocumentSnapshot], _ collectionChanges: CollectionChanges) -> Void

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
    var dictionary: [String: Any] {get}
}

struct CollectionChanges {
    var inserts: [Int]
    var reloads: [Int]
    var deletes: [Int]
}

final class FirestoreCollection<T: DocumentSerializable> {
    
    private(set) var items: [T] = []
    private(set) var documents: [DocumentSnapshot] = []
    private(set) var isLoading = true
    
    private let collectionChangesBlock: CollectionChangesBlock<T>
    
    private var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }
    
    private var query: Query! {
        didSet {
            self.listen()
        }
    }
    
    init(query: Query, collectionChangesBlock: @escaping CollectionChangesBlock<T>) {
        self.collectionChangesBlock = collectionChangesBlock
        self.setQuery(query)
    }
    
    
    private func setQuery(_ query: Query) {
        self.query = query
    }
    
    private func listen() {
        self.listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let initial = CollectionChanges(inserts: [], reloads: [], deletes: [])
            let collectionChanges = snapshot.documentChanges
                .reduce(into: initial) { acc, cur in
                    switch cur.type {
                    case .added:
                        acc.inserts.append(Int(cur.newIndex))
                    case .modified:
                        acc.reloads.append(Int(cur.newIndex))
                    case .removed:
                        acc.deletes.append(Int(cur.oldIndex))
                    }
            }
            
            let items = snapshot.documents.map { doc -> T in
                if let model = T.init(dictionary: doc.data()) {
                    return model
                } else {
                    fatalError("Unable to initialize type \(T.self) with dictionary \(doc.data())")
                }
            }
            self.items = items
            self.documents = snapshot.documents
            self.isLoading = false
            
            self.collectionChangesBlock(items, snapshot.documents, collectionChanges)
        }
    }
    
    deinit {
        listener = nil
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(index: Int) -> T {
        return items[index]
    }
    
}
