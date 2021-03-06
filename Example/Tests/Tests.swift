//
//  ConfiguristTests.swift
//  ConfiguristTests
//
//  Created by Alyona on 11/16/15.
//  Copyright © 2015 Alyona Bachurina. All rights reserved.
//

import XCTest
@testable import Configurist

class Tests: XCTestCase {
    
    func testPlistConfiguration() {
        
        let c = Configurist(names: ["config_1", "config_2", "config_3"], bundle: Bundle(for: type(of: self)))
        
        testConfigurist(c)
        
    }
    
    func testJSONConfiguration() {
        
        let c = Configurist(names: ["config_1a", "config_2a", "config_3a"], bundle: Bundle(for: type(of: self)))
        
        testConfigurist(c)
        
    }
    
    func testConfigurist(_ c:Configurist){
        XCTAssertEqual(c.string("base.url"), "http://github.com")
        XCTAssertEqual(c.colorRGBA("color.red.rgba"), UIColor.red)
        XCTAssertEqual(c.colorRGB("color.red.rgb"), UIColor.red)
        XCTAssertEqual(c.number("magic.number"), 100500)
        XCTAssertEqual(c.array("array").count, 5)
        XCTAssertEqual( (c.array("array")[1] as! String) , "Italy")
        
        XCTAssertNotNil(c.dictionary("account"))
        XCTAssertNotNil(c.dictionary("account")["_id"] as? String)
        
        XCTAssertEqual(c.string("one.more.string"), "Some another string")
    }
    
}
