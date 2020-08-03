//
//  FinishAddLocationViewController.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 6/28/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishAddLocationButton: UIButton!
    
    var studentInformation: StudentInformation?
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? "" )
            
            showLocations(location: studentLocation)
        }
    }
    
    //MARK: ADD OR UPDATE LOCATION
    
    @IBAction func finishAddLocation(_ sender: UIButton) {
        self.setLoading(true)
        if let studentLocation = studentInformation {
            if UdacityClient.Auth.objectId == "" {
                UdacityClient.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.setLoading(true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.showAlert(message: error?.localizedDescription ?? "", tittle: "Error")
                            self.setLoading(false)
                        }
                    }
                }
            }
            else {
                let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite this location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClient.updateStudentLocation(information: studentLocation) { (success, error) in if success {
                        DispatchQueue.main.async {
                            self.setLoading(true)
                            self.dismiss(animated: true, completion: nil)
                        }
                        }
                    else {
                        DispatchQueue.main.async {
                            self.showAlert(message: error?.localizedDescription ?? "", tittle: "Error")
                            self.setLoading(false)
                        }
                        }
                    }
            }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in DispatchQueue.main.async {
                    self.setLoading(false)
                    alertVC.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alertVC, animated: true)
        }
    }
}

    //MARK: NEW LOCATION IN MAP
    
    private func showLocations(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
    if let lat = location.latitude, let lon = location.longitude {
        return CLLocationCoordinate2DMake(lat, lon)
}
return nil
}

//MARK: LOADING STATE

func setLoading(_ loading: Bool) {
    if loading {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.buttonEnabled(false, button: self.finishAddLocationButton)
        }
    }
    else {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.buttonEnabled(true, button: self.finishAddLocationButton)
        }
        }
    DispatchQueue.main.async {
        self.finishAddLocationButton.isEnabled = !loading
    }
}
}
