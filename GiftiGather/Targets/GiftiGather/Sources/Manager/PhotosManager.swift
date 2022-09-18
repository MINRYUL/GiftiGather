//
//  PhotoManager.swift
//  DomainTests
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import Photos
import Vision

import RxSwift
import RxCocoa

final class PhotosManager {
  static var shared = PhotosManager()
  
  //MARK: - Property
  private let _allImages = PHAsset.fetchAssets(with: .image, options: nil)
  
  //MARK: - Output
  let gifticonFetchProgress: Driver<Double?>
  
  //MARK: - Private Output
  private var _gifticonFetchProgress = PublishSubject<Double?>()
  
  private var _disposeBag: DisposeBag = DisposeBag()
  
  private init() {
    self.gifticonFetchProgress = self._gifticonFetchProgress.asDriver(onErrorJustReturn: nil)
  }
  
  func startFetchGifticon() -> Observable<[String]> {
    self._gifticonFetchProgress.onNext(0)
    
    return Observable.create() { emitter in
      let dispatchGroup = DispatchGroup()
      var existBarcodeImageIdentifiers = [String]()
      var checkImageCount: Double = 0
      dispatchGroup.enter()
      
      for i in 0..<self._allImages.count {
        let imageAsset = self._allImages[i]
        
        PhotosManager.fetchImageWithIdentifier(
          imageAsset.localIdentifier,
          targetSize: CGSize(width: 360, height: 360)
        ).asObservable()
          .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
          .subscribe(onNext : { (image, identifier) in
            guard let image = image,
                  let cgImage = image.cgImage else { return }
            
            var _vnBarCodeDetectionRequest: VNDetectBarcodesRequest {
              let request = VNDetectBarcodesRequest { [unowned self] (request, error) in
                dispatchGroup.leave()
                checkImageCount += 1
                self._gifticonFetchProgress.onNext(checkImageCount/Double(self._allImages.count))
                if let _ = error as NSError? {
                  ///이미지 내 바코드 검색 실패
                  return
                } else {
                  guard let _ = request.results as? [VNDetectedObjectObservation]  else { return }
                  ///이미지 내 바코드 검색 성공
                  existBarcodeImageIdentifiers.append(identifier)
                }
              }
              return request
            }
            
            let requestHandler = VNImageRequestHandler(
              cgImage: cgImage,
              orientation: CGImagePropertyOrientation(image.imageOrientation),
              options: [:]
            )
            let vnRequests = [_vnBarCodeDetectionRequest]
            dispatchGroup.enter()
            try? requestHandler.perform(vnRequests)
          })
          .disposed(by: self._disposeBag)
      }
      
      dispatchGroup.leave()
      dispatchGroup.notify(queue: DispatchQueue.main) {
        emitter.onNext(existBarcodeImageIdentifiers)
        self._disposeBag = DisposeBag()
      }
      return Disposables.create()
    }
  }
  
  class func fetchAssetsWithIdentifiers(
    _ identifiers: [String], options: PHFetchOptions?
  ) -> PHFetchResult<PHAsset> {
    return PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: options)
  }
  
  ///targetSize: PHImageManagerMaximumSize 원본 사이즈 fetch
  class func fetchImageWithIdentifier(
    _ identifier: String, targetSize: CGSize
  ) -> Driver<(UIImage?, String)> {
    let fetchAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
    let imageManager = PHImageManager()
    
    guard let asset = fetchAssets.firstObject else {
      return Observable<(UIImage?, String)>
        .just((nil, identifier))
        .asDriver(onErrorJustReturn: (nil, identifier))
    }
    
    return Observable<(UIImage?, String)>.create() { emitter in
      imageManager.requestImage(
        for: asset,
        targetSize: targetSize,
        contentMode: .aspectFill,
        options: nil,
        resultHandler: { image, _ in
          emitter.onNext((image, identifier))
          emitter.onCompleted()
        })
      return Disposables.create()
    }.asDriver(onErrorJustReturn: (nil, identifier))
  }
}
