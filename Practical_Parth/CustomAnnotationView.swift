//
//  CustomAnnotationView.swift
//  Practical_Parth
//
//  Created by Parth Thakker on 21/11/17.
//  Copyright © 2017 Parth Thakker. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKPinAnnotationView {

    public var selectedLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 50))
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)
        
        if(selected)
        {
            // Do customization, for example:
            selectedLabel.textAlignment = .center
            selectedLabel.font = UIFont.init(name: "HelveticaBold", size: 13)
//            selectedLabel.backgroundColor = UIColor.lightGray
            selectedLabel.layer.borderColor = UIColor.black.cgColor
            selectedLabel.layer.borderWidth = 2
            selectedLabel.layer.cornerRadius = 5
            selectedLabel.layer.masksToBounds = true
            selectedLabel.numberOfLines = 0
            
            selectedLabel.center.x = 0.5 * self.frame.size.width;
            selectedLabel.center.y = -0.5 * selectedLabel.frame.height;
            self.addSubview(selectedLabel)
        }
        else
        {
            selectedLabel.removeFromSuperview()
        }
    }

}
