//
//  test.swift
//  Daleel
//
//  Created by 杨鹏 on 2024/3/21.
//

import Foundation

@objcMembers class test: NSObject {

    var address : String
    var gender: String
   
    init(address:String,gender:String){
        self.address = address
        self.gender = gender
    }
   
    func method() {
        print("message \(self.address + self.gender)")
    }
}
