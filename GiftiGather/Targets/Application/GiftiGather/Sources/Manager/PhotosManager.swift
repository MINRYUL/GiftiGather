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
  //MARK: - Type Property
  static var shared = PhotosManager()
  
  //MARK: - Output
  let gifticonFetchProgress: Driver<Double?>
  
  //MARK: - Private Output
  private var _gifticonFetchProgress = PublishSubject<Double?>()
  
  private var _disposeBag: DisposeBag = DisposeBag()
  
  private init() {
    self.gifticonFetchProgress = self._gifticonFetchProgress.asDriver(onErrorJustReturn: nil)
  }
  
  func fetchGifticon() -> Observable<[String]> {
    self._gifticonFetchProgress.onNext(0)
    let lock = NSRecursiveLock()
    
    return Observable.create() { [unowned self] emitter in
      let dispatchGroup = DispatchGroup()
      let allImageAssets = PHAsset.fetchAssets(with: .image, options: nil)
      var existBarcodeImageIdentifiers = [String]()
      var checkImageCount: Double = 0
      dispatchGroup.enter()
      
      for i in 0..<allImageAssets.count {
        let imageAsset = allImageAssets[i]
        dispatchGroup.enter()
        
        PhotosManager.fetchImageWithIdentifier(
          imageAsset.localIdentifier,
          targetSize: CGSize(width: 300, height: 400)
        ).asObservable()
          .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
          .subscribe(onNext : { (image, identifier) in
            guard let image = image,
                  let ciImage = CIImage(image: image) else { return }
            
            var _vnBarCodeDetectionRequest: VNDetectBarcodesRequest {
              let request = VNDetectBarcodesRequest { [unowned self] (request, error) in
                checkImageCount += 1
                lock.lock()
                self._gifticonFetchProgress.onNext(checkImageCount/Double(allImageAssets.count))
                lock.unlock()
                if let _ = error as NSError? {
                  ///이미지 내 바코드 검색 실패
                  dispatchGroup.leave()
                  return
                } else {
                  guard let barcodes = request.results else {
                    dispatchGroup.leave()
                    return
                  }
                  ///이미지 내 바코드 검색 성공
                  for barcode in barcodes {
                    guard let _ = barcode as? VNBarcodeObservation else {
                      dispatchGroup.leave()
                      return
                    }
                    
                    existBarcodeImageIdentifiers.append(identifier)
                    dispatchGroup.leave()
                    return
                  }
                }
                
                dispatchGroup.leave()
              }
              if #available(iOS 16, *) { request.revision = VNDetectBarcodesRequestRevision1 }
              return request
            }
            
            let requestHandler = VNImageRequestHandler(
              ciImage: ciImage,
              orientation: CGImagePropertyOrientation(image.imageOrientation)
            )
            let vnRequests = [_vnBarCodeDetectionRequest]
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
  
  func fetchAllIdentifier() -> Observable<[String]> {
    self._gifticonFetchProgress.onNext(0)
    
    return Observable.create() { [unowned self] emitter in
      let allImageAssets = PHAsset.fetchAssets(with: .image, options: nil)
      var imageIdentifiers = [String]()
      var checkImageCount: Double = 0
      
      for i in 0..<allImageAssets.count {
        let imageAsset = allImageAssets[i]
        imageIdentifiers.append(imageAsset.localIdentifier)
        checkImageCount += 1
        self._gifticonFetchProgress.onNext(checkImageCount/Double(allImageAssets.count))
      }
      
      emitter.onNext(imageIdentifiers)
      return Disposables.create()
    }
  }
}

//MARK: - Type Method
extension PhotosManager {
  ///targetSize: PHImageManagerMaximumSize 원본 사이즈 fetch
  class func fetchImageWithIdentifier(
    _ identifier: String,
    targetSize: CGSize,
    option: PHFetchOptions? = nil,
    imageOption: PHImageRequestOptions = PHImageRequestOptions()
  ) -> Driver<(UIImage?, String)> {
    imageOption.isNetworkAccessAllowed = true
    imageOption.deliveryMode = .highQualityFormat
    
    let fetchAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: option)
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
        contentMode: .aspectFit,
        options: imageOption,
        resultHandler: { image, _ in
          emitter.onNext((image, identifier))
          emitter.onCompleted()
        })
      return Disposables.create()
    }
    .take(1)
    .asDriver(onErrorJustReturn: (nil, identifier))
  }
}
