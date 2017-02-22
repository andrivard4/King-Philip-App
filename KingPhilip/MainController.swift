//
//  ViewController.swift
//  KingPhilip.
//
//  Created by Andrew Rivard on 1/7/17.
//  Copyright © 2017 Andrew Rivard. All rights reserved.
//

import UIKit
import SafariServices

class mainController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    
    //All IDs for cell registration
    private let cellID = "cellId"
    private let headerID = "headerId"
    private let annoucnemntsID = "announcmentsCellId"
    private let FooterID = "FooterID"
    
    //Holds all Categories, such as School, banners, and Announcements
    var mainCategories: [NSObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets navbar name
        navigationItem.title = "King Philip"
        
        //Populates mainCatagories array with all categories
        mainCategories = IconCategory.loadCategories()
        //Checks to see if no other categories where loaded
        if ((mainCategories?.count)! > 1) {
            //inserts announcements as 2nd category
            mainCategories?.insert(MessageCategory.loadAnnouncmentsCategory(), at: 1)
        }
        
        //Sets background color (change if dark-mode is implemented) & registers cells (don't change that)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(IconCategoryCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(Banner.self, forCellWithReuseIdentifier: headerID)
        collectionView?.register(AnnouncementsCategoryCell.self, forCellWithReuseIdentifier: annoucnemntsID)
        collectionView?.register(MainFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FooterID)
    }
    
    
    /// Opens link in SafariView
    ///
    /// - Parameter link: link to open in SafariView
    func openLink (_ link:String){
        let url = URL(string: link)!
        let svc = SFSafariViewController(url: url)
        svc.delegate = self
        svc.preferredControlTintColor = self.view.tintColor
        self.present(svc, animated:true, completion: nil)
    }
    
    /// When an icon or banner is tapped, an action will be acted on it.
    /// This action varies depending on the icon's actionID, it may open another page, or open a SafariView.
    ///
    /// - Parameter icon: This is the icon or banner that gets tapped.
    func showIconDetailForIcon(icon: Icon) {
        let layout = UICollectionViewFlowLayout()
        var viewController = ClassDetailController(collectionViewLayout: layout)
        
        if (icon.id!.contains("http://")) || (icon.id!.contains("https://")){
            openLink(icon.id!)
            return
        }
        
        if(icon.id == "QR"){
            
        }
        else if icon.id == "0"{
            viewController = ClassDetailController(collectionViewLayout: layout)
            viewController.icon = icon
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    ///When announcements are tapped, a page is opened with all announcements in a vertical scroll format.
    ///This is good if an announcement is too long for the view in the horizontal scroll so it gets cut off.
    ///
    /// - Parameter announcements: Will be all the announcements in the category that is tapped.
    func showAnnouncements(announcements: MessageCategory) {
        let layout = UICollectionViewFlowLayout()
        let viewController = MessageController(collectionViewLayout: layout)
        viewController.messages = announcements
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    //Populates each cell in the UICollevtionView, these are the vertical cells, not the horizontal ones full of icons and banners.
    //TODO: Instead of assuming index positions are specific types, check their instance first.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Fills cell with bannerCells
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerID, for: indexPath) as! Banner
            cell.iconCategory = mainCategories?[indexPath.item] as! IconCategory?
            cell.iconsController = self
            return cell
        }
        //Fills cell with MessageCell
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: annoucnemntsID, for: indexPath) as! AnnouncementsCategoryCell
            cell.announcmentsCategory = mainCategories?[1] as! MessageCategory?
            cell.announcmentsController = self
            return cell
        //Fills cell with iconCell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! IconCategoryCell
            cell.iconCategory = mainCategories?[indexPath.item] as! IconCategory?
            cell.iconsController = self
            return cell
        }
    }
    
    //Sets the number of cells in the vertical collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = mainCategories?.count {
            return count
        }
        return 0
    }
    
    //Sets size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            //Size for banners cell
            return CGSize(width: view.frame.width, height: view.frame.height * 0.3)
        }
        else if indexPath.item == 1 {
            //Size for anouncements cell
            return CGSize(width: view.frame.width, height: view.frame.height * 0.35)
        }
        //Sets size of remainding cells
        return CGSize(width: view.frame.width, height: 185)
    }
    
    //Creates a footer for collectionview
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterID, for: indexPath) as! MainFooter
        return footer
    }
    
    //Sets size of the footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.3)
    }
    
}

///Contains all info for banners, extends CatagoryCell
class Banner: CategoryCell {
    //For cell registration
    let cellId = "bannerCellId"
    
