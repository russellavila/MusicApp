//
//  DetailViewController.swift
//  TopFavs
//
//  Created by Consultant on 5/15/22.
//

import UIKit

class DetailViewController : UIViewController {
    
    var buttonStatus = 0
    var indexed = 0
    var albumListViewModel = AlbumListViewModel()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some Name"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some Name"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var albumImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var albumGenre: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some Name"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateReleased: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some Name"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
        }()
    
    lazy var contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
    }()
    
    lazy var addFavButton: UIButton = {
        let buttonView = UIButton(frame: .zero)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.contentMode = .scaleAspectFit
        
        if (buttonStatus == 0){
        buttonView.setImage(UIImage(named: "inverseFav"), for: [])
        }
        if (buttonStatus == 1){
        buttonView.setImage(UIImage(named: "selectedFav"), for: [])
        }
        buttonView.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return buttonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.setUpUI()
    }
    
    private func setUpUI() {
        
        if (buttonStatus == 0){
        addFavButton.setImage(UIImage(named: "inverseFav"), for: [])
        }
        if (buttonStatus == 1){
        addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
        }
        
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .center
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        view.addSubview(scrollView)
                
        scrollView.addSubview(contentView)
                
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.artistNameLabel)
        vStack.addArrangedSubview(self.albumImage)
        vStack.addArrangedSubview(self.albumNameLabel)
        vStack.addArrangedSubview(self.dateReleased)
        vStack.addArrangedSubview(self.albumGenre)
        vStack.addArrangedSubview(self.addFavButton)
        vStack.addArrangedSubview(bottomBuffer)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
    }
    
    @objc func buttonAction(_ sender: UIButton){
        var hasChanged = 0
        if (buttonStatus == 0){
            addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
            buttonStatus = 1
            hasChanged += 1
            self.albumListViewModel.changeButtonStatus(index: indexed)
            self.albumListViewModel.makeFavorited(index: indexed)
            self.albumListViewModel.addIndex(index: indexed)
        }
        if (buttonStatus == 1 && hasChanged == 0){
            addFavButton.setImage(UIImage(named: "inverseFav"), for: [])
            buttonStatus = 0
            self.albumListViewModel.changeButtonStatus(index: indexed)
            self.albumListViewModel.removeFavorite(name: artistNameLabel.text ?? "whatever")
            self.albumListViewModel.removeIndex(index: indexed)
        }
    }
}
