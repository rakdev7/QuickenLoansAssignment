//
//  SearchDataModel.swift
//  QuickenLoansAssignment
//
//  

import Foundation
import UIKit

struct SearchModelItem {
    var name:String?
    var thumbImage:String?
    var cellImage:UIImage?
}

class SearchDataModel: NSObject{
    
    private var dataResults: [String: Any]
    var searchData = [SearchModelItem]()
    
    init(data: [String: Any]) {
        dataResults = data
        super.init()
    }
    
    /**
     * The responseData retrieves response and save it in SearchModelItem
     */
    func responceData()->[SearchModelItem]{
        
        if let results: [Any] = dataResults["results"] as? [Any]{
            for each in results{
                let result = each as! [String:Any]
                if let gameName = result["name"] as! String?, let image = result["image"] as! [String:Any]?{
                    var eachGamedata = SearchModelItem()
                    eachGamedata.name = gameName
                    eachGamedata.thumbImage =  image["thumb_url"] as? String
                    searchData.append(eachGamedata)
                }
            }
        }
        return searchData
    }
    
}
