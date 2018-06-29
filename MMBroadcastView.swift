//
//  MMBroadcastView.swift
//  CellImageBrowserDemo
//
//  Created by LX on 2018/5/27.
//  Copyright © 2018年 LX. All rights reserved.
//

import UIKit
import SnapKit

protocol MMBroadcastViewDelegate:NSObjectProtocol {
    func BroadcastViewTaped(_ index :Int)
}
class MMBroadcastView: UIView {

    fileprivate var mainScrollView:UIScrollView!
    weak open var delegate :MMBroadcastViewDelegate?
    
    fileprivate var dots :UIPageControl!
    fileprivate var currentIndex:Int = 0
    
    var images :[String]!{
        didSet{
            for index in 0..<images.count {
                let view = MMImageView(frame:CGRect(x: CGFloat(index) * WIDTH, y: CGFloat(0), width: WIDTH, height: self.bounds.size.height))
                view.setImage(images[index], UIImage.init())
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked))
                view.addGestureRecognizer(tap)
                mainScrollView.addSubview(view)
            }
            let view = MMImageView(frame:CGRect(x: CGFloat(images.count) * WIDTH, y: CGFloat(0), width: WIDTH, height: self.bounds.size.height))
            view.setImage(images.first, UIImage.init())
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked))
            view.addGestureRecognizer(tap)
            mainScrollView.addSubview(view)
            
            mainScrollView.contentSize = CGSize(width: WIDTH * CGFloat(images.count + 1), height: self.bounds.size.height)
            dots = UIPageControl(frame: CGRect(x: WIDTH-60, y: self.bounds.size.height - 50, width: 50, height: 30))
            dots.pageIndicatorTintColor = UIColor.black
            dots.currentPageIndicatorTintColor = UIColor.white
            dots.numberOfPages = images.count
            dots.currentPage  = 0
            self.addSubview(dots)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainScrollView = UIScrollView(frame: self.bounds)
        mainScrollView.delegate = self
        mainScrollView.backgroundColor = UIColor.yellow
        mainScrollView.isPagingEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(mainScrollView)
        mainScrollView.delegate = self
    }
    
    @objc func tapClicked(){
        delegate?.BroadcastViewTaped(currentIndex)
    }
}

extension MMBroadcastView:UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offx = Int(scrollView.contentOffset.x / WIDTH)
        print(scrollView.contentOffset.x)
        if offx == currentIndex {
            return
        }
        currentIndex = offx
        dots.currentPage = Int(offx)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x >= WIDTH * CGFloat(images.count)){
            mainScrollView .setContentOffset(CGPoint.zero, animated: false)
            dots.currentPage = 0
        }
    }
}
