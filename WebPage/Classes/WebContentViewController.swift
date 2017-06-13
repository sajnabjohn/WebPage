//
//  ViewController.swift
//  WebContentView
//
//  Created on 06/06/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

public class WebContentViewController: UIViewController,UIWebViewDelegate
{
    private var errorLabel              : UILabel                   = UILabel()
    private var webView                 : UIWebView                 = UIWebView()
    private var activityIndicator       : UIActivityIndicatorView   = UIActivityIndicatorView()
    private var closeButton             : UIButton                  = UIButton()
    private var reachability            :Reachability?
    private var networkErrorLabel       :String     = "There's no network connection.Make sure you're connected to a Wi-Fi or mobile network and try again."
    private var invalidUrl              :String     = "This site can't be reached."
    private let closeButtonBackgroundColor          = UIColor.init(colorLiteralRed    : (100/255), green: (100/255), blue: (100/255), alpha: 1)
    public var activityIndicatorColor   :UIColor                    = UIColor.red
    public var setNavigation            :UINavigationController     = UINavigationController()
    public var navTitle                 : String                    = ""
    public var rootUrl                  :String                     = ""
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addReachability()
        self.checkReachability()
        self.configureWebView()
        self.configureErrorLabel()
        self.configureActivityIndicator()
        navigationItem.title = navTitle
    }
    
    override public func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // check for orientation change
    
    override public func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
    {
        self.changeFrameWithOrientation()
    }
    
    private func changeFrameWithOrientation()
    {
        self.webView.frame            = CGRect(origin: CGPoint.zero,size: UIScreen.main.bounds.size)
        errorLabel.frame              = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-30), height: 160)
        self.closeButton.frame        = CGRect(origin: CGPoint.zero,size: UIScreen.main.bounds.size)
        self.errorLabel.center        = view.center
        self.activityIndicator.center = view.center
    }
    
    // reachability
    
    private func addReachability()
    {
        reachability = Reachability.networkReachabilityForInternetConnection()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        _            = reachability?.startNotifier()
    }
    
    private func checkReachability()
    {
        guard let reachabilityObject = reachability else { return }
        
        if reachabilityObject.isReachable
        {
            webView.isHidden         = false
            errorLabel.isHidden      = true
            
            if(webView.request?.url?.absoluteString.characters.count == 0)
            {
                reloadPage(url: rootUrl)
            }
            else
            {
                if(webView.request  != nil)
                {
                    reloadPage(url: (webView.request?.url?.absoluteString)!)
                }
                else
                {
                    reloadPage(url: rootUrl)
                }
            }
        }
        else
        {
            self.showLabel()
            errorLabel.text          = networkErrorLabel
            if(navigationController == nil)
            {
                self.configureCloseButton()
            }
        }
    }
    
    private func reloadPage(url:String)
    {
        let url  = URL (string: url)
        if (url == nil)
        {
            self.showLabel()
            if(navigationController == nil)
            {
                self.configureCloseButton()
            }
        }
        else
        {
            let requestObj = URLRequest(url: url! as URL);
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    
    @objc private func reachabilityDidChange(_ notification: Notification)
    {
        checkReachability()
    }
    
    // to show alert labels
    
    private func showLabel()
    {
        webView.isHidden                    = true
        errorLabel.isHidden                 = false
        errorLabel.text                     = invalidUrl
        activityIndicator.stopAnimating()
    }
    
    // configure views
    
    private func configureWebView()
    {
        self.webView.frame                  = CGRect(origin: CGPoint.zero,size: UIScreen.main.bounds.size)
        self.view.addSubview(webView)
        webView.delegate                    = self
    }
    
    private func configureCloseButton()
    {
        self.closeButton.frame              = CGRect(origin: CGPoint.zero,size: UIScreen.main.bounds.size)
        self.closeButton.backgroundColor    = closeButtonBackgroundColor
        let closeImage                      = UIImage(named: "close")
        self.closeButton.setBackgroundImage(closeImage,for: [])
        self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    private func configureActivityIndicator()
    {
        self.activityIndicator              = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        self.activityIndicator.color        = activityIndicatorColor
        activityIndicator.center            = view.center
        activityIndicator.hidesWhenStopped  = true
        view.addSubview(activityIndicator)
    }
    
    private func configureErrorLabel()
    {
        errorLabel.frame                    = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-30), height: 160)
        errorLabel.center                   = view.center
        errorLabel.lineBreakMode            = NSLineBreakMode.byWordWrapping
        errorLabel.numberOfLines            = 0
        errorLabel.textAlignment            = .center
        errorLabel.text                     = ""
        self.view.addSubview(errorLabel)
    }
    
    @objc private func closeButtonAction(sender: UIButton!)
    {
        self.presentingViewController?.dismiss(animated: false, completion: nil);
    }
    
    // --> WebView Delegates
    
    public func webViewDidStartLoad(_: UIWebView)
    {
        if(navigationController == nil)
        {
            self.configureCloseButton()
        }
        activityIndicator.startAnimating()
    }
    
    public func webViewDidFinishLoad(_: UIWebView)
    {
        self.activityIndicator.stopAnimating()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        let error:NSError = error as NSError
        if (error.code   != NSURLErrorCancelled)
        {
            self.showLabel()
        }
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
    
    private func clearWebViewActions()
    {
        webView.delegate    = nil
        webView.stopLoading()
    }
    
    private func removeNotificationObservers()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
    }
    
    deinit
    {
        clearWebViewActions()
        reachability?.stopNotifier()
        removeNotificationObservers()
    }
}

