//
//  ViewController.swift
//  weathery
//
//  Created by Mohamed Magdy on 07/05/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBAction func locationPressed(_ sender: UIButton) {
    }
    @IBOutlet weak var degreeOfTemp: UILabel!
    @IBOutlet weak var weatherCond: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationButton: UIButton!
    let apiKey = "11ccb50ceffbd364f946e7faf0d393d2"
    let lat=10.2134
    let lon=11.3244
    let locationManager=CLLocationManager()
    
    var weatherManger=WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManger.delegate = self
        
        searchBar.delegate=self
    }
}

//MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let city = searchText
            weatherManger.fetchWeather(cityName: city)
        
    }
}

//MARK: - WeatherManagerDelegate


extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.degreeOfTemp.text = weather.temperatureString
            self.city.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}





//MARK: - CLLocationManagerDelegate


extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locatinPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManger.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
