//

//  LoanController.swift

//  Calculately

//

//  Created by Ziran Fuzooly on 2022-03-18.

//


import UIKit

import Foundation

class HelpViewController: UIViewController {
        
    @IBOutlet weak var MortgageView: UIView!
    @IBOutlet weak var MortgageTitle:UILabel!
    @IBOutlet weak var MortgageDescription: UILabel!
    
    
    @IBOutlet weak var SavingsTitle: UILabel!
    @IBOutlet weak var SavingsDescription: UILabel!
    @IBOutlet weak var SavingsView: UIView!
    
    
    @IBOutlet weak var LoanView: UIView!
    @IBOutlet weak var LoanTitle: UILabel!
    @IBOutlet weak var LoanDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCardStyles()
        setCardContent()
    }
    
    /// To set the card styles
    func setCardStyles(){
        ///Making cards with rounded corners
        MortgageView.layer.cornerRadius = 20
        MortgageView.layer.masksToBounds = true
        MortgageView.layer.borderColor = UIColor.darkGray.cgColor
        MortgageView.layer.borderWidth = 0.8
        
        SavingsView.layer.cornerRadius = 20
        SavingsView.layer.masksToBounds = true
        SavingsView.layer.borderColor = UIColor.darkGray.cgColor
        SavingsView.layer.borderWidth = 0.8
        
        LoanView.layer.cornerRadius = 20
        LoanView.layer.masksToBounds = true
        LoanView.layer.borderColor = UIColor.darkGray.cgColor
        LoanView.layer.borderWidth = 0.8
        
        
    }
    
    func setCardContent(){
        ///setting titles of the cards
        MortgageTitle.text = Constants.Mortgage_Title
        LoanTitle.text = Constants.Loan_Title
        
        SavingsTitle.text = Constants.SavingsWithRC_Title
        
        ///setting descriptions of the cards
        MortgageDescription.text = Constants.Mortgage_Desc
        MortgageDescription.sizeToFit()
        LoanDescription.text = Constants.Loan_Desc
        SavingsDescription.text = Constants.SavingsWithRC_Desc
    }
    
    
    
    
}
