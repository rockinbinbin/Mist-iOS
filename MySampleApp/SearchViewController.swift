//
//  SearchViewController.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        view.setNeedsUpdateConstraints()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .blackColor()
        
        navigationController?.navigationBar.tintColor = .blackColor()
        
        navigationItem.titleView = searchField
        
        addTapGestureRecognizer()
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - UI Components
    
    private lazy var searchField: UITextField = {
        let field: UITextField = UITextField(frame: CGRectMake(-40, 0, self.navigationController!.navigationBar.frame.size.width, 21))
        field.font = UIFont(name: "Lato-Regular", size: 15)
        field.placeholder = "Search by product, brand, and more"
        field.returnKeyType = .Search
        field.delegate = self
        return field
    }()
    
    // MARK: - Placeholder
    
    private lazy var placeholderView: UIView = {
        let view = UIView(frame: self.view.bounds)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor(white: 0.97, alpha: 1).CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var suggestedLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "SUGGESTED", attributes: [
            NSFontAttributeName: UIFont(name: "Lato-Bold", size: 15)!,
            NSKernAttributeName: 2.0,
            NSForegroundColorAttributeName: UIColor.blackColor()
            ])
        
        self.placeholderView.addSubview(label)
        return label
    }()
    
    private lazy var suggestionTitles = ["Men's", "Women's", "Kids", "Lifestyle", "Beauty"]
    
    private lazy var suggestionButtons: [UIButton] = {
        return self.suggestionTitles.map({
            let button = UIButton()
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 15)
            button.setTitle($0, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.addTarget(self, action: #selector(SearchViewController.suggestionPressed), forControlEvents: .TouchUpInside)
            self.placeholderView.addSubview(button)
            return button
        })
    }()
    
    private lazy var previousSearchesLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "PREVIOUS SEARCHES", attributes: [
            NSFontAttributeName: UIFont(name: "Lato-Bold", size: 15)!,
            NSKernAttributeName: 2.0,
            NSForegroundColorAttributeName: UIColor.blackColor()
            ])
        
        self.placeholderView.addSubview(label)
        return label
    }()
    
    private lazy var previousSearches = [String](count: 5, repeatedValue: "")
    
    private lazy var previousSearchesButtons: [UIButton] = {
        var buttons: [UIButton] = self.previousSearches.map({
            let button = UIButton()
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 15)
            button.setTitle($0, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.addTarget(self, action: #selector(SearchViewController.previousSearchPressed), forControlEvents: .TouchUpInside)
            
            if $0 == "" {
                button.enabled = false
            }
            
            self.placeholderView.addSubview(button)
            return button
        })
        
        let hasNoPreviousSearches = self.previousSearches.filter({$0 != ""}).count == 0
        
        if hasNoPreviousSearches {
            buttons[0].setTitle("None yet!", forState: .Normal)
            buttons[0].setTitleColor(UIColor(white: 0, alpha: 0.32), forState: .Normal)
            buttons[0].enabled = false
        }
        
        return buttons
    }()
    
    private func refreshPreviousSearches() {
        
        // Must have least one non-empty search string
        guard self.previousSearches.filter({$0 != ""}).count != 0 else {
            return
        }
        
        for (index, search) in previousSearches.enumerate() {
            let button = previousSearchesButtons[index]
            
            guard search != "" else {
                continue
            }
            
            button.setTitle(search, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.enabled = true
        }
    }
    
    private func addRecentSearch(query: String) {
        previousSearches.shiftRightInPlace(-1)
        previousSearches[0] = query
        refreshPreviousSearches()
    }
    
    func suggestionPressed(sender: UIButton) {
        let query = sender.currentTitle!
        searchField.text = query
        search(query)
    }
    
    func previousSearchPressed(sender: UIButton) {
        let query = sender.currentTitle!
        searchField.text = query
        search(query)
    }
    
    // MARK: - Layout
    
    override func updateViewConstraints() {
        
        placeholderView.pinToEdgesOfSuperview()
        
        suggestedLabel.pinToTopEdgeOfSuperview(offset: 50)
        suggestedLabel.centerHorizontallyInSuperview()
        
        for button in suggestionButtons {
            if button == suggestionButtons.first {
                button.positionBelowItem(suggestedLabel, offset: 20)
            } else {
                button.positionBelowItem(suggestionButtons[suggestionTitles.indexOf(button.currentTitle!)! - 1], offset: 8)
            }
            
            button.centerHorizontallyInSuperview()
        }
        
        previousSearchesLabel.centerHorizontallyInSuperview()
        previousSearchesLabel.positionBelowItem(suggestionButtons.last!, offset: 40)
        
        for button in previousSearchesButtons {
            if button == previousSearchesButtons.first {
                button.positionBelowItem(previousSearchesLabel, offset: 20)
            } else {
                button.positionBelowItem(previousSearchesButtons[previousSearchesButtons.indexOf(button)! - 1], offset: 8)
            }
            
            button.centerHorizontallyInSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Navigation
    
    func dismiss() {
        self.searchField.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.shouldResignFirstResponder))
        view.addGestureRecognizer(tap)
    }
    
    func shouldResignFirstResponder() {
        searchField.resignFirstResponder()
    }
    
    // MARK: - Search
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let query = textField.text where query != "" else {
            return
        }
        
        addRecentSearch(query)
        search(query)
    }
    
    private func search(query: String) {
        UIView.animateWithDuration(0.2, animations: {
            self.placeholderView.layer.opacity = 0
        })
    }
}

// MARK: - Array shifting

extension Array {
    func shiftRight(amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}

