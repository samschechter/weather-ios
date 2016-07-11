//
//  PlacesViewController.swift
//  
//
//  Created by Sam Schechter on 7/10/16.
//
//

import UIKit

class PlacesViewController: UIViewController, GooglePlacesAutocompleteDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyALqO46ja6RBhdSDZ9BlkPu8KZCvG6kyjA",
            placeType: .Address
        )
        
        gpaViewController.placeDelegate = self // Conforms to GooglePlacesAutocompleteDelegate
        
        presentViewController(gpaViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
