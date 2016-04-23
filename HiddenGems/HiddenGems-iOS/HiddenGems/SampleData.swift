//
//  SampleData.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/28/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class SampleData: NSObject {

    struct data {
        var imageLink: String
        var city: String
        var state: String
        var latitude: String
        var longitude: String
        var gems: String
        var name: String
        var description: String
    }
    
    func samples() -> [data] {
        return [
            data(imageLink: "", city: "Los Angeles", state: "California", latitude: "34.05", longitude: "-118.24", gems: "5", name: "LA Rooftop", description: "Walk into the lobby of the hotel, take the elevator to the top floor, get out and walk to the end of the hall where you will find a staircase that leads to the rooftop."),
            data(imageLink: "", city: "Huntington Beach", state: "California", latitude: "33.66", longitude: "-117.99", gems: "-1", name: "View of the whole city", description: "Just walk up the hill."),
            data(imageLink: "", city: "Newport Beach", state: "California", latitude: "33.61", longitude: "-117.92", gems: "5111", name: "Kobe's backyard", description: "Do whatever you got to do to get in"),
            data(imageLink: "", city: "San Diego", state: "California", latitude: "32.71", longitude: "-117.16", gems: "110", name: "SDSU Party Room", description: "Walk onto North Campus, take the elevator to the top, use pin number 313, enter room."),
            data(imageLink: "", city: "San Francisco", state: "California", latitude: "37.77", longitude: "-122.41", gems: "102", name: "View of the city", description: "Park in a residential neighborhood, pay $5 to get onto street, walk to the 7 11 and make a right, walk up the hill and it's on the left.")
        ]
    }
}
