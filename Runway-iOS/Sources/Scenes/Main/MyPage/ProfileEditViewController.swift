//
//  ProfileEditViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

import Kingfisher
import AVFoundation
import Photos

final class ProfileEditViewController: BaseViewController {
    
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
        picker.sourceType = .camera
        return picker
    }()
    
    private let albumPickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = nil
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private let saveButton: RWButton = {
        let button = RWButton()
        button.title = "저장"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: ProfileEditReactor) {
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
        addNavigationTitleLabel("프로필 편집")
        self.view.addSubviews([profileSettingView, nickNameField, saveButton])

        profileSettingView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        nickNameField.snp.makeConstraints {
            $0.top.equalTo(profileSettingView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.saveButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.saveButton.snp.updateConstraints {
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
    
    private func setRx() {
        profileSettingView.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.presentActionSheet()
            }).disposed(by: disposeBag)
    }
}

extension ProfileEditViewController: View {
    func bind(reactor: ProfileEditReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileEditReactor) {
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
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
        
        saveButton.rx.tap
            .map { Reactor.Action.saveButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge([cameraPickerController.rx.didCancel, albumPickerController.rx.didCancel])
            .bind(onNext: { [weak self]  in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        Observable.merge([cameraPickerController.rx.didFinishPickingMediaWithInfo, albumPickerController.rx.didFinishPickingMediaWithInfo])
            .bind(onNext: { [weak self] info in
                self?.dismiss(animated: true) {
                    guard let image = info[.originalImage] as? UIImage else { return }
                    self?.profileSettingView.profileImageView.image = image.fixedOrientation()
                    guard let imageData = image.fixedOrientation().pngData() else { return }
                    let action = Reactor.Action.setProfileImage(imageData)
                    self?.reactor?.action.onNext(action)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileEditReactor) {
        
        reactor.state.map { $0.nextButtonEnabled }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.nickname }
            .bind(to: nickNameField.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.profileImageURL }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] imageURL in
                guard let url = URL(string: imageURL) else { return }
                self?.profileSettingView.profileImageView.kf.setImage(with: ImageResource(downloadURL: url), completionHandler: { [weak self] result in
                    switch result {
                    case .success(let imageResult):
                        let action = Reactor.Action.setProfileImage(imageResult.image.pngData())
                        self?.reactor?.action.onNext(action)
                    case .failure(let error):
                        print(error)
                    }
                })
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.isNickNameDuplicate }
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
