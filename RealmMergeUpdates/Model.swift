//
//  Model.swift
//  RealmMergeUpdates
//
//  Created by Craig Siemens on 2017-06-06.
//  Copyright © 2017 Craig Siemens. All rights reserved.
//

import Foundation
import RealmSwift

class Model: Object {
    dynamic var number: Int = 0
    
    convenience init(number: Int) {
        self.init()
        self.number = number
    }
}
