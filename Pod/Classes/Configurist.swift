//
//  Configurist.swift
//  Configurist
//
//  Created by Alyona on 11/16/15.
//  Copyright © 2015 Alyona Bachurina. All rights reserved.
//

import Foundation
import UIKit


/*
Intended to manage plist and json configuration files.
*/

open class Configurist: NSObject {
    
    fileprivate var configuration:[String:AnyObject] = [:]
    
    public init(names:[String], bundle: Bundle = Bundle(for: Configurist.self)) {
        super.init()
        for name in names {

            let plist = bundle.path(forResource: name, ofType: "plist")
            let json = bundle.path(forResource: name, ofType: "json")

            let fileManager = FileManager.default

            var data:Data?
            if let path = plist {
                data = fileManager.contents(atPath: path)
            }else if let path = json {
                data = fileManager.contents(atPath: path)
            }else{
                print("Configuration file \(name) not found.")
            }
            
            if let data = data {
                do{
                    var config:[String:AnyObject]?
                    if(plist != nil){
                        config = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions(), format: nil) as? [String:AnyObject]
                    }else if (json != nil){
                        config = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:AnyObject]
                    }
                    
                    if let config = config {
                        for key in config.keys {
                            configuration[key] = config[key]
                        }
                    }
                    
                }catch let error as NSError{
                    print("Failed to parse configuration \(name): \(error.description)")
                }
            
            }
        }
    }
    
    open func string(_ key:String) -> String{
        assertReadingOfType(key, type: String.self)
        return configuration[key] as! String
    }
    
    open func array(_ key:String) -> [AnyObject]{
        assertReadingOfType(key, type: [AnyObject].self)
        return configuration[key] as! [AnyObject]
    }
    
    open func number(_ key:String) -> NSNumber {
        assertReadingOfType(key, type: NSNumber.self)
        return configuration[key] as! NSNumber
    }
    
    open func dictionary(_ key:String) -> [String:AnyObject] {
        assertReadingOfType(key, type: [String:AnyObject].self)
        return configuration[key] as! [String:AnyObject]
    }
    
    open func colorRGBA(_ key:String) -> UIColor {
        let baseValue = parseHex(string(key))
        let red = (CGFloat)((baseValue >> 24) & 0xFF)/255.0
        let green = (CGFloat)((baseValue >> 16) & 0xFF)/255.0
        let blue = (CGFloat)((baseValue >> 8) & 0xFF)/255.0
        let alpha = (CGFloat)((baseValue >> 0) & 0xFF)/255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    open func colorRGB(_ key:String) -> UIColor {
        let baseValue = parseHex(string(key))
        let red = (CGFloat)((baseValue >> 16) & 0xFF)/255.0
        let green = (CGFloat)((baseValue >> 8) & 0xFF)/255.0
        let blue = (CGFloat)(baseValue & 0xFF)/255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
    
    fileprivate func parseHex(_ hexString:String) ->UInt32{
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var baseValue = UInt32()
        Scanner(string: hex).scanHexInt32(&baseValue)
        return baseValue
    }
    
    fileprivate func assertReadingOfType<T>(_ key:String, type: T){
        assert( (configuration[key] as? T) == nil , "Failed to read configuration value of type \(type) for key \(key)")
    }
}
