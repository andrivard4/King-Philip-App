//
//  CategoryCell.swift
//  KingPhilip.
//
//  Created by Andrew Rivard on 1/7/17.
//  Copyright © 2017 Andrew Rivard. All rights reserved.
//

import UIKit

//This is tthe vertical cell that gets put in the main page. Each Category cell has a name, a collection view for icons, banners or announcements
//and a divider line to seperate each section.
class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //Initilizer variables and onstructors
    var iconsController: mainController?
    var announcmentsController: mainController?
    var iconCategory: IconCategory? {
        didSet {
            //Sets nameLabel to the name of iconCategory
            if let name = iconCategory?.name {
                nameLabel.text = name
            }
            
        }
    }
    var announcmentsCategory: MessageCategory? {
        didSet {
            //Sets nameLabel to the name of announcmentsCategory
            if let name = announcmentsCategory?.name {
                nameLabel.text = name
            }
        }
    }
    //Registering cell
    private let cellID = "cellID"
    
    //Required for creating a view
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been inplemenmted")
    }
    
    //Creates UILabel for a category name
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Creates a UICollectionView for holding all Icons, Announcements, or Banners
    let sideCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    //Creates UIView for a divider line
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Sets up the compleated view of a vertical cell.
    func setupViews() {
        backgroundColor = UIColor.clear
        
        addSubview(sideCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        sideCollectionView.dataSource = self
        sideCollectionView.delegate = self
        
        sideCollectionView.register(IconCell.self, forCellWithReuseIdentifier: cellID)
        
        //Sets all horizontal constraints
        //Vertical constraints will be set in subclasses
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sideCollectionView]))
        
    }
    //Sets number of cells when icon
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = iconCategory?.icons?.count {
            return count
        }
        return 0
    }
    //sets cell content when icons
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! IconCell
        cell.icon = iconCategory?.icons?[indexPath.item]
        return cell
    }
    //Sets size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if iconCategory?.name == "" {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    //Calls action function when something is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let icon = iconCategory?.icons?[indexPath.item] {
            iconsController?.showIconDetailForIcon(icon: icon)
        }
        if (announcmentsCategory?.messages?[indexPath.item]) != nil {
            announcmentsController?.showAnnouncements(announcements: announcmentsCategory!)
        }
    }
    
}

//Icon Cell to go in the slideControllerView for icons
class IconCell: UICollectionViewCell {
    
    //Initilizer and constructor for IconCell
    var icon:Icon? {
        didSet {
            //Sets name label
            name.text = icon?.icon
            //Gets image name, loads it online and sets it as imageView, if cannot load URL, uses default Header or Icon
            let imageName = icon?.imageName
            
            if (icon?.iconCategory == "") {
                if (imageName?.contains("http://"))! || (imageName?.contains("https://"))!{
                    let url = URL(string: imageName!)
                    let data = try? Data(contentsOf: url!)
                    imageView.image = UIImage(data: data!)
                }
                else {
                    imageView.image = UIImage(named: "Header")
                }
            }
            else {
                if (imageName?.contains("http://"))! || (imageName?.contains("https://"))!{
                    let url = URL(string: imageName!)
                    let data = try? Data(contentsOf: url!)
                    imageView.image = UIImage(data: data!)
                }
                else {
                    imageView.image = UIImage(named: "Icon")
                }
            }
            
        }
    }
    //For creating view...
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been inplemenmted")
    }
    //Creates needed Views
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    let name : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //Adds subviews
    func setupViews() {
        
        addSubview(imageView)
        addSubview(name)
        //Sets constrainst in a diffrent way, this just fills the frame (the current cell)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        name.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
    }
}

//Cell for messages (Used for Announcements also
class MessageCell: UICollectionViewCell{
    //Sets header and content
    var message:Message? {
        didSet {
            header.text = message?.header
            content.text = message?.descrip
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been inplemenmted")
    }
    
    //Creates UILabels
    let content : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let header : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    func setupViews() {
        addSubview(header)
        addSubview(content)
        header.frame = CGRect(x:20 , y: 25, width: frame.width-40, height: header.font.pointSize)
        content.frame = CGRect(x:20, y:25 + header.font.pointSize , width: frame.width-40, height: frame.height-25-header.font.pointSize * 2)
    }
}
