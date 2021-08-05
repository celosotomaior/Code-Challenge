//
//  ViewController.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var result = [String:Any]()
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    // MARK:- variables for the viewController
    
    
    var arraySchools : [School]  = []
    var  selectedSchool: School?
    
    var textLoad = UILabel()
    
    var activityIndicator  = UIActivityIndicatorView()
    
    var messageFrame = UIView()
    
    var refreshcontrol : UIRefreshControl!
    
    
    var tableViewHeaderText = ""
    
    /// an enum of type TableAnimation - determines the animation to be applied to the tableViewCells
    var currentTableAnimation: TableAnimation = .fadeIn(duration: 0.85, delay: 0.03) {
        didSet {
            self.tableViewHeaderText = currentTableAnimation.getTitle()
        }
    }
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    var fontSize: CGFloat = 26
    
    // MARK:- lifecycle methods for the ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSchool()
        
        
        // registering the tableView
        self.tableView.register(UINib(nibName: TableAnimationViewCell.description(), bundle: nil), forCellReuseIdentifier: TableAnimationViewCell.description())
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        
        // set the separatorStyle to none and set the Title for the tableView
        self.tableView.separatorStyle = .none
        self.tableViewHeaderText = self.currentTableAnimation.getTitle()
        
        refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(ViewController.didPullToRefresh(_:)    ), for: .valueChanged)
        tableView.insertSubview(refreshcontrol, at: 0)
        
        // set the button1 as selected and reload the data of the tableView to see the animation
        button1.setImage(UIImage(systemName: "1.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    // delegate functions for the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arraySchools.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableAnimationViewCell().tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableAnimationViewCell.description(), for: indexPath) as? TableAnimationViewCell {
            
            let colors = [UIColor.init(hexString: "#2F5D62"), UIColor.init(hexString: "#5E8B7E"), UIColor.init(hexString: "#DFEEEA") ]
            let co = colors.randomElement()
            cell.color = co!
            cell.school = arraySchools[indexPath.row]
            
            return cell
        }
        fatalError()
    }
    
    // for displaying the headerTitle for the tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 42))
        headerView.backgroundColor = UIColor.init(hexString: "#2F5D62")
        
        let label = UILabel()
        label.frame = CGRect(x: 24, y: 12, width: self.view.frame.width, height: 42)
        label.text = tableViewHeaderText
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    //
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedSchool =  arraySchools[indexPath.row]
        
        self.performSegue(withIdentifier: "schoolDetailVC", sender: indexPath)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "schoolDetailVC" {
            
            let destinationVC = segue.destination as! SchoolDetailViewController
            destinationVC.selectedSchool = selectedSchool
            
            if let destination = sender as? School {
                destinationVC.grade = destination.satScore
            }
            
            
        }
        
    }
    /**
     *Handle refresh event    from the network request
     * @param: refreshcontorl : UIRefreshControl
     */
    @objc func didPullToRefresh(_ refreshcontorl: UIRefreshControl){

        fetchSchool()
        
    }
    
    // MARK:- outlet functions for the viewController
    @IBAction func animationButtonPressed(_ sender: Any) {
        guard let senderButton = sender as? UIButton else { return }
        
        /// set the buttons symbol to the default unselected circle
        button1.setImage(UIImage(systemName: "1.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button2.setImage(UIImage(systemName: "2.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button3.setImage(UIImage(systemName: "3.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button4.setImage(UIImage(systemName: "4.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        
        /// based on the tag of the button, set the symbol of the associated button to show it's selected and set the currentTableAnimation.
        switch senderButton.tag {
        case 1: senderButton.setImage(UIImage(systemName: "1.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.fadeIn(duration: animationDuration, delay: delay)
        case 2: senderButton.setImage(UIImage(systemName: "2.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.moveUp(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration, delay: delay)
        case 3: senderButton.setImage(UIImage(systemName: "3.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.moveUpWithFade(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration, delay: delay)
        case 4: senderButton.setImage(UIImage(systemName: "4.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.moveUpBounce(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration + 0.2, delay: delay)
        default: break
        }
        
        /// reloading the tableView to see the animation
        self.tableView.reloadData()
    }
    
    
    func fetchSchool() {
        
        
                self.showActivityIndicator(_sender: self)
        Networking.sharedInstance.getData { (schools:[School]?,error:Error?) in
            
            if let schools = schools {
                self.arraySchools = []
                self.arraySchools = schools
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.addSatScoreToSchool(schools)
                    self.refreshcontrol.endRefreshing()
                }
                
                
            }else {
                DispatchQueue.main.async {
                self.DisplayAlert(errorDescription: (error?.localizedDescription)!)
                }
            }
            //use to execute in the main so it is faster
            DispatchQueue.main.async {
                self.hideActiviyAndResumeTask(_sender: self)
                
            }
            
        }
    }
    
    func hideActiviyAndResumeTask(_sender:Any) {
        
        self.activityIndicator.stopAnimating()
        self.messageFrame.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    func DisplayAlert(errorDescription:String) {
        
        let alertController = UIAlertController(title: "Cannot Load  Schools", message: errorDescription, preferredStyle: .alert)
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Try again", style: .cancel) { (action) in
            
            // handle cancel response here. Doing nothing will dismiss the view.
            self.tableView.reloadData()
            self.fetchSchool()
            
        }
        
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        self.hideActiviyAndResumeTask(_sender: self)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                // can add  code for what happens after the alert controller has finished presenting
            }
        }
    }
    
    func showActivityIndicator(_sender:Any){
        
        textLoad = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        textLoad.text = "Loading NYC School!"
        textLoad.textColor = UIColor.white
        
        textLoad.font = UIFont(name: "Avenir Next", size: 14.0)
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 200, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor.init(hexString: "#2F5D62")
        
        // UIColor(white: 1, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.color = UIColor.white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        
        messageFrame.addSubview(textLoad)
        view.addSubview(messageFrame)
        //stop ignoring application
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    /// This function is used to add the sat score to the high school
    ///
    /// - Parameter satScoreObj: Data of Array composed with Dictionary
    private func addSatScoreToSchool(_ satScoreObj: Any){
        guard let highSchoolsWithSatScoreArr = satScoreObj as? [[String: Any]] else{
            return
        }
        
        for  highSchoolsWithSatScore in highSchoolsWithSatScoreArr{
            if let matchedDBN = highSchoolsWithSatScore["dbn"] as? String{
                //This will get the High School with the Common DBN
                let matchedHighSchools = self.arraySchools.first(where: { (nycHighSchool) -> Bool in
                    return nycHighSchool.dbn == matchedDBN
                })
                
                guard matchedHighSchools != nil else{
                    continue
                }
                
                if let satReadingScoreObject =  highSchoolsWithSatScore["sat_critical_reading_avg_score"] as? String{
                    matchedHighSchools!.satScore?.satCriticalReadingAvgScore = satReadingScoreObject
                }
                
                if let satMathScoreObject = highSchoolsWithSatScore["sat_math_avg_score"] as? String{
                    matchedHighSchools!.satScore?.satMathAvgScore = satMathScoreObject
                }
                
                if let satWritingScoreObject =  highSchoolsWithSatScore["sat_writing_avg_score"] as? String{
                    matchedHighSchools!.satScore?.satWritingAvgScore = satWritingScoreObject
                }
                
            }
        }
    }
}


