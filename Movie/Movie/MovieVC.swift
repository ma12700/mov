//
//  MovieCV.swift
//  Movie
//
//  Created by iOS Training on 7/31/19.
//  Copyright © 2019 iOS Training. All rights reserved.
//

import UIKit
import CoreData
//import Reachability
class MovieCV: UICollectionViewController {
    
    var res=Resource()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 2, height: screenWidth / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView?.collectionViewLayout=layout
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Movies")
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            count = result.count
            print(count)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        if Reachability.isConnectedToNetwork() || count == 0{
            // Go ahead and fetch your data from the internet
            // ...
            print("Internet connection available****************")
            let url=NSURL(string:"https://api.androidhive.info/json/movies.json")
            let request = NSURLRequest(URL: url!)
            let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration())
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible=true
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    print(json)
                    var i:Int = 0
                    //                var k:Int = 0
                    while i < json.count{
                        let arr = json[i].objectForKey("genre")! as! Array<String>
                        let tit = json[i].objectForKey("title")! as! String
                        let rat = json[i].objectForKey("rating") as! Double
                        let img = NSData(contentsOfURL: NSURL(string: json[i].objectForKey("image")! as! String)!)!
                        let rel = json[i].objectForKey("releaseYear")! as! Int
                        if self.count == 0{
                            let newUser = NSEntityDescription.entityForName("Movies", inManagedObjectContext: managedContext)
                            let movie = Movies(entity: newUser!, insertIntoManagedObjectContext: managedContext)
                            
                            movie.title=json[i].objectForKey("title")! as! String
                            movie.rating=json[i].objectForKey("rating") as! Double
                            movie.image=NSData(contentsOfURL: NSURL(string: json[i].objectForKey("image")! as! String)!)!
                            movie.releaseYear=json[i].objectForKey("releaseYear")! as! Int
                            movie.genre=arr
                            do{
                                try managedContext.save()
                            }catch{
                                print("error")
                                
                            }
                        }
                        
                        
                        self.res.resource.append(Movie(title: tit, rating: rat, img: img, release: rel, genre:arr))
                        i+=1
                    }
                    
                    self.collectionView?.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible=false
                }catch{
                    
                    print("Error\n")
                    
                }
                
            }
            task.resume()

        } else {
            print("Internet connection not available")
            UIApplication.sharedApplication().networkActivityIndicatorVisible=true
            do {
                let result = try managedContext.executeFetchRequest(fetchRequest)
                print(result.count)
                for user in result{
                    let u = user as! Movies
                    //                    managedContext.deleteObject(u)
                    //                    do{
                    //                        try managedContext.save()
                    //                    }catch{
                    //
                    //                    }
                    res.resource.append(Movie(title: u.title, rating:u.rating , img: u.image, release: u.releaseYear, genre:u.genre))
                }
                collectionView?.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible=false
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
            
        }
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return res.resource.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)as?CollectionCell
        cell?.sizeToFit()
        //cell?.title.text=res.resource[indexPath.row].title
        cell?.image.image=UIImage(data: res.resource[indexPath.row].img)
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let des=segue.destinationViewController as?ViewController
        let cell = sender as? UICollectionViewCell
        let i = collectionView?.indexPathForCell(cell!)!.row
        let mov=res.resource[i!]
        des?.movie=mov
    }
    
}
