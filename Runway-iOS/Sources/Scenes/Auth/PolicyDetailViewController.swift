//
//  PolicyDetailViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

final class PhoneDetailViewController: BaseViewController {
    
    let policyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.text = "타이틀"
        return label
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel("이용약관 동의(필수)")
        
        self.view.addSubviews([policyTitleLabel])
        policyTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(30)
        }
    }
}


