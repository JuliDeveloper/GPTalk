import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    //MARK:- Properties
    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .backgroundColor
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .progressColor
        progressView.setProgress(0, animated: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureView()
        
        load()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             }
        )
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }
    
    //MARK:- Helpers
    private func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = .backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(reloadButtonClicked)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureView() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(progressView)
        view.addSubview(webView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            progressView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            webView.topAnchor.constraint(
                equalTo: progressView.bottomAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    private func load() {
        guard let url = URL(string: "https://chat.openai.com") else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs((webView.estimatedProgress) - 1.0) <= 0.0001
    }
    
    @objc private func reloadButtonClicked() {
        load()
    }
}