    //Creates collection of horizontal cells that gets put into one of the vertical cells in the main CollectionView
    override func setupViews() {
        //Uses methods below this one to define what is in each cell, how many cells, and the size of each cell.
        sideCollectionView.dataSource = self
        sideCollectionView.delegate = self
        //Registers cells
        sideCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: cellId)
        //Adds subview slideCollectionView
        addSubview(sideCollectionView)
        //Adds constraints to slideCollectionView
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sideCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sideCollectionView]))
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //Fills each cell with icons in the iconCategory passed to it.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IconCell
        cell.icon = iconCategory?.icons?[indexPath.item]
        return cell
    }
    //Sets height and width of each cell to the height and width of the cell that cell is in (This allows the cell to take the full top to make it "banner like"
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    ///Subclass of IconCell that gets passed so that banner cells do not have a title or a category. This is because Banners are only images
    private class BannerCell: IconCell {
        //Overrides setupViews() in IconCell. This just adds an image to a cell.
        override func setupViews() {
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            imageView.layer.borderWidth = 0.5
            imageView.layer.cornerRadius = 0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        }
    }
}

//This creates all cells for announcements on the main page
class AnnouncementsCategoryCell: CategoryCell{
    //Registration ID
    let cellId = "announcementsID"
    //Gets all days from XML file
    let days = Paser().XMLDayData()
    
    /// Gets the date in M-d format
    ///
    /// - Parameter addDay: Optional parameter for adding x days to the date
    /// - Returns: Date with x days added
    func getDate(addDay: Int = 0) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-d"
        let date = dateFormatter.string(from: Date().addingTimeInterval(TimeInterval(addDay * 86400)))
        return date
    }
    
    /// Gets the time of day in 24 hour format with only the hour, rounding down.
    ///
    /// - Parameter addHour: Optional param that adds x hours to the time
    /// - Returns: Hour time of day with x hours added
    func getTime(addHour: Int = 0) -> Int {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H"
        let time = Int(timeFormatter.string(from: Date().addingTimeInterval(TimeInterval(addHour * 3600))))
        return time!
    }
    //Overrides CategoryCell's setupViews() to add content
    override func setupViews() {
        //Calls setupViews() in the CategoryCell class
        super.setupViews()
        //Creates a UILabel to show the letter day
        let dayLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        //Shows scroll indicator, overriding in superclass
        sideCollectionView.showsHorizontalScrollIndicator = true
        sideCollectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //Checks if time is between 12AM and 3PM
        if (getTime() >= 0 && getTime() < 15) {
            for day in days{
                if(getDate() == day.date){
                    if let currentday = day.day{
                        //Sets dayLabel to say the current letter's day/
                        dayLabel.text = "Today is \(currentday) day."
                    }
                    //Stops the loop when a match is found
                    break
                } else {
                    //If no date found, no school
                    dayLabel.text = "No school today."
                }
            }
            //Same as above with times between 3PM and 1AM. Difference is it will say tomorrow's information
        } else {
            for day in days{
                if(getDate(addDay: 1) == day.date){
                    if let currentday = day.day{
                        dayLabel.text = "Tomorrow is \(currentday) day."
                    }
                    break
                } else {
                    dayLabel.text = "No school tomorrow."
                }
            }
        }
        
        //Centers text and addsSubview
        dayLabel.textAlignment = .center
        addSubview(dayLabel)
        
        //Adds all constraints, this includes the vertical constraints in the superclass to account for the new dayLabel subview
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dayLabel]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel][v0][dayLabel]-10-[v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sideCollectionView, "v1": dividerLineView, "nameLabel": nameLabel, "dayLabel": dayLabel]))
        
    }
    
    //# of cells = count of announcements
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = announcmentsCategory?.messages?.count {
            return count
        }
        return 0
    }
    //Fills each cell with content
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.message = announcmentsCategory?.messages?[indexPath.item]
        return cell
    }
    //Sets height of each cell
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height*0.9)
    }
    //I don't remember.............
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

//CategoryCells for all Icons
class IconCategoryCell:CategoryCell {
    override func setupViews() {
        super.setupViews()
        //This is needed because it is not added in the CategoryCell class. This is because of the added label in the AnnouncementsCategoryCell class and how it isn't part of this class.
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(30)][v0][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sideCollectionView, "v1": dividerLineView, "nameLabel": nameLabel]))
    }
}

//Creates the MainFooter
class MainFooter: UICollectionViewCell{
    
    //Sets up the view
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///TODO: add something useful to the footer...
    let background: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.init(displayP3Red: 0, green: 0.5, blue: 0, alpha: 1)
        return bg
    }()
    
    func setupViews() {
        addSubview(background)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": background]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": background]))
        
    }
}
