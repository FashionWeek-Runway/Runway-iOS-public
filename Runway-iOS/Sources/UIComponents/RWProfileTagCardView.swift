//
//  RWProfileTagCardView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import UIKit

final class RWProfileTagCardView: UIView {
    
    private let topArea: UIView = {
        let view = UIView()
        view.backgroundColor = .point
        return view
    }()
    
    let topBlackHole: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .primary
        return view
    }()
    
    let defaultProfileImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_my_point"))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let congratulationLabel: UILabel = {
        let label = UILabel()
        label.text = "CONGRATULATION"
        label.font = UIFont.font(.helvetica93ExtendedBlack, ofSize: 17)
        label.textColor = .primary
        return label
    }()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.font = UIFont.font(.spoqaHanSansNeoLight, ofSize: 16)
        label.textColor = .primary
        return label
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline2
        label.textColor = .primary
        return label
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let styleLabel: UILabel = {
        let label = UILabel()
        label.text = "STYLE"
        label.font = UIFont.font(.spoqaHanSansNeoLight, ofSize: 16)
        label.textColor = .primary
        return label
    }()
    
    let styleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    private let divider3: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let barcodeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "barcode"))
        return view
    }()
    
    // MARK: - Properties

    var styles: [String] = [] {
        didSet {
            let labels = styles.map {
                let label = UIButton()
                label.setBackgroundColor(.primary, for: .normal)
                label.setAttributedTitle(NSAttributedString(string: $0, attributes: [.font: UIFont.body2, .foregroundColor: UIColor.white]), for: .normal)
                label.isUserInteractionEnabled = false
                label.contentHorizontalAlignment = .center
                label.contentVerticalAlignment = .center
                label.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
                return label
            }
            
            let lastLabel = UIButton()
            lastLabel.setBackgroundColor(.primary, for: .normal)
            lastLabel.isUserInteractionEnabled = false
            lastLabel.contentHorizontalAlignment = .center
            lastLabel.contentVerticalAlignment = .center
            lastLabel.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            
            switch labels.count {
            case 1, 2:
                for _ in 1...4-labels.count {
                    styleStackView.addArrangedSubview(UIView())
                }
                
                for label in labels {
                    styleStackView.addArrangedSubview(label)
                }
            case 3...:
                styleStackView.addArrangedSubview(UIView())
                for idx in 0..<2 {
                    styleStackView.addArrangedSubview(labels[idx])
                }
                lastLabel.setAttributedTitle(NSAttributedString(string: "+" + "\(labels.count - 2)", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.white]), for: .normal)
                styleStackView.addArrangedSubview(lastLabel)
            default:
                break
            }
        }
    }
    
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        
        self.addSubviews([topArea, congratulationLabel,
                          divider1,
                         nameLabel, nicknameLabel,
                          divider2,
                         styleLabel,
                         divider3,
                          styleStackView,
                         barcodeImageView])
        self.snp.makeConstraints {
            $0.width.equalTo(256)
            $0.height.equalTo(426)
        }
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        topArea.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(174)
        }
        topArea.addSubviews([imageView, defaultProfileImageView, topBlackHole])
        
        topArea.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(174)
        }
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.width.equalTo(174)
        }
        
        topBlackHole.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        
        defaultProfileImageView.snp.makeConstraints {
            $0.top.equalTo(topBlackHole.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        congratulationLabel.snp.makeConstraints {
            $0.top.equalTo(topArea.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        divider1.snp.makeConstraints {
            $0.top.equalTo(self.congratulationLabel.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(divider1.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(18)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        divider2.snp.makeConstraints {
            $0.top.equalTo(self.nicknameLabel.snp.bottom).offset(8)
            $0.height.equalTo(1)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
        }
        
        styleLabel.snp.makeConstraints {
            $0.top.equalTo(self.divider2.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(18)
        }
        
        styleStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-18)
            $0.bottom.equalTo(divider3.snp.top).offset(-8)
            $0.height.equalTo(28)
            $0.leading.equalTo(styleLabel.snp.leading)
        }
        
        divider3.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-55)
            $0.height.equalTo(1)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
        }
        
        barcodeImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.centerX.equalToSuperview()
        }
    }
}
