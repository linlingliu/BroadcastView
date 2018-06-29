//
//  MMImageView.swift
//  CellImageBrowserDemo
//
//  Created by LX on 2018/5/24.
//  Copyright © 2018年 LX. All rights reserved.
//

import UIKit
import Kingfisher

let WIDTH = UIScreen.main.bounds.size.width
let HEIGHT = UIScreen.main.bounds.size.height
let DEFAULT_HEIGHT = WIDTH * 9 / 16
let kScrollViewMargin = 10

protocol MMImageViewDelegate {
    func singleTapped()
}

class MMImageView: UIView {
    
    var delegate :MMImageViewDelegate?
    fileprivate var sView :UIScrollView!
    fileprivate var imageView :UIImageView! =  UIImageView()
    fileprivate var width :CGFloat = 0.0
    var imageUrl :String = ""
    fileprivate var hasLoadImage:Bool = false
    fileprivate var placedolder :UIImage = UIImage.init()
    fileprivate let btnReload :UIButton? = UIButton.init()
    fileprivate var indicatorView:MMIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        let double = UITapGestureRecognizer.init(target: self, action: #selector(doubleClicked(_:)))
        double.numberOfTapsRequired = 1
        double.numberOfTouchesRequired = 2
        self.addGestureRecognizer(double)
        
        let single = UITapGestureRecognizer.init(target: self, action: #selector(singleClicked(_:)))
        single.numberOfTouchesRequired = 1
        single.numberOfTapsRequired = 1
        self.addGestureRecognizer(single)
        
        single.require(toFail: double)
        
        hasLoadImage = false
        imageUrl = ""
        width = frame.size.width - CGFloat(2 * kScrollViewMargin)
        sView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: HEIGHT))
        sView.delegate = self
        sView.isUserInteractionEnabled = true
        sView.minimumZoomScale = 1.0
        sView.maximumZoomScale = 2.0
        sView.backgroundColor = UIColor.black
        self .addSubview(sView)
        imageView.frame = self.bounds
        self.addSubview(imageView!)
        indicatorView = MMIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(42), height: CGFloat(42)))
        indicatorView.center = self.center
        self.addSubview(indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetZoom(){
        sView.zoomScale = 1.0
    }
    
    func setImage(_ url:String?, _ plached:UIImage) {
        guard let imageurl = url else {
            return ;
        }
        if btnReload != nil {
            btnReload?.removeFromSuperview()
        }
        imageUrl = imageurl
        placedolder = plached
        imageView.kf.setImage(with: ImageResource.init(downloadURL: URL(string: imageUrl)!), placeholder: placedolder, options: [KingfisherOptionsInfoItem.fromMemoryCacheOrRefresh], progressBlock: { (progress, total) in
            self.indicatorView.progress = CGFloat(progress) / CGFloat(total)
        })  { (image, error, cacheType, url) in
            if (self.indicatorView != nil) {
                self.indicatorView.removeFromSuperview()
                self.indicatorView = nil
            }
        }
        
    }
    
    
}

extension MMImageView
{
   @objc func doubleClicked(_ tap:UITapGestureRecognizer)  {
    return ;
    }
   @objc func singleClicked(_ tap:UITapGestureRecognizer)  {
    delegate?.singleTapped()
    }
    
}
extension MMImageView
{
    func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
        return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a / 255.0)
    }
}

extension MMImageView:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
