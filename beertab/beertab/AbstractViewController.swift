//
//

import UIKit

class AbstractViewController: UIViewController {
    var activities = 0
    var rightButtonState=false
    var activityView = UIActivityIndicatorView()
    var originalTitle=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityView)
        if let title = self.navigationItem.title {
            self.originalTitle = title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title  = self.originalTitle
    }
    
    func startActivityIndicator()  {
        self.setActivityViewProperties()
        self.repositionActivityView()
        
        activities+=1;
        
        self.view.isUserInteractionEnabled = false
        if let navController=self.navigationController{
            navController.navigationBar.isUserInteractionEnabled=false
        }
        
        if let rightButton = self.navigationItem.rightBarButtonItem {
            rightButtonState = rightButton.isEnabled
            rightButton.isEnabled = false
        } else {
            rightButtonState = false
        }
        
    }
    private func repositionActivityView() {
        // Center
        let viewFrame=self.view.frame
        let x = viewFrame.size.width/2 //UIScreen.mainScreen.applicationFrame.size.width/2;
        let y = UIScreen.main.bounds.size.height/2;
        activityView.frame = CGRect(x:x,y:y,width:0,height:0)
    }
    
    private func setActivityViewProperties() {
        activityView.style = UIActivityIndicatorView.Style.large
        activityView.hidesWhenStopped = true;
        activityView.isHidden = false
        activityView.startAnimating()
        activityView.color = UIColor.black
    }
    
    func stopActivityIndicator(withMessage message:String, withTitle:String)
    {
        self.stopActivityIndicator()
    }
    
    func stopActivityIndicator()
    {
        if (activities>0) {
            activities -= 1
        }
        
        if (activities==0) {
            self.view.isUserInteractionEnabled = true
            if let navController=self.navigationController{
                navController.navigationBar.isUserInteractionEnabled=true
            }
            
            activityView.stopAnimating()
            
            if let rightButton = self.navigationItem.rightBarButtonItem {
                rightButton.isEnabled = rightButtonState
            }
            
        }
    }
    
    func showErrorMessage(withMessage message:String, withTitle:String) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    func requestFailed(error:JSONError, errorText:String, errorTitle:String)
    {
        self.stopActivityIndicator(withMessage: errorText, withTitle:errorTitle)
    }
    
}

