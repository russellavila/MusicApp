//
//  FavsCell.swift
//  TopFavs
//
//  Created by Consultant on 5/21/22.
//

import UIKit

class FavsCell: UITableViewCell {

    static let reuseId = "\(FavsCell.self)"
    
    var buttonClickedAction : (() -> ())?
    var buttonStatus = 0

    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var addFavButton: UIButton = {
        let buttonView = UIButton(frame: .zero)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.contentMode = .scaleAspectFit
        
        if (buttonStatus == 0){
        buttonView.setImage(UIImage(named: "favorite"), for: [])
        }
        if (buttonStatus == 1){
        buttonView.setImage(UIImage(named: "selectedFav"), for: [])
        }
        buttonView.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return buttonView
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Add to favorites!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        self.contentView.addSubview(self.albumImageView)
        self.contentView.addSubview(self.addFavButton)
        
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        
        let favStackView = UIStackView(frame: .zero)
        favStackView.translatesAutoresizingMaskIntoConstraints = false
        favStackView.axis = .horizontal
        favStackView.spacing = 8
        favStackView.alignment = .center
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        favStackView.addArrangedSubview(self.addFavButton)
        favStackView.addArrangedSubview(self.favoriteLabel)
        
        stackView.addArrangedSubview(topBuffer)
        stackView.addArrangedSubview(self.albumImageView)
        stackView.addArrangedSubview(self.artistLabel)
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(favStackView)
        stackView.addArrangedSubview(bottomBuffer)
        
        self.contentView.addSubview(stackView)
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 4
        
        stackView.bindToSuperView(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.albumImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.albumImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.addFavButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.addFavButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        self.albumImageView.image = nil
        if (buttonStatus == 0){
        addFavButton.setImage(UIImage(named: "favorite"), for: [])
        }
        if (buttonStatus == 1){
        addFavButton.setImage(UIImage(named: "selectedFav"), for: [])
        }
        self.titleLabel.text = nil
        self.artistLabel.text = nil
    }
    
    @objc func buttonAction(_ sender: UIButton){
        buttonClickedAction?()
    }
}
