//
//  GameTableViewCell.swift
//  QuickenLoansAssignment
//


import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thumbNailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Downloads each cell image asynchronously 
        func urlToImageData(imageUrl:String, onCompltetion:@escaping (UIImage)->()){
            var image = UIImage()
            DispatchQueue.global().async {
                if let url = NSURL(string: imageUrl),let data = NSData(contentsOf: url as URL), let gameImage = UIImage(data: data as Data){
                    image = gameImage
                }else{
                    let errorImage = UIImage(named: QLAConstantDefaultGameImage)
                    image = errorImage!
                }
                DispatchQueue.main.async {
                    onCompltetion(image)
                }
            }

    }
}
