//
//  StartViewController.swift
//  Mist
//
//  Created by Robin Mehta on 12/10/17.
//

import Foundation
import UIKit
import PureLayout

class StartViewController: UIViewController {

    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.LatoBoldMedium()
        self.view.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "GradientUnderwater")!)

        label.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoSetDimension(.width, toSize: self.view.frame.size.width - 20)
        label.sizeToFit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.styleNavBar()
//        self.navigationItem.styleTitleView(str: "M👀D")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
