//
//  ZLDataManager.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit

class ZLDataManager: NSObject {
    
    func insertData(_ startNode : ZLLocation,_ endNode : ZLLocation,_ locations:Array<ZLLocation>) {
        
        guard locations.count > 0 else {
            return
        }
        // All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
        var tempArray = Array<Any>()
        for loc in locations {
            var array = Array<Any>()
            array.append(loc.location!.coordinate.latitude)
            array.append(loc.location!.coordinate.longitude)
//            array.append(loc.location!.timestamp)
            tempArray.append(array)
        }
        
        let locationsJsonString = getJSONStringFromArray(array: tempArray)
        
        let start_la = startNode.location!.coordinate.latitude
        let start_lo = startNode.location!.coordinate.longitude
        let start_time = startNode.location!.timestamp
        let end_la = endNode.location!.coordinate.latitude
        let end_lo = endNode.location!.coordinate.longitude
        let end_time = endNode.location!.timestamp
        
        let dict : [String:Any] = ["start_latitude":start_la,"start_longitude":start_lo,"start_timestamp":start_time,"end_latitude":end_la,"end_longitude":end_lo,"end_timestamp":end_time,"locations":locationsJsonString]
        
        ZLSqliteManager.sharInstance.sqlInsertDataToTable(tableName:tabelName , dicFields: dict)
    }
    
    func selectData()-> Array<Any> {

        var resultArray = Array<Any>()
        let array = ["start_latitude","start_longitude","start_timestamp","end_latitude","end_longitude","end_timestamp","locations"]
        let findArray =   ZLSqliteManager.sharInstance.sqlSelectFromTable(tableName:tabelName , arFieldsKey: array as NSArray)
        
        for dict in findArray {
            let model =  ZLTrackModel.init(dict as! [String : Any])
            resultArray.append(model)
        }
        
        return resultArray;
    }
    
    func deleteData(_ startNode : ZLLocation,_ endNode : ZLLocation,_ locations:Array<ZLLocation>) {
        
    }
    func updateData(_ startNode : ZLLocation,_ endNode : ZLLocation,_ locations:Array<ZLLocation>) {
        
    }
}

extension ZLDataManager {
    //数组转json
    func getJSONStringFromArray(array:Array<Any>) -> String {
        
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        let data = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        
        guard let sData = data else { return ""}
        
        let string = String(data: sData, encoding: .utf8)
        
        return string ?? ""
        
//        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData!
//        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
//        return JSONString! as String
        
    }

    //json转数组
    func getArrayFromJSONString(jsonString:String) ->Array<Any>{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! Array<Any>
        }
        return array as! Array<Any>
        
    }
}
