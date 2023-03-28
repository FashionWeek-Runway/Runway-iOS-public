//
//  RWContentSizedTableView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/04.
//

import UIKit

final class RWContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
