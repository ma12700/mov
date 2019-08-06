//
//  Movies.swift
//  movies
//
//  Created by iOS Training on 8/4/19.
//  Copyright © 2019 iOS Training. All rights reserved.
//

import UIKit
import CoreData
@objc(Movies)
class Movies: NSManagedObject {
    @NSManaged var title:String
    @NSManaged var rating:Double
    @NSManaged var releaseYear:Int
    @NSManaged var image:NSData
    @NSManaged var genre:[String]
}
