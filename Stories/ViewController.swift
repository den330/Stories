//
//  ViewController.swift
//  Stories
//
//  Created by 330Mac on 2018-12-03.
//  Copyright © 2018 Yaxin Yuan. All rights reserved.
//

import UIKit
import SearchTextField




class ViewController: UIViewController {

    @IBOutlet weak var searchField: SearchTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var storyTableView: UITableView!
    
    struct CellInfo{
        static let nibName = "StoryCell"
    }
    
    var nextURLStr: String?
    
    var originalStories: [Story]?{
        didSet{
            if let stories = originalStories{
                let titles = stories.map{
                    return $0.title ?? ""
                }
                self.searchField.filterStrings(titles)
            }
            self.stories = originalStories
        }
    }
    
    var stories: [Story]?{
        didSet{
            guard let _ = stories else{
                return
            }
            self.storyTableView.reloadData()
        }
    }
    
    enum CurrentStatus{
        case connecting
        case success(stories: [Story])
        case failed(reason: String)
        case search(stories: [Story])
    }
    
    var currentStatus: CurrentStatus?{
        didSet{
            guard let currentStatus = currentStatus else{
                return
            }
            switch currentStatus {
            case .connecting:
                self.showProgressIndicator(should: true)
                self.showErrorLabel(should: false)
            case .success(let stories):
                
                if self.originalStories != nil{
                    if !self.originalStories!.isEmpty{
                        self.originalStories! += stories
                    }else{
                        self.originalStories = stories
                    }
                }else{
                    self.originalStories = stories
                }
                self.showProgressIndicator(should: false)
                self.showErrorLabel(should: false)
            case .failed(let reason):
                self.showErrorLabel(should: true, errorInfo: reason)
                self.showProgressIndicator(should: false)
            case .search(let stories):
                self.storyTableView.setContentOffset(.init(x: 0, y: -30), animated: false)
                self.storyTableView.layoutIfNeeded()
                self.stories = stories
                self.showProgressIndicator(should: false)
                self.showErrorLabel(should: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchField.delegate = self
        self.searchField.addTarget(self, action: #selector(changeSpotted(_:)), for: .editingChanged)
        self.storyTableView.contentInset.top = 30
        let storyNib = UINib(nibName: CellInfo.nibName, bundle: nil)
        self.storyTableView.register(storyNib, forCellReuseIdentifier: CellInfo.nibName)
        self.currentStatus = .connecting
        self.storyTableView.dataSource = self
        self.storyTableView.delegate = self
        self.getStories()
    }
    
    func getStories(urlStr: String?=nil){
        NetworkClass.getStories(withUrlStr: urlStr, completion: { stories, nextUrl, err in
            DispatchQueue.main.async {
                if let err = err{
                    self.currentStatus = .failed(reason: err.localizedDescription)
                    return
                }
                
                if let nextUrl = nextUrl{
                    self.nextURLStr = nextUrl
                }
                
                if let stories = stories{
                    
                    self.currentStatus = .success(stories: stories)
                }
            }
        })
    }
    
    @objc func changeSpotted(_ textField: UITextField){
        guard let str = textField.text else{
            return
        }
        
        if str.isEmpty{
            self.stories = originalStories
            textField.resignFirstResponder()
            return
        }
        
        guard let originalStories = originalStories else{
            return
        }
        
        
        let filteredStories = originalStories.filter{
            $0.title!.lowercased().contains(str.lowercased())
        }
        self.currentStatus = .search(stories: filteredStories)
    }
    
    func showProgressIndicator(should: Bool){
        self.activityIndicatorView.isHidden = !should
        if should{
            self.activityIndicatorView.startAnimating()
        }else{
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func showErrorLabel(should: Bool, errorInfo: String?=nil){
        self.errorLabel.isHidden = !should
        self.errorLabel.text = errorInfo ?? "An error occurs"
    }
    
    func loadmore(){
        guard let nextUrlStr = self.nextURLStr else{
            print("no next url")
            return
        }
        
        print("nexturl is \(nextUrlStr)")
        self.nextURLStr = nil
        self.getStories(urlStr: nextUrlStr)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellInfo.nibName, for: indexPath) as! StoryCell
        cell.configure(story: stories![indexPath.row])
        
        if indexPath.row == stories!.count - 1{
            loadmore()
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}





