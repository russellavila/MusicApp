//
//  FavsController.swift
//  TopFavs
//
//  Created by Consultant on 5/12/22.
//

import UIKit

class FavsViewController: UIViewController {
    
    var albumNames : [String] = []
    var artistNames : [String] = []
    var favIndi : [Int] = []
    var buttonStatus: [Int] = []
    var test : String = "ghjhg"
    var albumListViewModel = AlbumListViewModel()
    
    lazy var albumTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .black
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.register(FavsCell.self, forCellReuseIdentifier: FavsCell.reuseId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.setUpUI()
        
        self.albumListViewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.albumTableView.reloadData()
            }
        }
        //there is probably some redundancy here with the fetching and getting
        self.albumListViewModel.getAlbums()
        albumNames = self.albumListViewModel.allAlbumNames()
        artistNames = self.albumListViewModel.allArtistNames()
        buttonStatus = self.albumListViewModel.allButtonStatus()
        favIndi = self.albumListViewModel.getAllIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           viewLoadSetup()
            
    }

    func viewLoadSetup(){
        self.view.backgroundColor = UIColor.black
        self.setUpUI()
        self.albumListViewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.albumTableView.reloadData()
            }
        }
        //there is probably some redundancy here with the fetching and getting
        self.albumListViewModel.getAlbums()
        albumNames = self.albumListViewModel.allAlbumNames()
        artistNames = self.albumListViewModel.allArtistNames()
        buttonStatus = self.albumListViewModel.allButtonStatus()
        favIndi = self.albumListViewModel.getAllIndex
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.albumTableView)
        self.albumTableView.bindToSuperView(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}

extension FavsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artistNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavsCell.reuseId, for: indexPath) as? FavsCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .black
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        cell.favoriteLabel.textColor = .white
        cell.titleLabel.text = "Album: " + self.albumNames[indexPath.row]
        cell.titleLabel.textColor = .white
        cell.artistLabel.text = "Artist: " + self.artistNames[indexPath.row]
        cell.artistLabel.textColor = .white
        print(self.albumListViewModel.allAlbumNames())
        print(self.albumListViewModel.getAllIndex)
        
        if (self.albumListViewModel.buttonStatus(index: self.albumListViewModel.getAllIndex[indexPath.row]) != 0){
            cell.addFavButton.setImage(UIImage(named: "favorite"), for: [])
        }
            
        if (self.albumListViewModel.buttonStatus(index: self.albumListViewModel.getAllIndex[indexPath.row]) == 1) {
            cell.addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
        }
                             
        cell.buttonClickedAction = { [] in
            var hasChanged = 0
            if (self.albumListViewModel.buttonStatus(index: self.albumListViewModel.getAllIndex[indexPath.row]) == 0){
                cell.addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
                self.albumListViewModel.changeButtonStatus(index: self.favIndi[indexPath.row])
                hasChanged += 1
                self.albumListViewModel.makeFavorited(index: self.albumListViewModel.getAllIndex[indexPath.row])
                print(self.albumListViewModel.allAlbumNames())
                print(self.albumListViewModel.getAllIndex)
                
            }
            if (self.albumListViewModel.buttonStatus(index: self.albumListViewModel.getAllIndex[indexPath.row]) == 1 && hasChanged == 0) {
                cell.addFavButton.setImage(UIImage(named: "favorite"), for: [])
                self.albumListViewModel.changeButtonStatus(index: self.favIndi[indexPath.row])
                self.albumListViewModel.removeFavorite(name: self.albumListViewModel.artistName(index: self.albumListViewModel.getAllIndex[indexPath.row]) ?? "whatever")
                print(self.albumListViewModel.allAlbumNames())
                print(self.albumListViewModel.getAllIndex)
            }
        }
        
        self.albumListViewModel.imageData(index: self.albumListViewModel.getAllIndex[indexPath.row]) { data in
            if let data = data {
                DispatchQueue.main.async {
                    cell.albumImageView.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
}

extension FavsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.albumListViewModel.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.albumListViewModel.getAlbums()
    }
}

extension FavsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier:  "DetailViewController") as? DetailViewController else { return }
        vc.artistNameLabel.text = self.albumListViewModel.artistName(index: self.albumListViewModel.getAllIndex[indexPath.row]) ?? ""
        vc.albumNameLabel.text = self.albumListViewModel.albumTitle(index: self.albumListViewModel.getAllIndex[indexPath.row]) ?? ""
        vc.albumGenre.text = self.albumListViewModel.albumGenre(index: self.albumListViewModel.getAllIndex[indexPath.row]) ?? ""
        
        self.albumListViewModel.imageData(index: self.albumListViewModel.getAllIndex[indexPath.row]) { data in
            if let data = data {
                DispatchQueue.main.async {
                    vc.albumImage.image = UIImage(data: data)
                }
            }
        }
        vc.dateReleased.text = self.albumListViewModel.dateReleased(index: self.albumListViewModel.getAllIndex[indexPath.row])
        vc.buttonStatus = self.albumListViewModel.buttonStatus(index: self.albumListViewModel.getAllIndex[indexPath.row])
        vc.albumListViewModel = self.albumListViewModel as? AlbumListViewModel ?? AlbumListViewModel()
        vc.indexed = self.albumListViewModel.getAllIndex[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
}
