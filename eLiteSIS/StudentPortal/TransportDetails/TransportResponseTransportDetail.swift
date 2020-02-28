//
//  TransportResponseTransportDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 24, 2020

import Foundation
import SwiftyJSON


class TransportResponseTransportDetail : NSObject, NSCoding{

    var driverImage : AnyObject!
    var driverMobile : String!
    var driverName : String!
    var dropoffTime : String!
    var helperImage : AnyObject!
    var helperMobile : String!
    var helperName : String!
    var inchargeImage : AnyObject!
    var inchargeMobile : String!
    var inchargeName : String!
    var pickupTime : String!
    var routeName : String!
    var stopageName : String!
    var vehicalNo : String!
    var vehicalType : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        driverImage = json["DriverImage"] as AnyObject
        driverMobile = json["DriverMobile"].stringValue
        driverName = json["DriverName"].stringValue
        dropoffTime = json["DropoffTime"].stringValue
        helperImage = json["HelperImage"] as AnyObject
        helperMobile = json["HelperMobile"].stringValue
        helperName = json["HelperName"].stringValue
        inchargeImage = json["InchargeImage"] as AnyObject
        inchargeMobile = json["InchargeMobile"].stringValue
        inchargeName = json["InchargeName"].stringValue
        pickupTime = json["PickupTime"].stringValue
        routeName = json["RouteName"].stringValue
        stopageName = json["StopageName"].stringValue
        vehicalNo = json["VehicalNo"].stringValue
        vehicalType = json["VehicalType"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if driverImage != nil{
        	dictionary["DriverImage"] = driverImage
        }
        if driverMobile != nil{
        	dictionary["DriverMobile"] = driverMobile
        }
        if driverName != nil{
        	dictionary["DriverName"] = driverName
        }
        if dropoffTime != nil{
        	dictionary["DropoffTime"] = dropoffTime
        }
        if helperImage != nil{
        	dictionary["HelperImage"] = helperImage
        }
        if helperMobile != nil{
        	dictionary["HelperMobile"] = helperMobile
        }
        if helperName != nil{
        	dictionary["HelperName"] = helperName
        }
        if inchargeImage != nil{
        	dictionary["InchargeImage"] = inchargeImage
        }
        if inchargeMobile != nil{
        	dictionary["InchargeMobile"] = inchargeMobile
        }
        if inchargeName != nil{
        	dictionary["InchargeName"] = inchargeName
        }
        if pickupTime != nil{
        	dictionary["PickupTime"] = pickupTime
        }
        if routeName != nil{
        	dictionary["RouteName"] = routeName
        }
        if stopageName != nil{
        	dictionary["StopageName"] = stopageName
        }
        if vehicalNo != nil{
        	dictionary["VehicalNo"] = vehicalNo
        }
        if vehicalType != nil{
        	dictionary["VehicalType"] = vehicalType
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		driverImage = aDecoder.decodeObject(forKey: "DriverImage") as? AnyObject
		driverMobile = aDecoder.decodeObject(forKey: "DriverMobile") as? String
		driverName = aDecoder.decodeObject(forKey: "DriverName") as? String
		dropoffTime = aDecoder.decodeObject(forKey: "DropoffTime") as? String
		helperImage = aDecoder.decodeObject(forKey: "HelperImage") as? AnyObject
		helperMobile = aDecoder.decodeObject(forKey: "HelperMobile") as? String
		helperName = aDecoder.decodeObject(forKey: "HelperName") as? String
		inchargeImage = aDecoder.decodeObject(forKey: "InchargeImage") as? AnyObject
		inchargeMobile = aDecoder.decodeObject(forKey: "InchargeMobile") as? String
		inchargeName = aDecoder.decodeObject(forKey: "InchargeName") as? String
		pickupTime = aDecoder.decodeObject(forKey: "PickupTime") as? String
		routeName = aDecoder.decodeObject(forKey: "RouteName") as? String
		stopageName = aDecoder.decodeObject(forKey: "StopageName") as? String
		vehicalNo = aDecoder.decodeObject(forKey: "VehicalNo") as? String
		vehicalType = aDecoder.decodeObject(forKey: "VehicalType") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if driverImage != nil{
			aCoder.encode(driverImage, forKey: "DriverImage")
		}
		if driverMobile != nil{
			aCoder.encode(driverMobile, forKey: "DriverMobile")
		}
		if driverName != nil{
			aCoder.encode(driverName, forKey: "DriverName")
		}
		if dropoffTime != nil{
			aCoder.encode(dropoffTime, forKey: "DropoffTime")
		}
		if helperImage != nil{
			aCoder.encode(helperImage, forKey: "HelperImage")
		}
		if helperMobile != nil{
			aCoder.encode(helperMobile, forKey: "HelperMobile")
		}
		if helperName != nil{
			aCoder.encode(helperName, forKey: "HelperName")
		}
		if inchargeImage != nil{
			aCoder.encode(inchargeImage, forKey: "InchargeImage")
		}
		if inchargeMobile != nil{
			aCoder.encode(inchargeMobile, forKey: "InchargeMobile")
		}
		if inchargeName != nil{
			aCoder.encode(inchargeName, forKey: "InchargeName")
		}
		if pickupTime != nil{
			aCoder.encode(pickupTime, forKey: "PickupTime")
		}
		if routeName != nil{
			aCoder.encode(routeName, forKey: "RouteName")
		}
		if stopageName != nil{
			aCoder.encode(stopageName, forKey: "StopageName")
		}
		if vehicalNo != nil{
			aCoder.encode(vehicalNo, forKey: "VehicalNo")
		}
		if vehicalType != nil{
			aCoder.encode(vehicalType, forKey: "VehicalType")
		}

	}

}
