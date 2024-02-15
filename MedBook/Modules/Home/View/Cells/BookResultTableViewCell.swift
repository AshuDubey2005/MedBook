//
//  BookResultTableViewCell.swift
//  MedBook
//
//  Created by deq on 15/02/24.
//

import UIKit
import SDWebImage

class BookResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnHits: UIButton!
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imageBook: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(data: BookDetails) {
        containerView.roundCorners(10)
        lblAuthor.text = data.authorName?.first ?? ""
        lblTitle.text = data.title ?? ""
        btnRating.setTitle(String(format: "%.1f", data.ratingsAverage ?? "0.0"), for: .normal)
        btnHits.setTitle(String(data.ratingsCount ?? 0), for: .normal)
        imageBook.sd_setImage(with: URL(string: getImageURL(id: data.coverI ?? 0)), placeholderImage: UIImage(systemName: "photo"))
    }
    
    func getImageURL(id: Int) -> String {
        return "https://covers.openlibrary.org/b/id/\(id)-M.jpg"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
