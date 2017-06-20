//
//  FilterView.swift
//  Mist
//
//  Created by Steven on 7/8/16.
//
//

import UIKit

protocol FilterDelegate {
    func didUpdateFilters()
}

class FilterView: UIView {
    
    // MARK: - Layout
    
    init() {
        super.init(frame: CGRect.zero)
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Delegate
    
    var delegate: FilterDelegate? = nil
    
    // MARK: - UI Components
    
    fileprivate lazy var blackOverlay: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.layer.opacity = 0.0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
        self.addSubview(view)
        return view
    }()
    
    fileprivate lazy var filterView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        self.addSubview(view)
        return view
    }()
    
    fileprivate lazy var doneButton: UIButton = {
        let button = UIButton()
        
        button.setAttributedTitle(NSAttributedString(string: "DONE", attributes: [
            NSForegroundColorAttributeName: Constants.Colors.DoneBlue,
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 13)!,
            NSKernAttributeName: 3.0
            ]), for: UIControlState())
        
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        self.filterView.addSubview(button)
        return button
    }()
    
    fileprivate lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "CATEGORIES", attributes: [
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 13)!,
            NSKernAttributeName: 3.0
            ])
        
        self.filterView.addSubview(label)
        return label
    }()
    
    class FilterButton: UIButton {
        
        var title: String
        
        var categoryFilter: Feed.Filter.Category? = nil
        var priceFilter: Feed.Filter.Price? = nil
        
        /**
         Used to determine if the collection view needs to be reloaded or not.
         */
        let initialPressedValue: Bool
        
        var didChangeFilter: Bool {
            get {
                return pressed != initialPressedValue
            }
        }
        
        // MARK: - Init
        
        init(categoryFilter: Feed.Filter.Category) {
            title = categoryFilter.description
            self.categoryFilter = categoryFilter
            
            pressed = Feed.Filters.sharedInstance.categories[categoryFilter]!
            initialPressedValue = pressed
            
            super.init(frame: CGRect.zero)
            
            setTitle(title, for: UIControlState())
            initHelper()
        }
        
        init(priceFilter: Feed.Filter.Price) {
            title = priceFilter.description
            self.priceFilter = priceFilter
            
            pressed = Feed.Filters.sharedInstance.price[priceFilter]!
            initialPressedValue = pressed
            
            super.init(frame: CGRect.zero)
            
            setTitle(title, for: UIControlState())
            initHelper()
        }
        
        fileprivate func initHelper() {
            setTitleColor(grey, for: UIControlState())
            titleLabel!.font = UIFont(name: "Lato-Regular", size: 13)
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            layer.masksToBounds = true
            
            addTarget(self, action: #selector(didPress), for: .touchUpInside)
        }
        
        // MARK: - UI Components
        
        fileprivate lazy var gradientView: UIView = {
            let view = UIView()
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: 1000, height: 50)
            
            let topColor = UIColor(red: 0, green: 178/255.0, blue: 1.0, alpha: 1)
            let bottomColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1)
            
            gradient.colors = [topColor.cgColor, bottomColor.cgColor]
            view.layer.insertSublayer(gradient, at: 0)
            self.setTitle(self.title, for: UIControlState())
            view.layer.opacity = 0.0
            
            self.addSubview(view)
            return view
        }()
        
        let grey = UIColor(white: 0.56, alpha: 1.0)
        
        // MARK: - Button Action
        
        func activateButton() {
            let label = self.titleLabel!
            label.removeFromSuperview()
            gradientView.layer.opacity = 0.9
            self.addSubview(label)
            setTitleColor(UIColor.white, for: UIControlState())
        }
        
        func deactivateButton() {
            setTitleColor(grey, for: UIControlState())
            bringSubview(toFront: titleLabel!)
            gradientView.layer.opacity = 0.0
        }
        
        var pressed: Bool = false {
            didSet {
                guard pressed != oldValue else {
                    return
                }
                
                if pressed {
                    activateButton()
                } else {
                    deactivateButton()
                }
            }
        }
        
        func didPress() {
            pressed = !pressed
            
            if let filter = priceFilter {
                Feed.Filters.sharedInstance.price[filter] = pressed
            } else if let filter = categoryFilter {
                Feed.Filters.sharedInstance.categories[filter] = pressed
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            title = ""
            initialPressedValue = false
            super.init(coder: aDecoder)
        }
    }
    
    fileprivate lazy var buttons: [FilterButton] = []
    
    fileprivate lazy var categoryButtons: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        
        var buttonWidths: [Double] = [68.0, 90.0, 61.0, 86.0, 72.0]
        let sum = buttonWidths.reduce(0, +)
        let totalWidth = Double(UIApplication.shared.keyWindow!.frame.size.width - 40)
        
        for (index, value) in buttonWidths.enumerated() {
            buttonWidths[index] = value / sum * totalWidth
        }
        
        var previousButton: UIButton? = nil
        
        for (index, category) in Feed.Filter.Category.allValues.enumerated() {
            let button = FilterButton(categoryFilter: category)
            self.buttons.append(button)
            
            if Feed.Filters.sharedInstance.categories[category]! {
                button.activateButton()
            }
            view.addSubview(button)
            button.pinToTopAndBottomEdgesOfSuperview()
            
            if category != Feed.Filter.Category.allValues.last {
                button.sizeToWidth(CGFloat(buttonWidths[index]))
            } else {
                button.pinToRightEdgeOfSuperview()
            }
            
            guard let adjacentButton = previousButton else {
                previousButton = button
                button.pinToLeftEdgeOfSuperview()
                continue
            }
            
            button.positionToTheRightOfItem(adjacentButton, offset: -1)
            previousButton = button
        }
        
        self.filterView.addSubview(view)
        return view
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "PRICE", attributes: [
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 13)!,
            NSKernAttributeName: 3.0
            ])
        
        self.filterView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var priceButtons: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        
        var buttonWidths: [Double] = [76.0, 71.0, 80.0, 92.0, 59.0]
        let sum = buttonWidths.reduce(0, +)
        let totalWidth = Double(UIApplication.shared.keyWindow!.frame.size.width - 40)
        
        for (index, value) in buttonWidths.enumerated() {
            buttonWidths[index] = value / sum * totalWidth
        }
        
        var previousButton: UIButton? = nil
        
        for (index, price) in Feed.Filter.Price.allValues.enumerated() {
            let button = FilterButton(priceFilter: price)
            self.buttons.append(button)
            
            if Feed.Filters.sharedInstance.price[price]! {
                button.activateButton()
            }
            
            view.addSubview(button)
            button.pinToTopAndBottomEdgesOfSuperview()
            
            if price != Feed.Filter.Price.allValues.last {
                button.sizeToWidth(CGFloat(buttonWidths[index]))
            } else {
                button.pinToRightEdgeOfSuperview()
            }
            
            guard let adjacentButton = previousButton else {
                previousButton = button
                button.pinToLeftEdgeOfSuperview()
                continue
            }
            
            button.positionToTheRightOfItem(adjacentButton, offset: -1)
            previousButton = button
        }
        
        self.filterView.addSubview(view)
        return view
    }()
    
    // MARK: - Layout
    
    var bottomConstraint: NSLayoutConstraint? = nil
    let height: CGFloat = 250
    
    func setViewConstraints() {
        blackOverlay.pinToEdgesOfSuperview()
        
        filterView.pinToSideEdgesOfSuperview()
        bottomConstraint = filterView.pinToBottomEdgeOfSuperview(offset: -height)
        filterView.sizeToHeight(height)
        
        doneButton.pinToTopEdgeOfSuperview(offset: 15)
        doneButton.pinToRightEdgeOfSuperview(offset: 20)
        
        categoryLabel.pinToTopEdgeOfSuperview(offset: 20)
        categoryLabel.pinToLeftEdgeOfSuperview(offset: 20)
        
        categoryButtons.pinToSideEdgesOfSuperview(offset: 20)
        categoryButtons.positionBelowItem(categoryLabel, offset: 20)
        categoryButtons.sizeToHeight(50)
        
        priceLabel.positionBelowItem(categoryButtons, offset: 20)
        priceLabel.pinToLeftEdgeOfSuperview(offset: 20)
        
        priceButtons.pinToSideEdgesOfSuperview(offset: 20)
        priceButtons.positionBelowItem(priceLabel, offset: 20)
        priceButtons.sizeToHeight(50)
    }
    
    // MARK: - Animation
    
    override func didMoveToSuperview() {
        
        layoutIfNeeded()
        self.bottomConstraint?.constant = 0
        setNeedsLayout()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.blackOverlay.layer.opacity = 1.0
            self.layoutIfNeeded()
        }) 
    }
    
    /**
     True if the filters were changed since the view was presented.
     Used to determine if the collection view needs to reload.
     */
    var filtersChanged: Bool {
        get {
            return buttons.map({return $0.didChangeFilter}).contains(true)
        }
    }
    
    // MARK: - Navigation
    
    func dismiss() {
        
        layoutIfNeeded()
        self.bottomConstraint?.constant = height
        setNeedsLayout()
        
        if self.filtersChanged {
            self.delegate?.didUpdateFilters()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.blackOverlay.layer.opacity = 0.0
            self.layoutIfNeeded()
            
            }, completion: { (Bool) -> Void in
                self.removeFromSuperview()
            }
        )
    }
}
