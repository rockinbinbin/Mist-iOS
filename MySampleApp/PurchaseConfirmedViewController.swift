//
//  PurchaseConfirmedViewController.swift
//  Mist
//
//  Created by Robin Mehta on 7/26/16.
//
//

import UIKit

// grab product data from productviewcontroller

extension UIImageView{
    
    func makeBlurImage(targetImageView:UIImageView?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    
}

class PurchaseConfirmedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Model
    
    var product: Feed.Item? = nil {
        didSet {
            guard product != nil else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
//                self.setPriceText("$\(Int(Double(self.product!.price)!))")
//                self.setTitleText(self.product!.name)
//                self.setCompanyText(self.product!.brand)
//                self.setDescriptionLabel(self.product!.description)
//                self.buyButton.price = Float(Double(self.product!.price)!)
//                self.viewBrandLabel?.text = "Browse more from \(self.product!.brand)"
            }
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    var imageHeight: CGFloat = 200
    private var imageHeightConstraint: NSLayoutConstraint? = nil
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        return imageView
    }()
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else {
                return
            }
            
            mainImageView.image = image
            imageHeight = (image.size.height / image.size.width) * self.view.frame.size.width
            imageHeightConstraint?.constant = imageHeight
        }
    }

    func setViewConstraints() {
        mainImageView.centerHorizontallyInSuperview()
        mainImageView.sizeToWidth(self.view.frame.size.width)
        mainImageView.sizeToHeight(self.view.frame.size.height)
        mainImageView.contentMode = .ScaleAspectFill
        mainImageView.makeBlurImage(mainImageView)
        
    }


}
