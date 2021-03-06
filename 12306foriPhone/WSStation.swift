//
//  WSStation.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

struct WSStation {
    //第一个字母
    var Initials: String
    //首字母拼音 比如 bj
    var FirstLetter:String
    //车站名
    var Name:String
    //电报码
    var Code:String
    //全拼
    var Spell:String
}

class WSStationNameJs {
    fileprivate static let sharedManager = WSStationNameJs()
    class var sharedInstance: WSStationNameJs {
        return sharedManager
    }
    
    var allStation: [WSStation]
    
    var allStationSectionMap: [String: [WSStation]]
    
    var allStationMap: [String: WSStation]
    
    var allInitials: [String]
    
    
    fileprivate init() {
        allStation = [WSStation]()
        allStationSectionMap = [String: [WSStation]]()
        allStationMap = [String: WSStation]()
        allInitials = [String]()
        
        let path = Bundle.main.path(forResource: "station_name", ofType: "js")
        let stationInfo = try! NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) as String
        
        if let matches = Regex("@[a-z]+\\|([^\\|]+)\\|([a-z]+)\\|([a-z]+)\\|([a-z]+)\\|").getMatches(stationInfo) {
            for match in matches {
                let FirstLetter: String = match[3]
                var Initials: String = ""
                if !FirstLetter.isEmpty {
                    Initials = FirstLetter.substring(to: FirstLetter.index(after: FirstLetter.startIndex)).uppercased()
                    if !allInitials.contains(Initials) {
                        allInitials.append(Initials)
                    }
                    let stationName = match[0]
                    let oneStation = WSStation(Initials:Initials, FirstLetter: match[3], Name: stationName, Code: match[1], Spell: match[2])
                    if self.allStationSectionMap[oneStation.Initials] != nil {
                        self.allStationSectionMap[oneStation.Initials]!.append(oneStation)
                    }else{
                        self.allStationSectionMap[oneStation.Initials] = [WSStation]()
                    }
                    self.allStationMap[stationName] = oneStation
                    self.allStation.append(oneStation)
                }
            }
        }
        allInitials.sort { return $0 < $1 }
    }
}
