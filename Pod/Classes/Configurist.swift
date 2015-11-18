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

class Configurist: NSObject {
    
    private var configuration:[String:AnyObject] = [:]
    
    init(names:[String], bundle: NSBundle = NSBundle(forClass: Configurist.self)) {
        super.init()
        for name in names {

            let plist = bundle.pathForResource(name, ofType: "plist")
            let json = bundle.pathForResource(name, ofType: "json")

            let fileManager = NSFileManager.defaultManager()

            var data:NSData?
            if let path = plist {
                data = fileManager.contentsAtPath(path)
            }else if let path = json {
                data = fileManager.contentsAtPath(path)
            }else{
                print("Configuration file \(name) not found.")
            }
            
            if let data = data {
                do{
                    var config:[String:AnyObject]?
                    if(plist != nil){
                        config = try NSPropertyListSerialization.propertyListWithData(data, options: .Immutable, format: nil) as? [String:AnyObject]
                    }else if (json != nil){
                        config = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? [String:AnyObject]
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
    
    func string(key:String) -> String{
        assertReadingOfType(key, type: String.self)
        return configuration[key] as! String
    }
    
    func array(key:String) -> [AnyObject]{
        assertReadingOfType(key, type: [AnyObject].self)
        return configuration[key] as! [AnyObject]
    }
    
    func number(key:String) -> NSNumber {
        assertReadingOfType(key, type: NSNumber.self)
        return configuration[key] as! NSNumber
    }
    
    func dictionary(key:String) -> [String:AnyObject] {
        assertReadingOfType(key, type: NSNumber.self)
        return configuration[key] as! [String:AnyObject]
    }
    
    func colorRGBA(key:String) -> UIColor {       
        let baseValue = parseHex(string(key))
        let red = (CGFloat)((baseValue >> 24) & 0xFF)/255.0
        let green = (CGFloat)((baseValue >> 16) & 0xFF)/255.0
        let blue = (CGFloat)((baseValue >> 8) & 0xFF)/255.0
        let alpha = (CGFloat)((baseValue >> 0) & 0xFF)/255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func colorRGB(key:String) -> UIColor {
        let baseValue = parseHex(string(key))
        let red = (CGFloat)((baseValue >> 16) & 0xFF)/255.0
        let green = (CGFloat)((baseValue >> 8) & 0xFF)/255.0
        let blue = (CGFloat)(baseValue & 0xFF)/255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
    
    private func parseHex(hexString:String) ->UInt32{
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var baseValue = UInt32()
        NSScanner(string: hex).scanHexInt(&baseValue)
        return baseValue
    }
    
    private func assertReadingOfType<T>(key:String, type: T){
        assert( (configuration[key] as? T) == nil , "Failed to read configuration value of type \(type) for key \(key)")
    }
}
