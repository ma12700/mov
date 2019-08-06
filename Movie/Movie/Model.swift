//
//  Model.swift
//  Movie
//
//  Created by iOS Training on 7/31/19.
//  Copyright © 2019 iOS Training. All rights reserved.
//

import Foundation
class Movie{
    let title:String
    let rating:Double
    let img:NSData
    let release:Int
    let genre:Array<String>
    init(title:String,rating:Double,img:NSData,release:Int,genre:Array<String>){
        self.title=title
        self.img=img
        self.rating=rating
        self.genre=genre
        self.release=release
    }
}
struct Resource{
    var resource:Array<Movie>=[]
}