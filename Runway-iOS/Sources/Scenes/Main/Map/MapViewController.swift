//
//  MapViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/18.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit
import NMapsMap
import CoreLocation
import Kingfisher

final class MapViewController: BaseViewController { // naver map sdk에서 카메라 delegate 프로퍼티 지원하지 않아 delegate pattern 사용
    
    private let mapSearchBar: RWMapSearchBar = RWMapSearchBar()
    
    private lazy var mapView: NMFNaverMapView = {
        let view = NMFNaverMapView()
        view.mapView.touchDelegate = self
        view.mapView.addCameraDelegate(delegate: self)
        view.showLocationButton = false
        return view
    }()
    
    private let bottomSheet: RWBottomSheet = RWBottomSheet()
    private let regionSearchBottomSheet: RWBottomSheet = {
        let sheet = RWBottomSheet()
        sheet.layoutMode = .search
        sheet.isHidden = true
        return sheet
    }()
    private lazy var storeSearchBottomSheet: RWBottomSheet = {
        let sheet = RWBottomSheet()
        sheet.searchResultView.isHidden = false
        sheet.aroundView.isHidden = true
        sheet.aroundEmptyView.isHidden = true
        return sheet
    }()
    
    private lazy var setLocationButton: NMFLocationButton = {
        let button = NMFLocationButton()
        button.clipsToBounds = true
        button.mapView = self.mapView.mapView
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: "현 지도에서 검색",
                                                     attributes: [.font: UIFont.body2, .foregroundColor: UIColor.blue600]),
                                  for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setImage(UIImage(named: "icon_refresh"), for: .normal)
        button.imageEdgeInsets.right = 4
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    private let bottomSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private var isHiddenHelperViews: Bool = false {
        didSet {
            if isHiddenHelperViews {
                showTabbar()
                showSearchBar()
                bottomSheet.isHidden = false
                searchButton.isHidden = false
                storeSearchBottomSheet.isHidden = false
                searchButton.frame.origin.y = mapSearchBar.frame.height + 8
                searchButton.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(view.getSafeArea().top + 118 + 8)
                }
            } else {
                hideTabbar()
                hideSearchBar()
                bottomSheet.isHidden = true
                searchButton.isHidden = true
                storeSearchBottomSheet.isHidden = true
                
                searchButton.frame.origin.y = view.getSafeArea().top
                
                searchButton.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(view.getSafeArea().top + 8)
                }
            }
        }
    }
    
    enum MapMode: String {
        case normal
        case storeSearch
        case regionSearch
    }
    
    private var mapMode: MapMode = .normal {
        didSet {
            if oldValue == mapMode {
                return
            }
            [bottomSheet, regionSearchBottomSheet, storeSearchBottomSheet].forEach { $0.showSheet(atState: .folded) }
            switch mapMode {
            case .normal:
                self.tabBarController?.tabBar.isHidden = false
                mapSearchBar.isHidden = false
                searchButton.isHidden = false
                regionSearchBottomSheet.isHidden = true
                bottomSheet.isHidden = false
                mapView.snp.remakeConstraints {
                    $0.top.leading.trailing.bottom.equalToSuperview()
                }
                bottomSafeAreaView.isHidden = true
                navigationBarArea.isHidden = true
            case .storeSearch:
                self.tabBarController?.tabBar.isHidden = true
                mapSearchBar.isHidden = true
                searchButton.isHidden = true
                regionSearchBottomSheet.isHidden = true
                bottomSheet.isHidden = true
                mapView.snp.remakeConstraints {
                    $0.top.equalTo(self.navigationBarArea.snp.bottom)
                    $0.horizontalEdges.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom)
                }
                bottomSafeAreaView.isHidden = true
                navigationBarArea.isHidden = false
            case .regionSearch:
                self.tabBarController?.tabBar.isHidden = true
                mapSearchBar.isHidden = true
                searchButton.isHidden = true
                regionSearchBottomSheet.isHidden = false
                bottomSheet.isHidden = true
                mapView.snp.remakeConstraints {
                    $0.top.equalTo(self.navigationBarArea.snp.bottom)
                    $0.horizontalEdges.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom)
                }
                bottomSafeAreaView.isHidden = false
                navigationBarArea.isHidden = false
            }
        }
    }
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerDidChangeAuthorization(manager)
        return manager
    }()
    
    // 표시될 마커들을 담아두기
    private var markers: [NMFMarker] = [] {
        willSet {
            markers.forEach { $0.mapView = nil }
            newValue.forEach { $0.mapView = mapView.mapView }
        }
    }
    
    private var previousSelectedMarker: NMFMarker? = nil
    private var previousSelectedMarkerImage: NMFOverlayImage? = nil

    // MARK: - initializer
    
    init(with reactor: MapReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAuthorization()
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        navigationBarArea.removeFromSuperview()
        self.view.addSubviews([mapView, mapSearchBar, searchButton, setLocationButton, bottomSheet, regionSearchBottomSheet, storeSearchBottomSheet, navigationBarArea, bottomSafeAreaView])
        addBackButton()
        addExitButton()
        addNavigationTitleLabel()
        
        navigationBarArea.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(54).priority(.required)
        }
        navigationBarArea.backgroundColor = .white
        navigationBarArea.isHidden = true
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mapSearchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().top + 118)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(147)
            $0.height.equalTo(36)
            $0.top.equalToSuperview().offset(view.getSafeArea().top + 118 + 8)
        }
        
        bottomSheet.frame = CGRect(x: 0,
                                   y: UIScreen.getDeviceHeight() - view.getSafeArea().bottom - 121,
                                   width: UIScreen.getDeviceWidth(),
                                   height: UIScreen.getDeviceHeight() - view.getSafeArea().top - 135)
        regionSearchBottomSheet.frame = CGRect(x: 0,
                                         y: UIScreen.getDeviceHeight() - view.getSafeArea().bottom - 75,
                                         width: UIScreen.getDeviceWidth(),
                                         height: UIScreen.getDeviceHeight() - view.getSafeArea().top)
        regionSearchBottomSheet.aroundView.collectionView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        storeSearchBottomSheet.frame = CGRect(x: 0,
                                               y: UIScreen.getDeviceHeight(),
                                               width: UIScreen.getDeviceWidth(),
                                               height: 276 + (self.tabBarController?.tabBar.frame.height ?? 0))
        storeSearchBottomSheet.sheetPanMaxTopConstant = UIScreen.getDeviceHeight()
        storeSearchBottomSheet.sheetPanMinTopConstant = UIScreen.getDeviceHeight() - view.getSafeArea().bottom - 276 - (self.tabBarController?.tabBar.frame.height ?? 0.0)
        
        setLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(42)
            $0.bottom.equalTo(bottomSheet.snp.top).offset(-19)
        }
        
        bottomSafeAreaView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().bottom)
        }
    }
    
    private func showTabbar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.size.height - frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
    
    private func hideTabbar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
    
    private func showSearchBar() {
        mapSearchBar.isHidden = false
        var frame = mapSearchBar.frame
        frame.origin.y = view.frame.origin.y
        mapSearchBar.frame.origin.y = view.frame.origin.y - mapSearchBar.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.mapSearchBar.frame = frame
        }
    }
    
    private func hideSearchBar() {
        var frame = mapSearchBar.frame
        frame.origin.y = view.frame.origin.y - frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.mapSearchBar.frame = frame
        } completion: { _ in
            self.mapSearchBar.isHidden = true
        }
    }
    
    private func requestLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .denied:
            // 거부 상태: alert 필요
            break
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "사용자 위치 주변의 정확한 쇼룸 데이터 표시를 위해 정확한 위치 공유가 필요합니다.")
        case .fullAccuracy:
            // 이미 정확한 위치를 공유 중인 경우
            break
        @unknown default:
            break
        }
    }
    
    private func setUserInitialLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat:locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            cameraUpdate.reason = 1000
            mapView.mapView.moveCamera(cameraUpdate)
        default:
            break
        }
    }
    
    private func setRx() {
        
        regionSearchBottomSheet.backToMapButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.regionSearchBottomSheet.showSheet(atState: .folded)
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewController: View {
    func bind(reactor: MapReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MapReactor) {
        
        mapSearchBar.searchView.rx.gesture(.tap())
            .when(.recognized)
            .map { _ in Reactor.Action.searchFieldDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .do(onNext: {[weak self] in self?.mapMode = .normal})
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .do(onNext: { [weak self] in
                self?.markers.forEach { $0.mapView = nil }
                self?.mapMode = .normal
            })
            .map { Reactor.Action.exitButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mapSearchBar.categoryCollectionView.rx.modelSelected(String.self)
            .map { Reactor.Action.selectFilter($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .do(onNext: { [weak self] in
                self?.searchButton.isHidden = true
            })
            .map { Reactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        bottomSheet.aroundView.collectionView.rx.didEndDecelerating // infiniteScrolling
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                let height = self.bottomSheet.aroundView.collectionView.frame.height
                let contentHeight = self.bottomSheet.aroundView.collectionView.contentSize.height
                let reachesBottom = (self.bottomSheet.aroundView.collectionView.contentOffset.y > contentHeight - height)
                
                if reachesBottom {
                    self.reactor?.action.onNext(.bottomSheetScrollReachesBottom)
                }
            }).disposed(by: disposeBag)
        
        regionSearchBottomSheet.aroundView.collectionView.rx.didEndDecelerating // infiniteScrolling
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                let height = self.regionSearchBottomSheet.aroundView.collectionView.frame.height
                let contentHeight = self.regionSearchBottomSheet.aroundView.collectionView.contentSize.height
                let reachesBottom = (self.regionSearchBottomSheet.aroundView.collectionView.contentOffset.y > contentHeight - height)
                
                if reachesBottom {
                    self.reactor?.action.onNext(.regionSearchBottomSheetScrollReachesBottom)
                }
            }).disposed(by: disposeBag)
        
        bottomSheet.aroundView.collectionView.rx.modelSelected(AroundMapSearchResponseResultContent.self)
            .map { Reactor.Action.storeCellSelected($0.storeID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        storeSearchBottomSheet.searchResultView.rx.tapGesture()
            .when(.recognized)
            .map { [weak self] _ in Reactor.Action.storeCellSelected(self?.storeSearchBottomSheet.searchResultView.storeId ?? 0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        regionSearchBottomSheet.aroundView.collectionView.rx.modelSelected(StoreInfo.self)
            .map { Reactor.Action.storeCellSelected($0.storeID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MapReactor) {
        
        reactor.state.map { $0.mapCategoryFilters }
            .bind(to: mapSearchBar.categoryCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                if index == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWMapSearchBarCollectionViewBookmarkCell.identifier, for: indexPath) as? RWMapSearchBarCollectionViewBookmarkCell else { return UICollectionViewCell() }
                    cell.setSelectedLayout(reactor.currentState.mapFilterSelected[item] ?? false)
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWMapSearchBarCollectionViewCell.identifier, for: indexPath) as? RWMapSearchBarCollectionViewCell else { return UICollectionViewCell() }
                    cell.titleLabel.text = item
                    cell.setSelectedLayout(reactor.currentState.mapFilterSelected[item] ?? false)
                    return cell
                }
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$mapMarkers)
            .subscribe(onNext: { [weak self] markerData in
                DispatchQueue.global(qos: .default).async {
                    let markers = markerData.map { data in
                        let marker = NMFMarker(position: NMGLatLng(lat: data.latitude, lng: data.longitude))
                        marker.iconImage = NMFOverlayImage(name: data.bookmark ? "bookmark_marker" : "marker")
                        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
                        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
                        marker.captionText = data.storeName
                        marker.captionTextSize = 10
                        marker.captionColor = .runwayBlack
                        marker.captionHaloColor = .white
                        
                        marker.touchHandler = { [weak self] (overlay) -> Bool in
                            guard let self else { return true }
                            self.previousSelectedMarker?.iconImage = self.previousSelectedMarkerImage ?? NMFOverlayImage(name: "marker")
                            self.previousSelectedMarker = marker
                            self.previousSelectedMarkerImage = marker.iconImage
                            marker.iconImage = NMFOverlayImage(name: data.bookmark ? "icon_seleted_bookmark" : "marker_highlight")
                            self.isHiddenHelperViews = true
                            let action = Reactor.Action.selectMapMarkerData(data.storeID)
                            self.reactor?.action.onNext(action)
                            self.storeSearchBottomSheet.showSheet(atState: .expanded)
                            return true
                        }
                        return marker
                    }
                    DispatchQueue.main.async {
                        self?.markers = markers
                    }
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.aroundDatas }
            .do(onNext: { [weak self] in
                self?.bottomSheet.aroundEmptyView.isHidden = !$0.isEmpty
            })
            .bind(to: bottomSheet.aroundView.collectionView.rx.items(cellIdentifier: RWAroundCollectionViewCell.identifier, cellType: RWAroundCollectionViewCell.self)) { indexPath, item, cell in
                cell.storeNameLabel.text = item.storeName
                cell.tagRelay.accept(item.category)
                guard let url = URL(string: item.storeImageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
                cell.storeId = item.storeID
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.regionSearchAroundDatas }
            .bind(to: regionSearchBottomSheet.aroundView.collectionView.rx.items(cellIdentifier: RWAroundCollectionViewCell.identifier, cellType: RWAroundCollectionViewCell.self)) { indexPath, item, cell in
                cell.storeNameLabel.text = item.storeName
                cell.tagRelay.accept(item.category)
                guard let url = URL(string: item.storeImage) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
                cell.storeId = item.storeID
            }.disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.mapMarkerSelectData }
            .subscribe(onNext: { [weak self] data in
                guard let url = URL(string: data.storeImage) else { return }
                self?.storeSearchBottomSheet.searchResultView.tagRelay.accept(data.category)
                self?.storeSearchBottomSheet.searchResultView.storeNameLabel.text = data.storeName
                self?.storeSearchBottomSheet.searchResultView.storeId = data.storeID
                self?.storeSearchBottomSheet.searchResultView.imageView.kf.setImage(with: ImageResource(downloadURL: url))
            })
            .disposed(by: disposeBag)
        
        
        reactor.state.compactMap { $0.storeSearchMarker }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] markerData in
                guard let self else { return }
                self.mapMode = .storeSearch
                self.addNavigationTitleLabel(markerData.storeName)
                self.storeSearchBottomSheet.showSheet(atState: .expanded)
                DispatchQueue.global(qos: .default).async {
                    
                    let marker = NMFMarker(position: NMGLatLng(lat: markerData.latitude, lng: markerData.longitude))
                    marker.iconImage = NMFOverlayImage(name: "marker_highlight")
                    marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
                    marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
                    marker.captionText = markerData.storeName
                    marker.captionTextSize = 12
                    marker.captionColor = .runwayBlack
                    marker.captionHaloColor = .white
                    
                    marker.touchHandler = { [weak self] (overlay) -> Bool in
                        guard let self else { return true }
                        if self.storeSearchBottomSheet.frame.origin.y > self.tabBarController?.tabBar.frame.origin.y ?? 0.0 {
                            self.storeSearchBottomSheet.showSheet(atState: .expanded)
                        } else {
                            self.storeSearchBottomSheet.showSheet(atState: .folded)
                        }
                        return true
                    }
                    
                    DispatchQueue.main.async {
                        self.markers = [marker]
                    }
                }
                
                let cameraUpdate = NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: markerData.latitude, lng: markerData.longitude), zoom: 12.0))
                cameraUpdate.animation = .easeIn
                cameraUpdate.reason = 1000
                self.mapView.mapView.moveCamera(cameraUpdate)
                
            }).disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.storeSearchInfo }
            .subscribe(onNext: { [weak self] data in
                guard let self else { return }
                guard let url = URL(string: data.storeImage) else { return }
                self.storeSearchBottomSheet.searchResultView.imageView.kf.setImage(with: url)
                self.storeSearchBottomSheet.searchResultView.storeNameLabel.text = data.storeName
                self.storeSearchBottomSheet.searchResultView.storeId = data.storeID
                self.storeSearchBottomSheet.searchResultView.tagRelay.accept(data.category)
            })
            .disposed(by: disposeBag)
        
        let markerDataObservable = reactor.state.compactMap { $0.regionSearchMarkerDatas }
            .observe(on: MainScheduler.instance)
            markerDataObservable.subscribe(onNext: { [weak self] markerData in
                guard let self else { return }
                self.mapMode = .regionSearch
                if let regionName = self.reactor?.currentState.searchRegionName {
                    self.regionSearchBottomSheet.aroundView.regionLabel.text = "[\(regionName)] 둘러보기"
                    self.navigationTitleLabel.text = regionName
                }
                DispatchQueue.global(qos: .default).async {
                    let markers = markerData.map { data in
                        let marker = NMFMarker(position: NMGLatLng(lat: data.latitude, lng: data.longitude))
                        marker.iconImage = NMFOverlayImage(name: "marker")
                        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
                        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
                        marker.captionText = data.storeName
                        marker.captionTextSize = 10
                        marker.captionColor = .runwayBlack
                        marker.captionHaloColor = .white
                        
                        marker.touchHandler = { [weak self] (overlay) -> Bool in
                            guard let self else { return true }
                            let action = Reactor.Action.selectMapMarkerData(data.storeID)
                            self.reactor?.action.onNext(action)
                            self.storeSearchBottomSheet.showSheet(atState: .expanded)
                            return true
                        }
                        
                        return marker
                    }
                    DispatchQueue.main.async {
                        self.markers = markers
                    }
                }
                
                if self.reactor?.currentState.mapMarkerSelectData == nil {
                    let lat = markerData.reduce(0.0, { $0 + $1.latitude }) / Double(markerData.count)
                    let lng = markerData.reduce(0.0, { $0 + $1.longitude }) / Double(markerData.count)
                    let cameraUpdate = NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: lat, lng: lng ), zoom: 12.0))
                    cameraUpdate.animation = .easeIn
                    self.mapView.mapView.moveCamera(cameraUpdate)
                }
                
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        switch mapMode {
        case .normal:
            isHiddenHelperViews.toggle()
        default:
            storeSearchBottomSheet.showSheet(atState: .folded)
        }
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if mapMode == .normal {
            searchButton.isHidden = false
        }
        let lat = mapView.cameraPosition.target.lat
        let lng = mapView.cameraPosition.target.lng
        let action = Reactor.Action.mapViewCameraPositionDidChanged((lat, lng))
        reactor?.action.onNext(action)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.setUserInitialLocation()
            }
        default:
            break
        }
    }
}
