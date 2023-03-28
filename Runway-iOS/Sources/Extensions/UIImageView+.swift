//
//  UIImageView+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/26.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadFromURL(urlString: String, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        guard let url = URL(string: urlString) else { return }
        kf.setImage(with: url)
    }
}
