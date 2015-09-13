//
//  MapViewController.swift
//  BuildIt!
//
//  Created by Srihari Mohan on 9/12/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    let radius: CLLocationDistance = 1000
    var currentPin: pinObject!
    var pinArray = pinObject.localPinData()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailFromMap" {
            let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        if identifier == "showDetailFromMap" {
//            if(latTextField.text.toInt() == nil || longTextField.text.toInt() == nil || regionTextField.text == " " || costTextField.text == " ") {
//                return false;
//            } else {
//                return true;
//            }
//        }
//        return false;
        
        if identifier == "showDetailFromMap" {
            let region_entry = regionTextField.text
            if search_for_region_entry((region_entry as String).lowercaseString) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.latTextField.delegate = self
        self.longTextField.delegate = self
        self.regionTextField.delegate = self
        self.costTextField.delegate = self
        mapView.delegate = self
        
        centerMapOnLocation(CLLocation(latitude: 13, longitude: 80))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: "segueHome")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissVC")
    }
    
    func dismissVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func segueHome() {
        self.performSegueWithIdentifier("segueHomeFromMap", sender: self)
    }
    
    @IBAction func optimize(sender: UIButton) {
        var lat_entry = latTextField.text as String
        var long_entry = longTextField.text as String
        var region_entry = regionTextField.text as String
        var region_entry_lowercase = (region_entry as String).lowercaseString
        var cost_entry = costTextField.text
        var cl_lat_loc: Int = 0
        var cl_long_loc: Int = 0
        var this_estimated_cost : Int = 0
        var alertVC : UIAlertController
        var proceed = true
        var new_cost_entry : Double = 0.0
        var my_estimated_cost : Double = 0.0
        
        println("before entering")
        println(lat_entry.toInt())
        if let this_lat_entry = lat_entry.toInt() {
            println("Entered")
            println(this_lat_entry)
            cl_lat_loc = this_lat_entry
            println("cl_lat_loc is \(cl_lat_loc)")
            println("reassigned")
        } else {
            alertVC = UIAlertController(title: "\(lat_entry) is not a valid entry for latitude", message: "Try again", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
            proceed = false
            println(proceed)
        }
        if let this_long_entry = long_entry.toInt() {
            cl_long_loc = this_long_entry
        } else {
            alertVC = UIAlertController(title: "\(long_entry) is not a valid entry for longitude", message: "Try again", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
            proceed = false
            println(proceed)
        }
    
        if region_entry == " " || !search_for_region_entry(region_entry_lowercase) {
            alertVC = UIAlertController(title: "\(region_entry) is not a valid entry for clinic destination", message: "Please try again", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
            proceed = false
        }
        
        if let estimated_cost = cost_entry.toInt() {
            this_estimated_cost = estimated_cost
        } else {
            alertVC = UIAlertController(title: "\(cost_entry) is not a valid entry for the clinic's estimated cost", message: "Please try again", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
            proceed = false
        }
        
        if proceed {
            centerMapOnLocation(CLLocation(latitude: CLLocationDegrees(cl_lat_loc), longitude: CLLocationDegrees(cl_long_loc)))
            var copy_pin_array : [pinObject] = pinObject.localPinData()
            for pin in copy_pin_array {
                if pin.region.lowercaseString == region_entry.lowercaseString {
                    if pin.pinType == "Clinic" {
                        if cl_lat_loc >= -90 || cl_lat_loc <= 90 || cl_long_loc >= -180 || cl_long_loc <= 180 {
                                pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(cl_lat_loc), longitude: CLLocationDegrees(cl_long_loc))
                        } else {
                            alertVC = UIAlertController(title: "latitude and/or longitudinal parameter is not a valid entry for the clinic's destination", message: "Please try again", preferredStyle: .Alert)
                            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                            alertVC.addAction(alert_action)
                            self.presentViewController(alertVC, animated: true, completion: nil)
                        }
                        break;
                    }
                }
            }
            mapView.addAnnotations(copy_pin_array)
            //optimization equation
            var main_sum : Double = 123350;
            var estimated_cost : Double
            if let this_new_cost_entry = cost_entry.toInt() {
                var cur_pop = pinObject.populationDictionary()[0][region_entry_lowercase]!
                main_sum += Double(cur_pop) * 0.35 * 350
                estimated_cost = Double(this_new_cost_entry) + main_sum
                my_estimated_cost = estimated_cost
                println("This is the est cost \(my_estimated_cost)")
                new_cost_entry = Double(this_new_cost_entry)
            }
            var sumForX = 0
            var sumForY = 0
            var averageX : Double
            var averageY : Double
            var count = 0
            var clinicX : Int = 0
            var clinicY : Int = 0
            if search_for_region_entry(region_entry_lowercase) {
                for this_pin in pinObject.localPinData() {
                    if this_pin.region.lowercaseString == region_entry_lowercase {
                        sumForX += Int(this_pin.coordinate.latitude)
                        sumForY += Int(this_pin.coordinate.longitude)
                        ++count
                        if this_pin.pinType == "Clinic" {
                            clinicX = Int(this_pin.coordinate.latitude)
                            clinicY = Int(this_pin.coordinate.longitude)
                            sumForX -= clinicX
                            sumForY -= clinicY
                        }
                    }
                }
                averageX = Double((sumForX)/count)
                averageY = Double((sumForY)/count)
                var composite_x = (Double(clinicX) - averageX) * (Double(clinicX) - averageX)
                var composite_y = (Double(clinicY) - averageY) * (Double(clinicY) - averageY)
                var distance : Double = sqrt(composite_x + composite_y)
                println("This is the new_cost \(new_cost_entry)")
                
                /* ALGORITHM */
                var temp1 = (Double(my_estimated_cost/new_cost_entry) + distance * 100)/10000
                
//                var temp1 = Double(new_cost_entry/10000.0) - Double(my_estimated_cost/10000.0)
//                println("The value of temp1 is \(temp1)")
//                println("The value of distance is \(distance)")
//                if distance > 10 && distance <= 15 {
//                    temp1 *= 1.5
//                } else if distance > 15 && distance <= 25 {
//                    temp1 *= 2.5
//                } else if distance > 25 && distance <= 40 {
//                    temp1 *= 3.5
//                } else {
//                    temp1 *= 4.5
//                }
                //temp1 = (temp1 + distance)/2
                println("The new value of temp1 is \(temp1)")
                if temp1 >= 0 && temp1 <= 0.05 {
                    self.scoreLabel.text = "\(95)"
                    self.scoreLabel.textColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
                } else if temp1 > 0.05 && temp1 <= 0.1 {
                    self.scoreLabel.text = "\(90)"
                    self.scoreLabel.textColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
                } else if temp1 > 0.1 && temp1 <= 0.15 {
                    self.scoreLabel.text = "\(80)"
                    self.scoreLabel.textColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
                } else if temp1 > 0.15 && temp1 <= 0.2 {
                    self.scoreLabel.text = "\(70)"
                    self.scoreLabel.textColor = UIColor(red: 255, green: 120, blue: 0, alpha: 1)
                } else if temp1 > 0.2 && temp1 <= 0.3 {
                    self.scoreLabel.text = "\(60)"
                    self.scoreLabel.textColor = UIColor(red: 255, green: 120, blue: 0, alpha: 1)
                } else if temp1 > 0.3 && temp1 <= 0.45 {
                    self.scoreLabel.text = "\(50)"
                    self.scoreLabel.textColor = UIColor(red: 255, green: 120, blue: 0, alpha: 1)
                } else if temp1 > 0.45 && temp1 <= 0.6 {
                    self.scoreLabel.text = "\(44)"
                    self.scoreLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
                } else if temp1 > 0.6 && temp1 <= 0.8 {
                    self.scoreLabel.text = "\(21)"
                    self.scoreLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
                } else {
                    self.scoreLabel.text = "\(10)"
                    self.scoreLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
                    println(temp1)
                }
            }
        }
    }
    
    private func search_for_region_entry(test_region: String) -> Bool {
        for pin in pinObject.localPinData() {
            if test_region == pin.region.lowercaseString {
                return true;
            }
        }
        return false;
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? pinObject {
            let this_type = "pin"
            var view: MKPinAnnotationView
            if let cur_view = mapView.dequeueReusableAnnotationViewWithIdentifier(this_type)
                as? MKPinAnnotationView {
                    cur_view.annotation = annotation
                    view = cur_view
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: this_type)
                view.pinColor = annotation.color_pins()
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view;
        }
        return nil;
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let this_region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2.0, radius * 2.0)
            mapView.setRegion((this_region), animated: true)
    }
}
