//
//  DetailViewController.swift
//  Yelp
//
//  Created by mac on 3/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking
//@objc protocol DetailViewControllerDelegate {
//    optional func detailViewController (detailViewController: DetailViewController)
//}

class DetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var prefs : NSUserDefaults!

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var imageRating: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs = NSUserDefaults()
        //map.delegate = self
        let value = prefs.objectForKey("country")
        let nameValue = prefs.objectForKey("name")
        let distance = prefs.objectForKey("distance")
        let review = prefs.objectForKey("review")
        let category = prefs.objectForKey("category")
        let imageUrl = prefs.objectForKey("imageUrl")
        let imageRatingUrl = prefs.objectForKey("imageRating")
//        print (imageUrl)
        //print(value!)
        
        //for add in addressess {
            //getPlacemarkFromAddress(add)
        
        //}
        getPlacemarkFromAddress(String(value!))
        nameLabel.text = String(nameValue!)
        distanceLabel.text = String(distance!)
        reviewLabel.text = "\(review!) Review"
        categoriesLabel.text = String(category!)
        addressLabel.text = String(value!)
        imageThumb.setImageWithURL(NSURL(string: imageUrl as! String)!)
        //imageRating!.setImageWithURL(NSURL(string: imageRating as! String)!)
        imageRating.setImageWithURL(NSURL(string: imageRatingUrl as! String)!)
        //thumbImageView.setImageWithURL(business.imageURL!)
        map.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    func createAnnotationForLocation(location: CLLocation) {
        let bootcamp = BootcampAnnotation(coordinate: location.coordinate)
        map.addAnnotation(bootcamp)
    }

    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(loc)
                }
            }
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() ==  .AuthorizedWhenInUse {
            map.showsUserLocation = true
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(loc)
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(BootcampAnnotation) {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            if #available(iOS 9.0, *) {
                
                annoView.pinTintColor = UIColor.blueColor()
            } else {
                // Fallback on earlier versions
            }
            annoView.animatesDrop = true
            return annoView
        }else if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        return nil
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


