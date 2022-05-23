//
//  AlbumListViewModel.swift
//  TopFavs
//
//  Created by Consultant on 5/12/22.
//

import UIKit

@objc protocol AlbumListViewModelType {
    func bind(updateHandler: @escaping () -> Void)
    func getAlbums()
    var  count: Int { get }
    var getAllIndex: [Int] { get }
    func removeIndex (index: Int)
    func addIndex (index: Int)
    func imageData(index: Int, completion: @escaping (Data?) -> Void)
    func albumTitle(index: Int) -> String?
    func artistName(index: Int) -> String?
    func makeFavorited(index: Int)
    func deleteFavorite()
    func deleteAll()
    func loadFavorite()
    func getFavoriteInfo() -> String?
    func allAlbumNames() -> [String]
    func allArtistNames() -> [String]
    func allButtonStatus() -> [Int]
    func albumGenre(index: Int) -> String?
    func dateReleased(index: Int) -> String?
    func buttonStatus(index: Int) -> Int
    func changeButtonStatus(index: Int)
    func fetchTest() -> String?
    func removeFavorite(name: String)
}

class AlbumListViewModel: AlbumListViewModelType {
    private var manager: CoreDataManager
    
    var albums: [Album] {
        didSet {
            self.updateHandler?()
        }
    }
    
    private var favorited: Favorited? {
        didSet {
            self.updateHandler?()
        }
    }
    
    let dataFetcher: DataFetcher
    
    var updateHandler: (() -> Void)?
    
    init(albums: [Album] = [], manager: CoreDataManager = CoreDataManager(), dataFetcher: DataFetcher = NetworkManager()) {
        self.albums = albums
        self.dataFetcher = dataFetcher
        self.manager = manager
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func getAlbums() {
        self.dataFetcher.fetchModel(url: NetworkParams.albumList.url) { [weak self] (result: Result<Opening, Error>) in
            switch result {
            case .success(let page):
                //self?.albums.append(contentsOf: page.feed.results)
                
                // let's set a favorite status straight from the json results
                // if they match an album title then flag them
                let storedAlbums: [String] = self?.allAlbumNames() ?? []
                var data = page
                var cells: [Int] = []
                    
                if (storedAlbums.count >= 1) {
                    for index in 0...storedAlbums.count - 1 {
                        for count in 0...(page.feed.results.count) - 1 {
                            
                            //initialize faves
                            data.feed.results[count].fav = 0
                            
                            if (storedAlbums[index] == data.feed.results[count].name){
                                cells.append(count)
                            }
                        }
                    }
                }
                
                print(cells)
                DispatchQueue.main.sync {
                    self?.manager.removeAllIndices()
                    if (cells.count >= 1){
                        for index in 0...cells.count - 1{
                            self?.manager.addIndex(index: cells[index])
                            self?.manager.saveContext()
                        }
                    }
                }
                
                
                if (cells.count >= 1){
                    for index in 0...cells.count - 1{
                        data.feed.results[cells[index]].fav = 1
                    }
                }
                
                self?.albums.append(contentsOf: data.feed.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var count: Int {
        return self.albums.count
    }
    
    var getAllIndex: [Int] {
        return self.manager.getAllIndex() ?? []
    }
    
    func removeIndex (index: Int) {
        self.manager.removeIndex(index: index)
        self.manager.saveContext()
    }
    
    func addIndex (index: Int) {
        self.manager.addIndex(index: index)
        self.manager.saveContext()
    }
    
    func imageData(index: Int, completion: @escaping (Data?) -> Void) {
        guard index < self.count else {
            completion(nil)
            return
        }
        
        guard let imagePath = self.albums[index].artworkUrl100 else {
            completion(nil)
            return
        }
        
        if let imageData = ImageCache.shared.getImageData(key: imagePath) {
            completion(imageData)
            return
        }
        
        self.dataFetcher.fetchData(url: NetworkParams.albumImage(path: imagePath).url) { result in
            switch result {
            case .success(let data):
                ImageCache.shared.setImageData(key: imagePath, data: data)
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func albumTitle(index: Int) -> String? {
        guard index < self.count else { return nil }
        return "Album: " + self.albums[index].name
    }
    
    func buttonStatus(index: Int) -> Int {
        guard index < self.count else { return 0 }
        if (self.albums[index].fav == nil){
            self.albums[index].fav = 0
        }
        return self.albums[index].fav ?? 5
    }
    
    func changeButtonStatus(index: Int) {
        var x = 0
        if(self.albums[index].fav == 1 && x == 0){
            self.albums[index].fav = 0
            x += 1
        }
        if(self.albums[index].fav == 0 && x == 0){
            self.albums[index].fav = 1}
        
    }
    
    func artistName(index: Int) -> String? {
        guard index < self.count else { return nil }
        return "Artist: " + self.albums[index].artistName
    }
    
    func dateReleased(index: Int) -> String? {
        guard index < self.count else { return nil }
        return "Date Released: " + self.albums[index].releaseDate
    }
    
    func albumGenre(index: Int) -> String? {
        guard index < self.count else { return nil }
        var gen = ""
        var count = 0
        for i in 0 ..< self.albums[index].genres.count {
            gen.append(self.albums[index].genres[i].name.rawValue)
            count += 1
        }
        return gen
    }
    
    func makeFavorited(index: Int) {
        let favAlbum = self.albums[index]
        self.favorited = self.manager.makeFavorite(favAlbum: favAlbum)
        print ("adding " + favAlbum.artistName)
        self.manager.saveContext()
    }
    
    func deleteFavorite() {
        if let favorited = favorited {
            self.manager.deleteFavorite(favorited)
        }
        self.favorited = nil
    }
    
    func deleteAll() {
        self.manager.deleteAll()
    }
    
    func loadFavorite() {
        self.favorited = self.manager.fetchFavorite()
    }
    
    func getFavoriteInfo() -> String? {
        guard let name = self.favorited?.albumName  else { return nil }
        print(
        """
            My darling Kitty Kat \(name)

        """
        )
        let displayText = "\(name)"
        return displayText
    }
    
    func allAlbumNames() -> [String]{
        self.manager.allAlbumNames()
    }
    
    func allArtistNames() -> [String]{
        self.manager.allArtistNames()
    }
    
    func allButtonStatus() -> [Int]{
        self.manager.allButtonStatus()
    }
    
    func fetchTest() -> String? {
        self.manager.fetchTest()
    }
    
    func removeFavorite(name: String){
        self.manager.removeFavorite(name: name)
    }
}
