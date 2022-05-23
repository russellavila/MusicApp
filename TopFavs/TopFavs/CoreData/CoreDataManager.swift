//
//  CoreDataManager.swift
//  TopFavs
//
//  Created by Consultant on 5/14/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    // MARK: CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TopFavs")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Something went wrong, \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error Saving: \(error)")
            }
        }
    }
    
    func makeFavorite(favAlbum: Album) -> Favorited? {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorited", in: context) else { return nil }
        let favorited = Favorited(entity: entity, insertInto: context)
        favorited.albumName = favAlbum.name
        favorited.artistName = favAlbum.artistName
        favorited.buttonStatus = Int16(favAlbum.fav ?? 0)
        
        return favorited
    }
    
    func deleteFavorite(_ favorited: Favorited) {
        let context = self.persistentContainer.viewContext
        context.delete(favorited)
        self.saveContext()
    }
    
    func deleteAll(){
       let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorited")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                do
                {
                    try context.execute(deleteRequest)
                    try context.save()
                }
                catch
                {
                    print ("There was an error")
                }
    }
    
    func allAlbumNames() -> [String] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
          do {
            // Peform Fetch Request
            let albums = try context.fetch(request)
              return albums.map({$0.albumName ?? "none here"})
          } catch {
            print("Unable to Fetch  (\(error))")
          }
          return ["none here as well"]
    }
    
    func allArtistNames() -> [String] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
          do {
            // Peform Fetch Request
            let albums = try context.fetch(request)
              return albums.map({$0.artistName ?? "none here"})
          } catch {
            print("Unable to Fetch (\(error))")
          }
          return ["none here as well"]
    }
    
    func allButtonStatus() -> [Int] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
          do {
            // Peform Fetch Request
            let albums = try context.fetch(request)
              return albums.map({Int($0.buttonStatus)})
          } catch {
            print("Unable to Fetch Saved Albums, (\(error))")
          }
          return []
    }
    
    func fetchFavorite() -> Favorited? {
        let context = self.persistentContainer.viewContext
        
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let favorited = results.first {
                return favorited
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchTest() -> String? {
        let context = self.persistentContainer.viewContext
        
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let favorited = results[2].artistName {
                return favorited
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func getFavoriteCount() -> Int?{
        let context = self.persistentContainer.viewContext
        
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
          // Peform Fetch Request
          let albums = try context.fetch(request)
            return albums.map({Int($0.buttonStatus)}).count
        } catch {
          print("Unable to Fetch Saved Albums, (\(error))")
        }
        return 0
    }
    
    func removeFavorite(name: String){
        let context = self.persistentContainer.viewContext
        
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let results = try context.fetch(request)
                for index in 0...results.count - 1 {
                    if name == "Artist: " + (results[index].artistName ?? "") {
                        let favorited = results[index]
                        print ("deleting... " + (favorited.artistName ?? "nothing"))
                        context.delete(favorited)
                        self.saveContext()
                    }
                }
        
        } catch {
            print(error)
        }
    }
    
    func removeAllIndices() {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
                 let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavIndi")
                 let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                 do
                 {
                     try context.execute(deleteRequest)
                     try context.save()
                 }
                 catch
                 {
                     print ("There was an error")
                 }
    }
    
    func removeIndex(index: Int){
        let context = self.persistentContainer.viewContext
        
        let request: NSFetchRequest<FavIndi> = FavIndi.fetchRequest()
        
        do {
            let results = try context.fetch(request)
                for count in 0...results.count - 1 {
                    if (index == results[count].favoriteIndi) {
                        let favorited = results[count]
                        context.delete(favorited)
                        self.saveContext()
                    }
                }
        
        } catch {
            print(error)
        }
    }
    
    func addIndex(index: Int) -> FavIndi?{
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FavIndi", in: context) else { return nil }
        let favorited = FavIndi(entity: entity, insertInto: context)
        favorited.favoriteIndi = Int32(index)
        return favorited
    }
    
    func getAllIndex() -> [Int]?{
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavIndi> = FavIndi.fetchRequest()
          do {
            // Peform Fetch Request
            let indices = try context.fetch(request)
              return indices.map({Int($0.favoriteIndi)})
          } catch {
            print("Unable to Fetch (\(error))")
          }
          return []
    }
}
