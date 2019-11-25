//
//  RealmManager.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol LocalStorageProtocol: AnyObject {
    func clear()
    func getObject<T>(type: T.Type, objectId: Any) -> T? where T: Object
    func getObjects<T>(type: T.Type) -> [T]? where T: Object
    func addObject(_ object: Object)
    func updateObject<T: Object>(_ object: T, with block: () -> Void)
    func delete(_ object: Object)
    func deleteAllObjects<T: Object>(type: T.Type)
}

final class RealmManager: LocalStorageProtocol {

    static let shared = RealmManager()
    private let realm = try! Realm()

    init() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }

    func clear() {
        write {
            realm.deleteAll()
        }
    }

    func getObject<T>(type: T.Type, objectId: Any) -> T? where T: Object {
        realm.refresh()
        return realm.object(ofType: type, forPrimaryKey: objectId)
    }

    func getObjects<T>(type: T.Type) -> [T]? where T: Object {
        realm.refresh()
        let objects = realm.objects(type)
        return Array(objects)
    }

    func addObject(_ object: Object) {
        write {
             realm.add(object, update: .modified)
        }
    }

    func updateObject<T: Object>(_ object: T, with block: () -> Void) {
        write {
            block()
        }
    }

    func delete(_ object: Object) {
        write {
            realm.delete(object)
        }
    }

    func deleteAllObjects<T: Object>(type: T.Type) {
        let objects = realm.objects(type)
        write {
            realm.delete(objects)
        }
    }

    private func write(_ block: () -> Void) {
        do {
            try realm.write {
                block()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}
