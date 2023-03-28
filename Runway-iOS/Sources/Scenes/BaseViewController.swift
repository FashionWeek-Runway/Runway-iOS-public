//
//  BaseViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard


class BaseViewController: UIViewController {
    
    // MARK: - UI Components
    
    let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body1B
        return label
    }()
    
    let navigationBarArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icon_tab_back"), for: .normal)
        return button
    }()
    
    var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icon_close"), for: .normal)
        return button
    }()
    
    var progressBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.trackTintColor = .gray100
        view.progressTintColor = .point
        return view
    }()
    
    let keyboardWrapperView: PassThroughView = {
        let view = PassThroughView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let keyboardSafeAreaView: PassThroughView = {
        let view = PassThroughView()
        return view
    }()
    
    // MARK: - Properties
    
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0)
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
   }
    
    func addNavigationTitleLabel(_ title: String? = nil) {
        self.navigationBarArea.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.bottom.equalToSuperview().offset(-15)
        }
        if let title = title {
            navigationTitleLabel.text = title
        }
    }
    
    func addBackButton() {
        self.navigationBarArea.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
    
    func addExitButton() {
        self.navigationBarArea.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
    
    func addProgressBar() {
        self.view.addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBarArea.snp.bottom)
            $0.height.equalTo(4)
        }
    }
    
    func configureUI() {
        self.view.addSubviews([self.keyboardWrapperView, self.keyboardSafeAreaView])
        self.keyboardSafeAreaView.addSubview(self.navigationBarArea)
        self.navigationBarArea.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(54 + view.getSafeArea().top).priority(.required)
        }
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .bind { [weak self] in self?.keyboardHeight.accept($0) }
            .disposed(by: disposeBag)
        
        self.keyboardWrapperView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0).priority(.high)
        }
        
        self.keyboardSafeAreaView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.keyboardWrapperView.snp.top)
        }
        
        self.keyboardHeight
            .withUnretained(self)
            .bind(onNext: { ss, height in
                ss.updateKeyboardHeight(height)
                UIView.transition(
                    with: ss.keyboardWrapperView,
                    duration: 0.25,
                    options: .init(rawValue: 458752),
                    animations: ss.view.layoutIfNeeded
                )
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    private func updateKeyboardHeight(_ height: CGFloat) {
        self.keyboardWrapperView.snp.updateConstraints {
            $0.height.equalTo(self.keyboardHeight.value).priority(.high)
        }
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 0
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    func removeBlurEffect() {
        self.view.viewWithTag(0)?.removeFromSuperview()
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }
            
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
