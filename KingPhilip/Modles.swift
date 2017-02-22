//
//  Modles.swift
//  KingPhilip
//
//  Created by Andrew Rivard on 1/10/17.
//  Copyright © 2017 Andrew Rivard. All rights reserved.
//

import UIKit

//Creates a NSObject IconCatigory with param name and icons.
class IconCategory: NSObject {
    
    var name: String?
    var icons: [Icon]?
    
    /// Creates and fills all icon categories from XML data loaded from external host.
    ///
    /// - Returns: An array of IconCategories
    static func loadCategories() -> [IconCategory] {
        
        //Array of all Categories and Icons in them
        var iconCategories = [IconCategory]()
        
        /// Creates a category and adds it to iconCategory arrayList.
        ///
        /// - Parameter name: Name of the category being created
        /// - Returns: Created IconCategory
        func createCategory(name:String) -> IconCategory{
            let category = IconCategory()
            category.name = name
            let categoryIcons = [Icon]()
            category.icons = categoryIcons
            iconCategories.append(category)
            return category
        }
        
        //Gets all icons in XML file
        let allIcons = Paser().XMLIconData()
        
        //Loops through all icons
        for icon in allIcons{
            //Int value of how many times currentIcon has a category that is in iconCategories
            var categoryMatchCount = 0
            //Loops through all categories in iconCategories
            for catigories in iconCategories {
               //Adds icon to array of icons in given category if category name matches the icon's category
                if catigories.name == icon.iconCategory {
                    catigories.icons?.append(icon)
                    categoryMatchCount += 1
                }
            }
            //If this passes it means the category does not exist yet, so it makes it and adds the icon to the category's array of icons
            if categoryMatchCount == 0 {
                createCategory(name: icon.iconCategory!).icons?.append(icon)
            }
        }
        return iconCategories
    }
    
}

//Creates new NSObject Icon with params for an id (to send to correct page on tap) a name and an image name
class Icon: NSObject {
    
    var icon: String?
    var id: String?
    var imageName: String?
    var iconCategory: String?
    

    /// - Returns: Icon as a String
    func toString() -> String{
        return "icon: \(icon) id: \(id) imageName \(imageName) iconCategory \(iconCategory)"
    }
}

//Creates new NSObject for MessageCategory
class MessageCategory: NSObject {
    
    //Name of messages and all messages
    var name: String?
    var messages: [Message]?
    
    /// Creates and fills an announcments catagory from XML data loaded from external host.
    /// Announcements are used for horizontal scrolling format messages.
    ///
    /// - Returns: Instance of AnnouncmentCategorie
    static func loadAnnouncmentsCategory() -> MessageCategory {
        
        //Creates an MessageCategory for all anouncments
        let announcmentCategory = MessageCategory()
        
        //Sets name and creates list of Announcment
        announcmentCategory.name = "Announcement"
        var announcmentsList = [Message]()
        
        //Gets all icons in XML file
        let rawAnnouncments = Paser().XMLAnnouncmentData()
        announcmentsList = rawAnnouncments
        //Sets list of announcments = to announcments in announcmentList
        announcmentCategory.messages = announcmentsList
        
        return announcmentCategory
    }
    
    /// Creates and fills an announcments catagory from XML data loaded from external host.
    ///
    /// - Parameters:
    ///   - name: Title of all messages
    ///   - messages: Array of messages
    /// - Returns: Instance of AnnouncmentCategorie
    static func loadMessageCategory(name:String, messages: [Message]) -> MessageCategory {
        
        //Creates a MessageCategory
        let messageCategory = MessageCategory()
        
        //Sets name of the MessageCategory and adds messages to it
        messageCategory.name = name
        messageCategory.messages = messages
        
        return messageCategory
    }

}

//Creates new NSObject Message with arams for a header and discription
class Message: NSObject {
    var header: String?
    var descrip: String?
}


//NSObject for day, holds date and letter day
class Day: NSObject {
    
    var day: String?
    var date: String?
    
    func toString() -> String{
        return "Date: \(date) Day: \(day)"
    }
}
