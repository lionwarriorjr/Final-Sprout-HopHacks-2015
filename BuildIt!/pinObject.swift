//
//  pinObject.swift
//  BuildIt!
//
//  Created by Srihari Mohan on 9/12/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class pinObject: NSObject, MKAnnotation {
    var title: String
    var region: String
    var pinType: String
    var coordinate: CLLocationCoordinate2D
    var pinDescription: String
    var baseImage: UIImage
    
    static let TitleKey = "TitleKey"
    static let RegionKey = "RegionKey"
    static let PinKey = "PinKey"
    static let CoordinateKey = "CoordinateKey"
    static let DescriptionKey = "DescriptionKey"
    
    init(title: String, region: String, pinType: String, coordinate: CLLocationCoordinate2D, pinDescription: String, baseImage: UIImage) {
        self.title = title
        self.region = region
        self.pinType = pinType
        self.coordinate = coordinate
        self.pinDescription = pinDescription
        self.baseImage = baseImage
        
        super.init()
    }
    
    var subtitle: String {
        return self.region;
    }
    
    func color_pins() -> MKPinAnnotationColor {
        switch (self.pinType) {
        case "Clinic": return .Red;
        default: return .Green;
        }
    }
    
    static func localPinData() -> [pinObject] {
        return [
            pinObject(title: "Baiwala", region: "Sierra Leone", pinType: "Village", coordinate: CLLocationCoordinate2D(latitude:7,longitude:12), pinDescription: "", baseImage: UIImage(named: "balaira")!), pinObject(title: "Malema", region: "Sierra Leone", pinType: "Village", coordinate: CLLocationCoordinate2D(latitude:7,longitude:14), pinDescription: "", baseImage: UIImage(named: "bomaru")!), pinObject(title: "Dodo", region: "Sierra Leone", pinType: "Village", coordinate: CLLocationCoordinate2D(latitude:8,longitude:13), pinDescription: "", baseImage: UIImage(named: "dodo")!), pinObject(title: "Bomaru", region: "Sierra Leone", pinType: "Village", coordinate: CLLocationCoordinate2D(latitude:8,longitude:14), pinDescription: "", baseImage: UIImage(named: "malema")!), pinObject(title: "S.L. Clinic", region: "Sierra Leone", pinType: "Clinic", coordinate: CLLocationCoordinate2D(latitude:9,longitude:14), pinDescription: "", baseImage: UIImage(named: "clinic")!)
        ];
    }
    
    static func populationDictionary() -> [[String : Int]] {
        return [["sierra leone" : 50230]];
    }
}


