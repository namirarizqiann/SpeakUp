//
//  PageViewController.swift
//  ExploreApp
//
//  Created by Fanny Halim on 12/04/21.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var buttonUp: UIButton!
    
    
    lazy var vcList: [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(identifier: "Story1VC")
        let vc2 = sb.instantiateViewController(identifier: "Story2VC")
        let vc3 = sb.instantiateViewController(identifier: "Story3VC")
        
        return [vc1, vc2, vc3]
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        
        if let firstVC = vcList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcList.firstIndex(of: viewController) else { return nil }
        
        let prevIndex = vcIndex - 1
        
        guard prevIndex >= 0 else { return nil }
        
        guard vcList.count > prevIndex else { return nil }
        
        return vcList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard vcList.count != nextIndex else { return nil }
        
        guard vcList.count > nextIndex else { return nil }
        
        return vcList[nextIndex]
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
