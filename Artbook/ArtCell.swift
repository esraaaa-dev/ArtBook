//
//  ArtCell.swift
//  Artbook
//
//  Created by Esra Arı on 21.04.2025.
//

import UIKit

class ArtCell: UITableViewCell {

    
    @IBOutlet weak var paintingImgView: UIImageView!
    
    @IBOutlet weak var paintingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        paintingImgView.layer.cornerRadius = 8
        paintingImgView.clipsToBounds = true
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
