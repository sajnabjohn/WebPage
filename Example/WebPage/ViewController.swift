//
//  baseViewController.swift
//  webViewVlaidation


import UIKit
import WebPage

class ViewController: UIViewController
{
    
    @IBOutlet weak var buttonOutlet: UIButton!
    var baseUrl: String                                 = ""
    var encodedBaseUrl: String                          = ""
    var customNavigation : UINavigationController       = UINavigationController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.green
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.green
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAction(_ sender: Any)
    {
        let VC                       = self.storyboard!.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        let baseUrl                  = "https://en.wikipedia.org/wiki/Wonders_of_the_World"
        VC.rootUrl                   = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        VC.activityIndicatorColor    = UIColor.green
        VC.navTitle                  = "Web View"
        
        if( navigationController    == nil)
        {
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
            self.setNavigationBar()
            VC.setNavigation         = UINavigationController()
            navigationController?.pushViewController(VC,animated: true)
        }
    }
    
    func setNavigationBar()
    {
        navigationController?.navigationBar.isHidden     = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        
    }
}



