//
//  addLocationViewController.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 6/27/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import Foundation
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: OUTLETS & PROPERTIES!!!!!!!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var objectId: String!
    
    var locationTextFieldIsEmpty = true
    var websiteTextFieldIsEmpty = true
    
   //MARK: LIFE CYCLE
     
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
        buttonEnabled(false, button: findLocationButton)
    }
    
    //MARK: CANCEL OUT OF ADDING LOCATION
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        }
    
    //MARK: FIND LOCATION AND ACTION
    
    @IBAction func findLocation(sender: UIButton) {
        self.setLoading(true)
        let newLocation = locationTextField.text
        
        guard let url = URL(string: self.websiteTextField.text!), UIApplication.shared.canOpenURL(url) else {
             self.showAlert(message: "Please include 'http' in your link", tittle: "Invalid URL")
            setLoading(false)
            return
    }
        geocodePosition(newLocation: newLocation ?? "")
}

//MARK: find geocode position

private func geocodePosition(newLocation: String) {
    CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
        if let error = error {
            self.showAlert(message: error.localizedDescription, tittle: "Location Not Found")
            self.setLoading(false)
            print("Location not found")
        }
        else {
            var location: CLLocation?
            
            if let marker = newMarker, marker.count > 0 {
                location = marker.first?.location
            }
            
            if let location = location {
                self.loadNewLocation(location.coordinate)
            }
            else {
                self.showAlert(message: "Please try again later.", tittle: "Error")
                self.setLoading(false)
                print("There was an error.")
            }
        }
    }
}

//MARK: PUSHTO TO FINAL ADD LOCATION

private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
    let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
    controller.studentInformation = buildStudentInfo(coordinate)
    self.navigationController?.pushViewController(controller, animated: true)
}

//MARK: STUDENT INFO DISPLAY ON FINAL ADD LOCATION SCREEN

private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
    
    var studentInfo = [
        "uniqueKey": UdacityClient.Auth.key,
        "firstName": UdacityClient.Auth.key,
        "lastName": UdacityClient.Auth.key,
        "mapString": locationTextField.text!,
        "mediaURL": websiteTextField.text!,
        "latitude": coordinate.latitude,
        "longitude": coordinate.longitude,
    ] as [String: AnyObject]
    
    if let objectId = objectId {
        studentInfo["objectID"] = objectId as AnyObject
        print(objectId)
    }
    return StudentInformation(studentInfo)
}

//MARK: LOADING STATE
 
func setLoading(_ loading: Bool) {
    if loading {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.buttonEnabled(true, button: self.findLocationButton)
        }
    } else {
        DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.buttonEnabled(true, button: self.findLocationButton)
    }
}
    DispatchQueue.main.async {
    self.locationTextField.isEnabled = !loading
    self.websiteTextField.isEnabled = !loading
    self.findLocationButton.isEnabled = !loading
    }
    }

//MARK: ENABLED AND DISABLE BUTTONS AND TEXT FIELDS

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString
    string: String) -> Bool {
    if textField == locationTextField {
        let currentText = locationTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false}
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.isEmpty && updatedText == "" {
            locationTextFieldIsEmpty = true
        }
        else {
            locationTextFieldIsEmpty = false
        }
    }
    
    if textField == websiteTextField {
        let currentText = websiteTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false}
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.isEmpty && updatedText == "" {
            websiteTextFieldIsEmpty = true
        }
        else {
            websiteTextFieldIsEmpty = false
        }
}

    if locationTextFieldIsEmpty == false && websiteTextFieldIsEmpty == false {
        buttonEnabled(false, button: findLocationButton)
    }
    else {
        buttonEnabled(false, button: findLocationButton)
}

    return true
}

func textFieldShouldClear(_ textField: UITextField) -> Bool {
    buttonEnabled(false, button: findLocationButton)
    if textField == locationTextField {
        locationTextFieldIsEmpty = true
    }
    if textField == websiteTextField {
        websiteTextFieldIsEmpty = true
    }
    return true
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
        nextField.becomeFirstResponder()
    }
    else {
        textField.resignFirstResponder()
        findLocation(sender: findLocationButton)
}
return true
}
}
