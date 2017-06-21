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
        
        view.backgroundColor = .white
        view.setNeedsUpdateConstraints()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.titleView = searchField
        
        addTapGestureRecognizer()
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - UI Components
    
    fileprivate lazy var searchField: UITextField = {
        let field: UITextField = UITextField(frame: CGRect(x: -40, y: 0, width: self.navigationController!.navigationBar.frame.size.width, height: 21))
        field.font = UIFont.LatoRegularMedium()
        field.placeholder = "Search by product, brand, and more"
        field.returnKeyType = .search
        field.delegate = self
        return field
    }()
    
    // MARK: Placeholder
    
    fileprivate lazy var placeholderView: UIView = {
        let view = UIView(frame: self.view.bounds)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor(white: 0.97, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        
        self.view.addSubview(view)
        return view
    }()
    
    // MARK: Suggested Searches
    
    fileprivate lazy var suggestedLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "SUGGESTED", attributes: [
            NSFontAttributeName: UIFont.LatoBoldMedium(),
            NSKernAttributeName: 2.0,
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        self.placeholderView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var suggestionTitles = ["Men's", "Women's", "Kids", "Lifestyle", "Beauty"]
    
    fileprivate lazy var suggestionButtons: [UIButton] = {
        return self.suggestionTitles.map({
            let button = UIButton()
            button.titleLabel?.font = UIFont.LatoRegularMedium()
            button.setTitle($0, for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.addTarget(self, action: #selector(SearchViewController.suggestionPressed), for: .touchUpInside)
            self.placeholderView.addSubview(button)
            return button
        })
    }()
    
    // MARK: Previous Searches
    
    fileprivate lazy var previousSearchesLabel: UILabel = {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(string: "PREVIOUS SEARCHES", attributes: [
            NSFontAttributeName: UIFont.LatoBoldMedium(),
            NSKernAttributeName: 2.0,
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        self.placeholderView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var previousSearchesButtons: [UIButton] = {
        var buttons: [UIButton] = SearchManager.sharedInstance.previousSearches.map({
            let button = UIButton()
            button.titleLabel?.font = UIFont.LatoRegularMedium()
            button.setTitle($0, for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.addTarget(self, action: #selector(SearchViewController.previousSearchPressed), for: .touchUpInside)
            
            if $0 == "" {
                button.isEnabled = false
            }
            
            self.placeholderView.addSubview(button)
            return button
        })
        
        let hasNoPreviousSearches = SearchManager.sharedInstance.previousSearches.filter({$0 != ""}).count == 0
        
        if hasNoPreviousSearches {
            buttons[0].setTitle("None yet!", for: UIControlState())
            buttons[0].setTitleColor(UIColor(white: 0, alpha: 0.32), for: UIControlState())
            buttons[0].isEnabled = false
        }
        
        return buttons
    }()
    
    // MARK: Search Results
    
    fileprivate lazy var searchResultsView: SearchResultsView = {
        let searchResultsView = SearchResultsView()
        searchResultsView.isHidden = true
        self.view.addSubview(searchResultsView)
        return searchResultsView
    }()
    
    func suggestionPressed(_ sender: UIButton) {
        let query = sender.currentTitle!
        searchField.text = query
        search(query)
    }
    
    func previousSearchPressed(_ sender: UIButton) {
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
                button.positionBelowItem(suggestionButtons[suggestionTitles.index(of: button.currentTitle!)! - 1], offset: 8)
            }
            
            button.centerHorizontallyInSuperview()
        }
        
        previousSearchesLabel.centerHorizontallyInSuperview()
        previousSearchesLabel.positionBelowItem(suggestionButtons.last!, offset: 40)
        
        for button in previousSearchesButtons {
            if button == previousSearchesButtons.first {
                button.positionBelowItem(previousSearchesLabel, offset: 20)
            } else {
                button.positionBelowItem(previousSearchesButtons[previousSearchesButtons.index(of: button)! - 1], offset: 8)
            }
            
            button.centerHorizontallyInSuperview()
        }
        
        self.searchResultsView.pinToEdgesOfSuperview()
        
        super.updateViewConstraints()
    }
    
    // MARK: - Navigation
    
    func dismiss() {
        self.searchField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.shouldResignFirstResponder))
        view.addGestureRecognizer(tap)
    }
    
    func shouldResignFirstResponder() {
        searchField.resignFirstResponder()
    }
    
    // MARK: - Search
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let query = textField.text, query != "" else {
            return
        }
        
        SearchManager.sharedInstance.addRecentSearch(query)
        refreshPreviousSearches()
        search(query)
    }
    
    fileprivate func search(_ query: String) {
        
        let searchCompletion = { (products: [Feed.Item], brands: [SearchResult.Brand]) -> Void in
            DispatchQueue.main.async {
                self.searchResultsView.updateSearchResults(products, brands: brands)
                
                /**
                 NOTE: Since updateSearchResults is done completely locally, it will return almost
                 immediately. This means that the delay of 0.2 will delay the function call to
                 almost exactly after the placeholderView is hidden. If an async search function
                 is used in the future, the delay of 0.2 could make the animation be slower
                 than it could be.
                 */
                self.animateView(self.searchResultsView, action: .show, duration: 0.2, delay: 0.2)
            }
        }
        
        SearchManager.sharedInstance.search(query, completion: searchCompletion)
        
        animateView(placeholderView, action: .hide, duration: 0.2)
        
    }
    
    fileprivate func refreshPreviousSearches() {
        
        // Must have least one non-empty search string
        guard SearchManager.sharedInstance.previousSearches.filter({$0 != ""}).count != 0 else {
            return
        }
        
        for (index, search) in SearchManager.sharedInstance.previousSearches.enumerated() {
            let button = previousSearchesButtons[index]
            
            guard search != "" else {
                continue
            }
            
            button.setTitle(search, for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.isEnabled = true
        }
    }
    
    // MARK: - Animation
    
    enum AnimationAction {
        case show
        case hide
    }
    
    func animateView(_ view: UIView, action: AnimationAction, duration: TimeInterval, delay: TimeInterval = 0) {
        
        let show = action == .show
        
        view.layer.opacity = show ? 0 : 1
        view.isUserInteractionEnabled = show ? false : true
        view.isHidden = show ? false : true
        
        let animations = {
            view.layer.opacity = show ? 1 : 0
        }
        
        let completion = { (animated: Bool) -> Void in
            view.isUserInteractionEnabled = show ? true : false
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions(), animations: animations, completion: completion)
    }
}

