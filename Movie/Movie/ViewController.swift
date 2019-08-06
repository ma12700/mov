//
//  ViewController.swift
//  Movie
//
//  Created by iOS Training on 7/31/19.
//  Copyright © 2019 iOS Training. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tltleT: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var rate: HCSStarRatingView!

    var movie:Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = UIImage(data: movie!.img)
        tltleT.text = movie!.title
        releaseYear.text = "\(movie!.release)"
        rate.allowsHalfStars=true	
        rate.minimumValue=0
        rate.maximumValue=5
        let v = movie!.rating
        rate.value = CGFloat(v/2.0)
        table.reloadData()
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Genre"
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie!.genre.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = movie!.genre[indexPath.row]
        cell.imageView?.image = UIImage(named: "arrow.png")
        return cell
    }
    
    
}

