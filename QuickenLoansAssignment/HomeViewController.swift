//
//  HomeViewController.swift
//  QuickenLoansAssignment
//
//  

import UIKit

//private let kConstantSpaceReplace: String = "%20"

class HomeViewController: UITableViewController, UISearchBarDelegate {
    
    var finalData:[SearchModelItem] = [SearchModelItem]()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activity Indicator.
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Receives the user input String, validates it and makes a service call.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let userSearchText:String = searchBar.text!
        let formatedUserSearchText = userSearchText.replacingOccurrences(of: " ", with: QLAConstantSpaceReplace)
        if(formatedUserSearchText != QLAConstantSpaceReplace){
            self.view.endEditing(true)
            activityIndicator.startAnimating()
            let service =  ServiceInterface()
            
            //Initiate a service call to get Game results
            service.getGameSearchResults(searchText: formatedUserSearchText) { (data, error) in
                if(error == nil){
                    if let data = data {
                        self.finalData = data
                        if(self.finalData.count>0){
                            self.activityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }else{
                            self.activityIndicator.stopAnimating()
                            self.finalData = []
                            self.tableView.reloadData()
                            self.alertUser(alertTitle: QLAConstantNoItemsFoundAlertTitle, alertMessage: QLAConstantNoItemsFoundAlertMessage + " \(userSearchText)")
                        }
                    }
                }else{
                    self.alertUser(alertTitle: QLAConstantNetworkErrorAlertTitle, alertMessage: QLAConstantNetworkErrorAlertMessage)
                    self.activityIndicator.stopAnimating()
                }
            }
        }else{
            self.alertUser(alertTitle: QLAConstantWrongInputAlertTitle, alertMessage: QLAConstantWrongInputAlertMessage)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.finalData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GameTableViewCell
        cell.gameName.text = finalData[indexPath.row].name
        cell.thumbNailImage.image = UIImage(named: QLAConstantDefaultGameImage)
        cell.activityIndicator.startAnimating()
        if let cellImage = finalData[indexPath.row].cellImage{
            cell.thumbNailImage.image = cellImage
            cell.activityIndicator.stopAnimating()
        }else{
            if let imageUrlString = finalData[indexPath.row].thumbImage{
                cell.urlToImageData(imageUrl: imageUrlString) { (cellImage) in
                    cell.activityIndicator.stopAnimating()
                    cell.thumbNailImage.image = cellImage
                    self.finalData[indexPath.row].cellImage = cellImage
                }
            }else{
                cell.activityIndicator.stopAnimating()
            }
        }
        
        
        return cell
    }
    
    //Builds an alert according to the error generated.
    func alertUser(alertTitle:String,alertMessage:String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: QLAConstantAlertActionTitle, style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
