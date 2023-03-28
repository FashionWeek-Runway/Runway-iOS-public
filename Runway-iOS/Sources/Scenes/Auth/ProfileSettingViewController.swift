//
//  ProfileSettingViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

import AVFoundation
import Photos

final class ProfileSettingViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "프로필을 설정해주세요."
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.subheadline1])
        attributedString.addAttribute(.font, value: UIFont.headline3, range: (text as NSString).range(of: "프로필"))
        label.attributedText = attributedString
        return label
    }()
    
    private let profileSettingView: RWProfileSettingButton = RWProfileSettingButton()
    
    private let nickNameField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "닉네임 입력"
        field.errorText = "한글, 영어 혼합 2~10글자 입니다."
        return field
    }()
    
    private let cameraPickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = nil
        picker.allowsEditing = true
        picker.sourceType = .camera
        return picker
    }()
    
    private let albumPickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = nil
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private let nextButton: RWButton = {
        let button = RWButton()
        button.title = "다음"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: ProfileSettingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addProgressBar()
        self.progressBar.setProgress(0.83, animated: false)
        
        self.view.addSubviews([guideTextLabel, profileSettingView, nickNameField, nextButton])
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        profileSettingView.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        nickNameField.snp.makeConstraints {
            $0.top.equalTo(profileSettingView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.nextButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    if keyboardHeight > 0 {
                        $0.leading.trailing.equalToSuperview()
                        self.profileSettingView.toSmallScale()
                    } else {
                        self.profileSettingView.toLargeScale()
                        $0.leading.equalToSuperview().offset(20)
                        $0.trailing.equalToSuperview().offset(-20)
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func setRx() {
        profileSettingView.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.presentActionSheet()
            }).disposed(by: disposeBag)
    }
    
    private func presentActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if reactor?.currentState.profileImageData != nil {
            alertController.addAction(UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: { _ in
                self.profileSettingView.profileImageView.image = UIImage(named: "icon_my_large")
                let action = Reactor.Action.setProfileImage(nil)
                self.reactor?.action.onNext(action)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "사진 촬영", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.present(self.cameraPickerController, animated: true)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "사진 가져오기", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                print(status)
                switch status {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self.present(self.albumPickerController, animated: true)
                    }
                default:
                    break
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alertController, animated: true)
    }
}

extension ProfileSettingViewController: View {
    func bind(reactor: ProfileSettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileSettingReactor) {
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nickNameField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.enterNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge([cameraPickerController.rx.didCancel, albumPickerController.rx.didCancel])
            .bind(onNext: { _ in self.dismiss(animated: true) })
            .disposed(by: disposeBag)
        
        // bind action
        Observable.merge([cameraPickerController.rx.didFinishPickingMediaWithInfo, albumPickerController.rx.didFinishPickingMediaWithInfo])
            .bind(onNext: { [weak self] info in
                self?.dismiss(animated: true, completion: {
                    guard let image = info[.editedImage] as? UIImage, let imageData = image.fixedOrientation().pngData() else { return }
                    self?.profileSettingView.profileImageView.image = image
                    let action = Reactor.Action.setProfileImage(imageData)
                    self?.reactor?.action.onNext(action)
                })
            }).disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileSettingReactor) {
        
        reactor.state.map { $0.nextButtonEnabled }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showActionSheet }
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] isShow in
                if isShow {
                    self?.presentActionSheet()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.profileImageData }
            .map { UIImage(data: $0) }
            .bind(to: profileSettingView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNickNameDuplicate }
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] isShow in
                if isShow {
                    self?.nickNameField.errorText = "이미 존재하는 닉네임입니다."
                    self?.nickNameField.isError.accept(true)
                } else {
                    self?.nickNameField.errorText = "한글, 영어 혼합 2~10글자 입니다."
                    self?.nickNameField.isError.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNickNameValidate }
            .bind(to: nickNameField.isError)
            .disposed(by: disposeBag)
    }
}
