//
//  TransportResponseRootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 24, 2020

import Foundation
import SwiftyJSON


class TransportResponseRootClass : NSObject, NSCoding{

    var stopList : [TransportResponseStopList]!
    var transportDetail : TransportResponseTransportDetail!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        stopList = [TransportResponseStopList]()
        let stopListArray = json["StopList"].arrayValue
        for stopListJson in stopListArray{
            let value = TransportResponseStopList(fromJson: stopListJson)
            stopList.append(value)
        }
        let transportDetailJson = json["TransportDetail"]
        if !transportDetailJson.isEmpty{
            transportDetail = TransportResponseTransportDetail(fromJson: transportDetailJson)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if stopList != nil{
        var dictionaryElements = [[String:Any]]()
        for stopListElement in stopList {
        	dictionaryElements.append(stopListElement.toDictionary())
        }
        dictionary["stopList"] = dictionaryElements
        }
        if transportDetail != nil{
        	dictionary["transportDetail"] = transportDetail.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		stopList = aDecoder.decodeObject(forKey: "StopList") as? [TransportResponseStopList]
		transportDetail = aDecoder.decodeObject(forKey: "TransportDetail") as? TransportResponseTransportDetail
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if stopList != nil{
			aCoder.encode(stopList, forKey: "StopList")
		}
		if transportDetail != nil{
			aCoder.encode(transportDetail, forKey: "TransportDetail")
		}

	}

}
