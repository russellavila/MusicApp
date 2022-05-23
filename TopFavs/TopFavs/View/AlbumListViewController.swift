//
//  ViewController.swift
//  TopFavs
//
//  Created by Consultant on 5/12/22.
//
import UIKit

class AlbumListViewController: UIViewController {
    
    lazy var albumTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reuseId)
        return table
    }()
    
    var albumListViewModel: AlbumListViewModelType
    
    init(viewModel: AlbumListViewModelType) {
        self.albumListViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setUpUI()
        
        self.albumListViewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.albumTableView.reloadData()
            }
        }
        self.albumListViewModel.getAlbums()
        
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
        self.albumListViewModel.getAlbums()
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.albumTableView)
        self.albumTableView.bindToSuperView(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}

extension AlbumListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.reuseId, for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = self.albumListViewModel.albumTitle(index: indexPath.row)
        cell.artistLabel.text = self.albumListViewModel.artistName(index: indexPath.row)
            
        if (self.albumListViewModel.buttonStatus(index: indexPath.row) == 0){
            cell.addFavButton.setImage(UIImage(named: "inverseFav"), for: [])
        }
            
        if (self.albumListViewModel.buttonStatus(index: indexPath.row) == 1) {
            cell.addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
        }
                             
        cell.buttonClickedAction = { [] in
            var hasChanged = 0
            if (self.albumListViewModel.buttonStatus(index: indexPath.row) == 0){
                cell.addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
                self.albumListViewModel.changeButtonStatus(index: indexPath.row)
                hasChanged += 1
                self.albumListViewModel.makeFavorited(index: indexPath.row)
                self.albumListViewModel.addIndex(index: indexPath.row)
                print(self.albumListViewModel.getAllIndex)
                print(self.albumListViewModel.allAlbumNames())
            }
            if (self.albumListViewModel.buttonStatus(index: indexPath.row) == 1 && hasChanged == 0) {
                cell.addFavButton.setImage(UIImage(named: "inverseFav"), for: [])
                self.albumListViewModel.changeButtonStatus(index: indexPath.row)
                self.albumListViewModel.removeFavorite(name: self.albumListViewModel.artistName(index: indexPath.row) ?? "whatever")
                self.albumListViewModel.removeIndex(index: indexPath.row)
                print(self.albumListViewModel.getAllIndex)
                print(self.albumListViewModel.allAlbumNames())
            }
        }
        
        self.albumListViewModel.imageData(index: indexPath.row) { data in
            if let data = data {
                DispatchQueue.main.async {
                    cell.albumImageView.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
}

extension AlbumListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.albumListViewModel.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.albumListViewModel.getAlbums()
    }
}

extension AlbumListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier:  "DetailViewController") as? DetailViewController else { return }
        vc.artistNameLabel.text = self.albumListViewModel.artistName(index: indexPath.row) ?? ""
        vc.albumNameLabel.text = self.albumListViewModel.albumTitle(index: indexPath.row) ?? ""
        vc.albumGenre.text = self.albumListViewModel.albumGenre(index: indexPath.row) ?? ""
        
        self.albumListViewModel.imageData(index: indexPath.row) { data in
            if let data = data {
                DispatchQueue.main.async {
                    vc.albumImage.image = UIImage(data: data)
                }
            }
        }
        vc.dateReleased.text = self.albumListViewModel.dateReleased(index: indexPath.row)
        vc.buttonStatus = self.albumListViewModel.buttonStatus(index: indexPath.row)
        vc.albumListViewModel = self.albumListViewModel as? AlbumListViewModel ?? AlbumListViewModel()
        vc.indexed = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
}
