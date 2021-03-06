//
//  ItemViewController.swift
//  Ruben_Ryckeghem_S2IT_werkstuk1
//
//  Created by Ruben Ryckeghem on 7/05/18.
//  Copyright © 2018 Ruben Ryckeghem. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit

class ItemViewController: UIViewController, MKMapViewDelegate {
    var locationLongPress = CLLocationCoordinate2D()
    var item = Item()
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myAn: UILabel!
    @IBOutlet weak var myStraat: UILabel!
    @IBOutlet weak var myHN: UILabel!
    @IBOutlet weak var myGemeente: UILabel!
    @IBOutlet weak var myPostcode: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func transformImage(_ sender: UIPinchGestureRecognizer) {
        self.myImageView.transform =  CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myLabel.text = item.voornaam
        self.myAn.text = item.achternaam
        self.myStraat.text = item.straat
        self.myGemeente.text = item.gemeente
        self.myHN.text = item.huisnummer
        self.myPostcode.text = item.postcode
        self.myImageView.image = UIImage(named: item.image)
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:item.latitude, longitude:item.longitude)
        
        
        let annotation:MyAnnotation = MyAnnotation(coordinate: coordinate, title: "Hier woont "+item.voornaam)
        
        self.myMapView.addAnnotation(annotation)
        self.myMapView.selectAnnotation(annotation, animated: true)
    }
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        showAlertWithTextfield()
        
        // we leggen de coordinaten vast voor later gebruik
        let point = sender.location(in: self.myMapView)
        self.locationLongPress = self.myMapView.convert(point, toCoordinateFrom:self.myMapView)
        
        
    }
    func showAlertWithTextfield(){
        let alertController = UIAlertController(title: "Annotation", message: "What is the name of the annotation?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let annotation = MyAnnotation(coordinate: self.locationLongPress, title: nameTextField.text!)
            self.myMapView.addAnnotation(annotation)
            self.myMapView.selectAnnotation(annotation, animated: true)
        }
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Name"
            textField.textAlignment = .center
        })
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let center = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
