//
//  ViewController.swift
//  TableInPageView
//
//  Created by Don Mag on 6/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

class MyPageViewController: UIPageViewController {
	
	var orderedViewControllers: [UIViewController] = [UIViewController]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let vc1 = storyboard?.instantiateViewController(withIdentifier: "Page1"),
			let vc2 = storyboard?.instantiateViewController(withIdentifier: "Page2"),
			let vc3 = storyboard?.instantiateViewController(withIdentifier: "Page3"),
			let vc4 = storyboard?.instantiateViewController(withIdentifier: "Page4")
			else {
				fatalError("Error instantiating bottom pages!")
		}

		orderedViewControllers.append(contentsOf: [vc1, vc2, vc3, vc4])
		
		dataSource = self
		
		if let firstViewController = orderedViewControllers.first {
			setViewControllers([firstViewController],
							   direction: .forward,
							   animated: true,
							   completion: nil)
		}
		
	}
	
}

extension MyPageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController,
							viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
			return nil
		}
		
		let previousIndex = viewControllerIndex - 1
		
		// User is on the first view controller and swiped left to loop to
		// the last view controller.
		guard previousIndex >= 0 else {
			return orderedViewControllers.last
		}
		
		guard orderedViewControllers.count > previousIndex else {
			return nil
		}
		
		return orderedViewControllers[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
			return nil
		}
		
		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count
		
		// User is on the last view controller and swiped right to loop to
		// the first view controller.
		guard orderedViewControllersCount != nextIndex else {
			return orderedViewControllers.first
		}
		
		guard orderedViewControllersCount > nextIndex else {
			return nil
		}
		
		return orderedViewControllers[nextIndex]
	}
	
}

// just for example - rounding corners of first subview
class BasePageViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let bkgView = view.subviews.first else {
			fatalError("Individual Page Views not setup correctly!")
		}
		bkgView.layer.cornerRadius = 8.0
		bkgView.layer.shadowColor = UIColor.black.cgColor
		bkgView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
		bkgView.layer.shadowRadius = 2.0
		bkgView.layer.shadowOpacity = 0.35
		
	}
	
}

class MyTestCell: UITableViewCell {
	@IBOutlet var theLabel: UILabel!
}

class FirstPageWithTableViewController: BasePageViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet var tableView: UITableView!
	
	var vHeight: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if vHeight != view.frame.height {
			vHeight = view.frame.height
			tableView.rowHeight = tableView.frame.height / 6.0
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 24
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "MyTestCell", for: indexPath) as! MyTestCell
		c.theLabel.text = "\(indexPath)"
		return c
	}
	
}

class SecondPageWithTableViewController: BasePageViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet var tableView: UITableView!
	
	let minimumRowHeight: CGFloat = 120
	
	var vHeight: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if vHeight != view.frame.height {
			vHeight = view.frame.height
			let nRows = Int(tableView.frame.height / minimumRowHeight)
			tableView.rowHeight = tableView.frame.height / CGFloat(nRows)
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 24
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "MyTestCell", for: indexPath) as! MyTestCell
		c.theLabel.text = "\(indexPath)"
		return c
	}
	
}
