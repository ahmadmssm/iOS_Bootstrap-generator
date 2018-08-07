//
//  Helpers.swift
//  Base project generator
//
//  Created by Ahmad Mahmoud on 8/2/18.
//  Copyright © 2018 Ahmad Mahmoud. All rights reserved.
//

import Foundation

class Helpers {
    
    private static let fileManager = FileManager.default

    private let projectName : String!
    
    init(projectNameString : String) {
        self.projectName = projectNameString
    }

    func getMacUserName() -> String {
        return NSFullUserName()
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func getProjectName() -> String {
        let projectName : String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        return projectName
    }
    
    func getCurrentYear() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return String(year)
    }
    
    func getUserDesktopPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let userDesktopDirectory = paths[0]
        return userDesktopDirectory
    }
    
    
    func getRootFolderPath() -> String {
        let path : String = getUserDesktopPath() + "/" + StaticVariables.appName + "/"
        return path
    }
    
    //
    func buildClassIHeaderText(className : String) -> String {
        let str : String =
            "//\n" +
                "//  " + className + "\n" +
                "//  " + projectName +
                "\n//\n" +
                "//  Created by " + getMacUserName() + " on " + getCurrentDate() + "." +
                "\n//  Copyright © " + getCurrentYear() + " " + getMacUserName() + "." + " All rights reserved." +
        "\n//\n\n"
        return str
    }
    
    func buildImportHeader() -> String {
        return "import iOS_Bootstrap" + "\n\n"
    }
    
}
