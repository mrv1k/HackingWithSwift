//
//  ViewController.swift
//  MyProject4
//
//  Created by Viktor Khotimchenko on 2021-02-01.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]

    override func loadView() {
        super.loadView()

        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(openTapped))

        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh,
                                        target: webView,
                                        action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)

        let goForward = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: webView, action: #selector(webView.goForward))
        let goBack = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: webView, action: #selector(webView.goBack))
        goForward.isEnabled = false
        goBack.isEnabled = false

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)

        toolbarItems = [goBack, spacer, goForward, spacer, progressButton, spacer, refresher]
        navigationController?.isToolbarHidden = false

        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)

        let url = URL(string: "https://www.\(websites[0])")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)

        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        switch keyPath {
        case "estimatedProgress":
            progressView.progress = Float(webView.estimatedProgress)
        case "canGoBack":
            let goBackButton = toolbarItems![0]
            let canGo = change?.values.allSatisfy({ $0 as! Int == 1 }) ?? false
            goBackButton.isEnabled = canGo
        case "canGoForward":
            let goForwardButton = toolbarItems![2]
            let canGo = change?.values.allSatisfy({ $0 as! Int == 1 }) ?? false
            goForwardButton.isEnabled = canGo
        default:
            break
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        guard url != URL(string: "about:blank") else { return decisionHandler(.allow) }

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        // If users try to visit a URL that isn’t allowed, show an alert saying it’s blocked.
        let ac = UIAlertController(title: "Blocked",
                                   message: "This resource is not allowed",
                                   preferredStyle: .alert)
        ac.addAction(.init(title: "Okay", style: .default))
        present(ac, animated: true)
        decisionHandler(.cancel)
    }
}
