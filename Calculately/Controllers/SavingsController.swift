//
//  LoanController.swift
//  Calculately
//
//  Created by Ziran Fuzooly on 2022-03-18.
//
import UIKit
import Foundation
class SavingsController: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var LoanAmount: UITextField!
    @IBOutlet weak var MortgageInterest: UITextField!
    @IBOutlet weak var MortgagePayment: UITextField!
    @IBOutlet weak var MortgageTerms: UITextField!
    @IBOutlet weak var labelToSwitch: UILabel!
    @IBOutlet weak var Keyboard: Keyboard!
    var lastChanged : UITextField!
    
    let userDefaults = UserDefaults();
    
    @IBOutlet weak var ShowYears: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = userDefaults.value(forKey: "Loan Amount") as? String {
            LoanAmount.text = value
        }
        
        if let value = userDefaults.value(forKey: "Mortgage Interest") as? String {
            MortgageInterest.text = value
        }
        
        if let value = userDefaults.value(forKey: "Mortgage Payment") as? String {
            MortgagePayment.text = value
        }
        
        if let value = userDefaults.value(forKey: "Mortgage Terms") as? String {
            MortgageTerms.text = value
        }
        if let value = userDefaults.value(forKey: "switch") as? Bool {
            ShowYears.setOn(value, animated: true)
            if value {
            labelToSwitch.text = "Number of Years"
            }
        }
        
        // Do any additional setup after loading the view.
        Keyboard.delegate = self
        Keyboard.isHidden = true
        
        LoanAmount.delegate = self
        MortgageInterest.delegate = self
        MortgagePayment.delegate = self
        MortgageTerms.delegate = self
        
        textfields.forEach { textfield in
            textfield.inputView = UIView()
            textfield.inputAccessoryView = UIView()
        }
        
    }
    
    
    func validateTexFields() -> Int {
        var counter = 0
        if !(LoanAmount.text?.isEmpty)! {
            counter += 1
        }
        if !(MortgageInterest.text?.isEmpty)! {
            counter += 1
        }
        if !(MortgagePayment.text?.isEmpty)! {
            counter += 1
        }
        if !(MortgageTerms.text?.isEmpty)! {
            counter += 1
        }
        
        return counter
    }
    
    
    
    
    func calculateMissingComponent() {

        let LoanAmountt = Double(LoanAmount.text!)
        let Rate = Double(MortgageInterest.text!)
        let PaymentValue = Double(MortgagePayment.text!)
        //let Np = Double(numOfPayment.text!)
        let NumOfPay = Double(MortgageTerms.text!)
        
        /// Identify missing component and Perform relavant calculation
        var missingValue = 0.0
        
        if (LoanAmount.text?.isEmpty)! {
            
            let N = NumOfPay!
            let r = (Rate! / 100.0)
            let A = PaymentValue!
            
            let second = pow(1+r/N, N*12)

            missingValue = A/second

            LoanAmount.text = String(missingValue)
            lastChanged = LoanAmount

        }
        if (MortgageInterest.text?.isEmpty)! {
            let N = NumOfPay!
            let r = (Rate! / 100.0)
            let P = LoanAmountt!
            let A = PaymentValue!
            
            missingValue = N*(pow(A/P,1/N*12) - 1)

            MortgageInterest.text = String(missingValue)
            lastChanged = MortgageInterest
            
        }
        if (MortgagePayment.text?.isEmpty)! {
            let N = NumOfPay!
            let r = (Rate! / 100.0)
            let P = LoanAmountt!
            let A = P * pow(1+r/N, N*12)
            missingValue = A

            MortgagePayment.text = String(missingValue)
            lastChanged = MortgagePayment
        }
        if (MortgageTerms.text?.isEmpty)! {
    
            let r = (Rate! / 100.0)
            let P = LoanAmountt!
            let A = PaymentValue!
            let CPY = 12.0
            let N = Double(log(A / P) / (CPY * log(1 + (r / CPY))))
            missingValue = N
            MortgageTerms.text = String(missingValue)
            lastChanged = MortgageTerms

        }
    }
    

    @IBAction func showYears(_ sender: UISwitch) {
        if sender.isOn{
            userDefaults.setValue(true, forKey: "switch")
            labelToSwitch.text = "Number of Years"
            if MortgageTerms.text != ""{
                let N = Double(MortgageTerms.text!)
                let value = N!/12
                MortgageTerms.text = String(value)
            }
            
        }else{
            userDefaults.setValue(false, forKey: "switch")
            labelToSwitch.text = "Number of Payments"
            if MortgageTerms.text != ""{
                let N = Double(MortgageTerms.text!)
                let value = N!*12
                MortgageTerms.text = String(value)
            }
        }
        userDefaults.setValue(MortgageTerms.text, forKey: "Mortgage Terms")

    }
    
    
    
    
    @IBAction func xx(_ sender: Any) {
        Keyboard.isHidden = false
    }
    
    @IBAction func resetFields(_ sender: Any) {
        LoanAmount.text = ""
        MortgageTerms.text = ""
        MortgagePayment.text = ""
        MortgageInterest.text = ""

    }
    
 
    
    
}

extension SavingsController: ReusableProtocol {

    func didPressNumber(_ number: String) {
        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first

        if let tf = textfield {
            tf.text! += "\(number)"
            if validateTexFields()==3{
                
                calculateMissingComponent()
            }else if validateTexFields()==4{
                if lastChanged != nil {
                    lastChanged.text = ""
                    calculateMissingComponent()
                }
                    
            }
            
        }
        userDefaults.setValue(MortgageTerms.text, forKey: "Mortgage Terms")
        userDefaults.setValue(MortgagePayment.text, forKey: "Mortgage Payment")
        userDefaults.setValue(MortgageInterest.text, forKey: "Mortgage Interest")
        userDefaults.setValue(LoanAmount.text, forKey: "Loan Amount")

    }

    func didPressNegative(_ value: String) {

        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first
        

        if let tf = textfield {
            if (tf.text?.count ?? 0) == 0{
                tf.text! += "-"
                
            }
        }
    }
    
    func didPressDecimal(_ value: String) {

        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first
        

        if let tf = textfield {
            if (tf.text?.count ?? 0) > 0 && ((!tf.text!.contains("."))){
                
                if(tf.text!.count == 1 && tf.text!.contains("-") ){
                return
                }
                
                
                tf.text! += "."
                
            }
        }
 
        
    }
    
    
    func didPressDelete() {
        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first
        if let tf = textfield {
            if (tf.text?.count ?? 0) > 0 {
                _ = tf.text!.removeLast()
                if validateTexFields()==3{
                    calculateMissingComponent()
                      
                }
            }
        }
    }
    
    func didPressHide(_ value: Bool) {
        Keyboard.isHidden = value
    }
    
   
    
}

