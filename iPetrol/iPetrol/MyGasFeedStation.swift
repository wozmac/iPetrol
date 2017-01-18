//
//  MyGasFeedResponse.swift
//  iPetrol
//
//  Created by Tero Jankko on 1/16/17.
//  Copyright © 2017 Tero Jankko. All rights reserved.
//

import UIKit

/*
 "country": "United States",
 "zip": "98053",
 "reg_price": "3.79",
 "mid_price": "N/A",
 "pre_price": "4.29",
 "diesel_price": "4.39",
 "reg_date": "4 years ago",
 "mid_date": "4 years ago",
 "pre_date": "4 years ago",
 "diesel_date": "4 years ago",
 "address": "23530 Ne Redmond Fall City Rd",
 "diesel": "1",
 "id": "103326",
 "lat": "47.644291",
 "lng": "-122.024963",
 "station": "Xtramart",
 "region": "Washington",
 "city": null,
 "distance": "2.1 miles"
*/

class MyGasFeedStation: NSObject {
    var country: String?
    var zip: String?
    var regPrice: String?
    var midPrice: String?
    var prePrice: String?
    var dieselPrice: String?
    var regDate: String?
    var midDate: String?
    var preDate: String?
    var dieselDate: String?
    var address: String?
    var diesel: String?
    var id: String?
    var latitude: Double?
    var longitude: Double?
    var station: String?
    var region: String?
    var city: String?
    var distance: String?
}
