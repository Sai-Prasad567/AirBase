//
//  AirBaseTableViewCell.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import Foundation
import UIKit

class AirBaseTableViewCell: UITableViewCell{
    
    let button = AirBaseCheckButton()
    let label = UILabel()
    
    init(text : String, style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews(text:text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(text:String){
        
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = AirBaseBgColors.shared.bGColorW_bGColorD
        button.isSelected = false
        
        self.contentView.addSubview(button)
        self.contentView.addSubview(label)
    
        
        button.addConstraint(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0),size: CGSize(width: 24, height: 24))
        label.addConstraint(top: contentView.topAnchor, leading: button.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor,padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 10))
    }
}
