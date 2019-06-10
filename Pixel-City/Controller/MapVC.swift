//
//  ViewController.swift
//  Pixel-City
//
//  Created by Steven Liu on 2019/6/7.
//  Copyright © 2019 Steven Liu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pullUpView: UIView!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    var spinner: UIActivityIndicatorView?
    var progressLable: UILabel?
    var screensize = UIScreen.main.bounds
    
    var flowLayout = UICollectionViewFlowLayout()
    var collectionview : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationService()
        addDoubleTap()
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionview?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionview?.delegate = self
        collectionview?.dataSource = self
        collectionview?.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pullUpView.addSubview(collectionview!)
        // Do any additional setup after loading the view.
    }
    
    func addDoubleTap(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    func addSwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    @objc func swipeDown(){
        pullUpHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screensize.width / 2) - ((spinner?.frame.width)!)/2, y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        pullUpView.addSubview(spinner!)
    }
    
    func removeSpinner(){
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLbl(){
        progressLable = UILabel()
        progressLable?.frame = CGRect(x: (screensize.width / 2) - 120, y: 175, width: 240, height: 40)
        progressLable?.font = UIFont(name: "Avenir Next", size: 18)
        progressLable?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        progressLable?.text = "12 out of 40 photos loaded"
        progressLable?.textAlignment = .center
        collectionview?.addSubview(progressLable!)
    }
    func removeProgressLbl(){
        if progressLable != nil {
            progressLable?.removeFromSuperview()
        }
    }
    
    func animateViewUp(){
        pullUpHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func centerMapPressed(_ sender: Any) {
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse{
            centerMapOnUserLocation()
        }
    }
    
}

extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer){
        removePin()
        removeSpinner()
        removeProgressLbl()
        
        animateViewUp()
        addSwipe()
        addSpinner()
        addProgressLbl()
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = DroppablePin.init(coordinate: touchCoordinate, identifier: "droppablePin")
        
        mapView.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegion.init(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    
        
    }
    
    func removePin(){
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
    }
}



extension MapVC: CLLocationManagerDelegate{
    func configureLocationService(){
        if authorizationStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else{
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
}




extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       if let cell = collectionview?.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell {
            return cell
        }
        
        
        
        return UICollectionViewCell()
    }
    

    
}
