//
//  XML Parser.swift
//  KingPhilip
//
//  Created by Andrew Rivard on 1/12/17.
//  Copyright © 2017 Andrew Rivard. All rights reserved.
//

import AEXML

//This class is designed to host all XML pasering
class Paser {
    
    
    //Loading data for home screen layout
    public func XMLIconData() -> [Icon]{
        
        //Holds all Icons
        var icnDta = [Icon]()
        //Loads XML file
        guard
            let data = try? Data(contentsOf: URL(string: "http://andrivard4.dx.am/appIcons.xml")!) else {
                print("URL not defined properly(AppIcons)")
                //If fails, will return blank array
                return icnDta
        }
        do {
            //Setup for reading XML file
            let xmlDoc = try AEXMLDocument(xml: data, options: AEXMLOptions())
            var icon = Icon()
            
            //Loops through all Banners in the Header category, adds it to array
            if let header = xmlDoc.root["header"]["banner"].all {
                for item in header {
                    icon.icon = ""
                    icon.id = item.attributes["actionID"]
                    icon.imageName = item.attributes["imageURL"]
                    icon.iconCategory = ""
                    //Stores in array, then resets icon variable
                    icnDta.append(icon)
                    icon = Icon()
                }
            }
            
            //Loops through categories then items and adds all atributes to var icon type Icon
            if let categories = xmlDoc.root["category"].all {
                for category in categories {
                    if let items = category["item"].all {
                        for item in items {
                            icon.icon = item.attributes["name"]
                            icon.id = item.attributes["actionID"]
                            icon.imageName = item.attributes["imageURL"]
                            icon.iconCategory = category.attributes["name"]
                            //Stores in array, then resets icon variable
                            icnDta.append(icon)
                            icon = Icon()
                        }
                    }
                }
            }
        }
        catch {
            print("\(error)")
        }
        //Exit return, will return empty array
        return icnDta
    }
    
    
    public func XMLAnnouncmentData() -> [Message]{
        
        var announcmentData = [Message]()
        guard
            let dailyData = try? Data(contentsOf: URL(string: "http://annoucements-student-help-desk.kprhs.kingphilip.org/modules/groups/groupRss.php?gid=5240759")!) else {
                print("URL not defined properly(Announcements)")
                return announcmentData
        }
        
        //Daily Announcments
        do {
            let xmlDoc = try AEXMLDocument(xml: dailyData, options: AEXMLOptions())
            var announcment = Message()
            
            for info in xmlDoc.root["channel"]["item"].all! {
                let title = info.children[0].value!
                let content = info.children[2].value!
                announcment.header = title.stringByDecodingHTMLEntities.replacingOccurrences(of: "&#8203;", with: "").replacingOccurrences(of: "<br />", with: "")
                announcment.descrip = content.stringByDecodingHTMLEntities.replacingOccurrences(of: "&#8203;", with: "").replacingOccurrences(of: "<br />", with: "")
                announcmentData.append(announcment)
                announcment = Message()
            }
            
        } catch {
            print("\(error)")
        }
        return announcmentData
    }
    
    
    public func XMLDayData() -> [Day]{
        
        var days = [Day]()
        
        guard
            let xmlPath = Bundle.main.path(forResource: "day", ofType: "xml"),
            let dayData = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
            else {
                print("resource not found!(day)")
                return days
        }
        
        do {
            //loops through days A-G puts date with day
            for i in 0 ... 6{
                let letterDay = ["A", "B", "C", "D", "E", "F", "G"]
                
                let xmlDoc = try AEXMLDocument(xml: dayData, options: AEXMLOptions())
                
                if let dates = xmlDoc.root[letterDay[i]]["date"].all {
                    var day = Day()
                    
                    for date in dates {
                        day.day = letterDay[i]
                        day.date = date.value!
                        days.append(day)
                        day = Day()
                    }
                }
            }
        }
        catch {
            print("\(error)")
        }
        return days
    }
    
    //Start new paser here
    
}
