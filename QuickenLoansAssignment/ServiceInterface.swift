//
//  ServiceInterface.swift
//  QuickenLoansAssignment
//
//  

import Foundation
import UIKit

class ServiceInterface{
    
    
    /**
     * The getGameSearchResults is called to make the a service request and get the Games search results
     
     * param:searchText: Text searched by user in the view
     * param:WithCompletion: Handler to notify the search results on receiving a response
     */
    func getGameSearchResults(searchText:String,WithCompletion:@escaping ([SearchModelItem]?,NSError?)->Void){
        
        //Building URL Request
        let url:String = self.BuildUrlString(searchString: searchText)
        let urlRequest = URL(string: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task =  session.dataTask(with: urlRequest!) { (data, responce, error ) in
            
            guard error == nil else{
                DispatchQueue.main.async {
                    WithCompletion(nil, error! as NSError)
                }
                return
            }
            guard let data = data else{
                DispatchQueue.main.async {
                    WithCompletion(nil, nil)
                }
                return
            }
            do{
                let json: [String:Any] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                DispatchQueue.main.async {
                    WithCompletion(self.parseResponseDict(responseDict: json), nil)
                }
            }
            catch let jsonError as NSError{
                DispatchQueue.main.async {
                    WithCompletion(nil, jsonError)
                }
            }
        }
        task.resume()
    }
    
    
    private func parseResponseDict(responseDict:[String: Any])->[SearchModelItem]{
        let myModel = SearchDataModel(data: responseDict)
        return myModel.responceData()
    }
    
    private func BuildUrlString(searchString:String)->String{
        let buildUrlString:String = QLAConstantSearchRequestUrl.replacingOccurrences(of: "SEARCH_TEXT", with: searchString)
        return buildUrlString
    }
    
}
