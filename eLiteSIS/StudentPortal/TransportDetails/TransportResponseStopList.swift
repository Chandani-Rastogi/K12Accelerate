//
//  TransportResponseStopList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 24, 2020

import Foundation
import SwiftyJSON


class TransportResponseStopList : NSObject, NSCoding{

    var sequenceNo : Int!
    var stopName : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        sequenceNo = json["SequenceNo"].intValue
        stopName = json["StopName"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if sequenceNo != nil{
        	dictionary["SequenceNo"] = sequenceNo
        }
        if stopName != nil{
        	dictionary["StopName"] = stopName
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		sequenceNo = aDecoder.decodeObject(forKey: "SequenceNo") as? Int
		stopName = aDecoder.decodeObject(forKey: "StopName") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if sequenceNo != nil{
			aCoder.encode(sequenceNo, forKey: "SequenceNo")
		}
		if stopName != nil{
			aCoder.encode(stopName, forKey: "StopName")
		}

	}

}
