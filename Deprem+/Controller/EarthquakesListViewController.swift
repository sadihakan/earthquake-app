//
//  EarthquakesListViewController.swift
//  Deprem+
//
//  Created by Hakan Koşanoğlu on 6.07.2020.
//  Copyright © 2020 com.kai. All rights reserved.
//

import UIKit
import MapKit
import GoogleMobileAds

class EarthquakesListViewController: UIViewController {
    
    private var earthquakeListVM: EarthquakeListViewModel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var tableviewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var locationManager = CLLocationManager()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        
    }
    
    private func setup() {
        startLocationManager()
        navbarSettings()
        WebService().getData() { [weak self] earthquakes in
            if let earthquakes = earthquakes {
                self?.earthquakeListVM = EarthquakeListViewModel(earthquakes: earthquakes)
                DispatchQueue.main.async {
                    self?.addAnnotation((self?.earthquakeListVM)!)
                    self?.tableview.reloadData()
                }
            }
        }
    }
    
    private func startLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        let center = mapview.centerCoordinate
        let location = CLLocationCoordinate2D(latitude: center.latitude - 8.0, longitude: center.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 22.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        self.mapview.showsUserLocation = true
    }
    
    private func loadGADs() {
        interstitial = GADInterstitial(adUnitID: Constants.Ads.interstitialID)
        let request = GADRequest()
        interstitial.load(request)
        bannerView.adUnitID = Constants.Ads.bannerID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    func navbarSettings(){
        let navView = UIView()
        let label = UILabel()
        label.text = "Deprem+"
        label.font = label.font.withSize(20)
        label.sizeToFit()
        label.center = CGPoint(x: navView.center.x + 10, y: navView.center.y)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .white
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        let imageAspect = imageView.image!.size.width / imageView.image!.size.height
        imageView.frame = CGRect(x: label.frame.origin.x - label.frame.size.height * imageAspect - 5, y: label.frame.origin.y, width: label.frame.size.height * imageAspect, height: label.frame.size.height)
        imageView.contentMode = .scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(imageView)
        navView.sizeToFit()
        self.navigationItem.titleView = navView
    }
    
    func hideShowTableView(_ status: HideShow) {
        if status == .hide {
            tableviewHeightCons.constant = 200
        } else {
            tableviewHeightCons.constant = 500
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func tableviewCardButtonTapped(_ sender: Any) {
        if tableviewHeightCons.constant == 200 {
            hideShowTableView(.show)
        } else {
            hideShowTableView(.hide)
        }
    }
}

extension EarthquakesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earthquakeListVM == nil ? 0 : self.earthquakeListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: EQTableViewCell.identifier, for: indexPath) as! EQTableViewCell
        
        let earthquake = self.earthquakeListVM.earthquakeAtIndex(indexPath.row)
        
        cell.nameLabel.text = earthquake.name
        cell.intensityLabel.text = earthquake.intensity
        cell.dateLabel.text = earthquake.date
        cell.intensityLabel.textColor = earthquake.intensityColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        
        let location = self.earthquakeListVM.locationAtIndex(indexPath.row)
        self.setRegion(location: location)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -20 {
            hideShowTableView(.hide)
        } else if scrollView.contentOffset.y > 20 {
            hideShowTableView(.show)
        }
    }
}

extension EarthquakesListViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    private func setRegion(location: CLLocationCoordinate2D) {
        let location = location
        let span = MKCoordinateSpan(latitudeDelta: 1.50, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: location, span: span)
        tableviewHeightCons.constant = 200
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        mapview.setRegion(region, animated: true)
    }
    
    private func addAnnotation(_ earthquakes: EarthquakeListViewModel) {
        for eq in earthquakes.earthquakes {
            let earthquakeModel = EarthquakeViewModel(eq)
            let annotation = MKPointAnnotation()
            annotation.title = earthquakeModel.name
            annotation.subtitle = earthquakeModel.date
            annotation.coordinate = CLLocationCoordinate2D(latitude: earthquakeModel.latitude, longitude: earthquakeModel.longitude)
            mapview.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = UIImage(named: "caution")
        
        return annotationView
    }
}
