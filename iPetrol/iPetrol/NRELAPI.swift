//
//  MyGasFeedAPI.swift
//  iPetrol
//
//  Created by Tero Jankko on 1/16/17.
//  Copyright © 2017 Tero Jankko. All rights reserved.
//

import UIKit

// http://devapi.mygasfeed.com/stations/radius/47.665249/-122.057544/5/reg/price/rfej9napna.json?callback=?
// the above seems to return garbage

// https://developer.nrel.gov/api/alt-fuel-stations/v1/nearest.json?api_key=DEMO_KEY&fuel_type=ELEC&latitude=47.665249&longitude=-122.057544&radius=5


class NRELAPI: NSObject {
    
    fileprivate var manager: RKObjectManager?
    fileprivate let API_KEY = "DEMO_KEY"
    
    override init() {
        
        super.init()
        
        let agencyMapDict = ["id" : "id", "name" : "name"]
        
        let stationMapDict = [
            "access_days_time" : "access_days_time",
            "bd_blends" : "bd_blends",
            "cards_accepted" : "cards_accepted",
            "city" : "city",
            "date_last_confirmed" : "date_last_confirmed",
            "expected_date" : "expected_date",
            "fuel_type_code" : "fuel_type_code",
            "geocode_status" : "geocode_status",
            "groups_with_access_code" : "groups_with_access_code",
            "hy_status_link" : "hy_status_link",
            "intersection_directions" : "intersection_directions",
            "latitude" : "latitude",
            "longitude" : "longitude",
            "open_date" : "open_date",
            "owner_type_code" : "owner_type_code",
            "plus4" : "plus4",
            "station_name" : "station_name",
            "station_phone" : "station_phone",
            "status_code" : "status_code",
            "street_address" : "street_address",
            "zip" : "zip",
            "state" : "state",
            "ng_fill_type_code" : "ng_fill_type_code",
            "ng_psi" : "ng_psi",
            "ng_vehicle_class" : "ng_vehicle_class",
            "e85_blender_pump" : "e85_blender_pump",
            "ev_level1_evse_num" : "ev_level1_evse_num",
            "ev_level2_evse_num" : "ev_level2_evse_num",
            "ev_dc_fast_num" : "ev_dc_fast_num",
            "ev_other_evse" : "ev_other_evse",
            "ev_network" : "ev_network",
            "ev_network_web" : "ev_network_web",
            "lpg_primary" : "lpg_primary",
            "id" : "id",
            "updated_at" : "updated_at",
            "distance" : "distance"]
        
        RKObjectManager.setShared(nil)
        manager = RKObjectManager(baseURL: NSURL(string: "https://developer.nrel.gov/") as URL!)
        
        //RKMIMETypeSerialization.registerClass(RKNSJSONSerialization.self, forMIMEType: "text/html") // if response has the wrong mime type
        manager!.httpClient.setDefaultHeader("Accept", value: "application/json")
        manager!.httpClient.setDefaultHeader("Content-Type", value: "application/json")
        
        let stationMapping = RKObjectMapping(for: NRELGasStation.self)
        stationMapping?.addAttributeMappings(from: stationMapDict)
        
        let agencyMapping = RKObjectMapping(for: FederalAgency.self)
        agencyMapping?.addAttributeMappings(from: agencyMapDict)
        
        stationMapping?.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "federal_agency", toKeyPath: "federal_agency", with: agencyMapping))
        
        let responseDescriptor = RKResponseDescriptor(
            mapping: stationMapping,
            method: RKRequestMethod.GET,
            pathPattern: nil,
            keyPath: "fuel_stations",
            statusCodes: NSIndexSet(index: 200) as IndexSet!
        )
        
        manager!.addResponseDescriptor(responseDescriptor)
        
        
    }
    
    func getGasStations(_ latitude: Double, _ longitude: Double, _ radius: Double, completionHandler: @escaping ([NRELGasStation]?) -> Void)  {
        
        let queryString = String(format: "api/alt-fuel-stations/v1/nearest.json?api_key=%@&fuel_type=ELEC&latitude=%f&longitude=%f&radius=%f", API_KEY, latitude, longitude, radius)
        
        manager!.getObjectsAtPath(queryString,
                                  parameters: nil,
                                  success: {(requestOperation, mappingResult) -> Void in
                                    print("success")
                                    let stations = mappingResult?.array() as! [NRELGasStation]
                                    print("\(stations.count)")
                                    completionHandler(stations)
        },
                                  
                                  failure: {(requestOperation, error) -> Void in
                                    print("failure, \(error)")
                                    completionHandler(nil)
        }
        )
    }
    
}
