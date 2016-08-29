//
//  ViewController.swift
//  weatherApp
//
//  Created by Tom Fruehe on 8/23/16.
//  Copyright © 2016 Tom Fruehe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBAction func submitButton(_ sender: AnyObject) {
        if cityTextField.text != "" {
            
            pullForecast(cityString: cityTextField.text!)
            
        } else {
            summaryLabel.text = "Please enter a city name."
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func pullForecast(cityString: String) {
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityString.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, err in
                
                var message = ""
                
                if err != nil {
                    print(err)
                } else {
                    
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        //print(dataString)
                        
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    //print(message)
                                    
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
                
                if message == "" {
                    message = "Weather for that area could not be found! Please try again."
                }
                
                DispatchQueue.main.sync(execute: {
                    self.summaryLabel.text = message
                    
                })
            }
            
            task.resume()
            
        } else {
            summaryLabel.text = "Weather for that area could not be found! Please try again."
        }
        
    }

}

