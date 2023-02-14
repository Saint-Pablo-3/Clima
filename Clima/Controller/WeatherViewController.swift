//
//  ViewController.swift
//  Clima
//
//  Created by Pavel Reshetov on 26.01.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager() // create the weather request instance
    let locationManager = CLLocationManager() // create responsable for GPS-location object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self //first-need method for location coordinates
        locationManager.requestWhenInUseAuthorization() // working after confirmation
        locationManager.requestLocation() // one-time delivery current's location
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
   
    @IBAction func updateLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }

}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate {
    // add two necessary methods -updatingLocation and -didFailWithError
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude // latitude coordinate
            let lon = location.coordinate.longitude // longitude corrdinate
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

//creating textFieldDelegate extension
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter the place"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use this method to get the current's city weather
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation() // stop updating
            //update temperature label
            self.temperatureLabel.text = weather.temperatureString
            //update condition label
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            //update cityLabel
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
