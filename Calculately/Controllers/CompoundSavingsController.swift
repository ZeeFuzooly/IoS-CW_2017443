//
//  LoanController.swift
//  Calculately
//
//  Created by Ziran Fuzooly on 2022-03-18.
//
import UIKit
import Foundation
class CompoundSavingsController: UIViewController {
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var principleAmnt: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var monthlyPay: UITextField!
    @IBOutlet weak var futureVal: UITextField!
    @IBOutlet weak var numOfPay: UITextField!
    @IBOutlet weak var keyboard: Keyboard!
    var conversion: Loan?
    @IBOutlet weak var showYears: UISwitch!
    
    @IBOutlet weak var labelToSwitch: UILabel!
    var lastChanged : UITextField!
    let userDefaults = UserDefaults();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        keyboard.delegate = self
        keyboard.isHidden = true
        
        if let value = userDefaults.value(forKey: "C Principle Amount") as? String {
            principleAmnt.text = value
        }
        
        if let value = userDefaults.value(forKey: "C Interest") as? String {
            interest.text = value
        }
        
        if let value = userDefaults.value(forKey: "C Monthly Payment") as? String {
            monthlyPay.text = value
        }
        
        if let value = userDefaults.value(forKey: "C Future Values") as? String {
            futureVal.text = value
        }
        if let value = userDefaults.value(forKey: "C Num Pay") as? String {
            numOfPay.text = value
        }
        
//        if let value = userDefaults.value(forKey: "C last Changed") as? UITextField {
//            lastChanged = value
//        }
        
        if let value = userDefaults.value(forKey: "C switch") as? Bool {
            showYears.setOn(value, animated: true)
            if value {
            labelToSwitch.text = "Number of Years"
            }
        }
        
        textfields.forEach { textfield in
            textfield.inputView = UIView()
            textfield.inputAccessoryView = UIView()
        }
    }
    
    func validateTexFields() -> Int {
        var counter = 0
        if !(principleAmnt.text?.isEmpty)! {
            counter += 1
        }
        if !(interest.text?.isEmpty)! {
            counter += 1
        }
        if !(monthlyPay.text?.isEmpty)! {
            counter += 1
        }
        if !(futureVal.text?.isEmpty)! {
            counter += 1
        }
        if !(numOfPay.text?.isEmpty)! {
            counter += 1
        }
        return counter
    }
    
    
    func calculateTime(futureValue: Double, interestRate: Double, payment: Double) -> Int{
        let T = (log(1+((interestRate * futureValue)/payment)))/(log(1+interestRate))
        return Int(T)
        
    }
    
    func calculateCompoundInterest(principleAmnt: Double, interestRate: Double, time : Double) -> Double{
        let C = principleAmnt * pow((1 + (interestRate / 12)), 12*time)
        return C
        
    }
    
    func calculatePMT(futureVal: Double, interestRate: Double, time: Double) -> Double {
        let PMT = futureVal / ((pow(1+(interestRate/12), 12*time) - 1)/(interestRate/12))
        return PMT
    }
    
    
    
    
    
    func calculateMissingComponent() {

        let princAmount = Double(principleAmnt.text!)
        let interestVal = Double(interest.text!)
        let monthlyPayVal = Double(monthlyPay.text!)
        let futureVall = Double(futureVal.text!)
        let numOfPayVal = Double(numOfPay.text!)
        
        /// Identify missing component and Perform relavant calculation
        var missingValue = 0.0
        
        if (principleAmnt.text?.isEmpty)! {
            missingValue = 0

            let FV = Double(futureVall!)
            let PMT = Double(monthlyPayVal!)
            let I = Double(interestVal!) / 100
            let CPY = 12.0
            let N = numOfPayVal

            var PV: Double
            let one: Double = (1 + I / CPY)
            let two: Double = CPY * N!
            PV = (FV - (PMT * (pow(one,two) - 1) / (I / CPY))) / pow(one,two)
            missingValue = PV

            principleAmnt.text = String(missingValue)
            lastChanged = principleAmnt
            
        }
        if (interest.text?.isEmpty)! {
            
            let PV = Double(principleAmnt.text!)
            let FV = Double(futureVal.text!)
            let numOfPayVal = Double(numOfPay.text!)
            let CPY = 12.0
            let N = numOfPayVal
            let one: Double = (1 / (CPY * N!))
            let two: Double = (FV! / PV!)
            let I = Double(CPY * (pow(two, one) - 1))

            missingValue = (I * 100)

            interest.text = String(missingValue)
            lastChanged = interest
            
        }
        if (monthlyPay.text?.isEmpty)! {
      
            let FV = Double(futureVall!)
            let I = Double(interestVal!) / 100
            let PV = Double(principleAmnt.text!)
            let CPY = 12.0
            let N = numOfPayVal
            
            
            let first: Double = (1 + I / CPY)
            let second: Double = CPY * N!
            
            let PMT: Double
            
            PMT = Double((FV - (PV! * pow(first, second))) / ((pow(first,second) - 1) / (I / CPY)) / first)

            missingValue = PMT

            monthlyPay.text = String(missingValue)
            lastChanged = monthlyPay

             }
        if (numOfPay.text?.isEmpty)! {
            let FV = Double(futureVall!)
            let PMT = Double(monthlyPayVal!)
            let I = Double(interestVal!) / 100
            let CPY = 12.0
            let PV = Double(princAmount!)
            var N: Double
            
            N = Double((log(FV + ((PMT * CPY) / I)) - log(((I * PV) + (PMT * CPY)) / I)) / (CPY * log(1 + (I / CPY))))
            
            missingValue = N

            numOfPay.text = String(missingValue)
            lastChanged = numOfPay
        }
        
        if (futureVal.text?.isEmpty)! {
            var FV: Double
            let PMT = Double(monthlyPayVal!)
            let I = Double(interestVal!) / 100
            let CPY = 12.0
            let PV = Double(princAmount!)
            let N = numOfPayVal
            
            let first: Double = (1 + I / CPY)
            let second: Double = CPY * N!
            
            FV = PV * pow(first, second) + (PMT * (pow(first, second) - 1) / (I / CPY))
            missingValue = FV

            futureVal.text = String(missingValue)
            lastChanged = futureVal

        }
    }
    
    
    @IBAction func showYears(_ sender: UISwitch) {
        if sender.isOn{
            userDefaults.setValue(true, forKey: "C switch")
            labelToSwitch.text = "Number of Years"
            if numOfPay.text != ""{
                let N = Double(numOfPay.text!)
                let value = N!/12
                numOfPay.text = String(value)
            }
            
        }else{
            userDefaults.setValue(false, forKey: "C switch")
            labelToSwitch.text = "Number of Payments"
            if numOfPay.text != ""{
                let N = Double(numOfPay.text!)
                let value = N!*12
                numOfPay.text = String(value)
            }
        }
        userDefaults.setValue(numOfPay.text, forKey: "C Num Pay")
    
    }
    
    @IBAction func xx(_ sender: Any) {
        keyboard.isHidden = false
    }
    
    @IBAction func resetFields(_ sender: Any) {
        numOfPay.text = ""
        interest.text = ""
        principleAmnt.text = ""
        monthlyPay.text = ""
        futureVal.text = ""
    }
 
}



extension CompoundSavingsController: ReusableProtocol {

    func didPressNumber(_ number: String) {
        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first

        if let tf = textfield {
            tf.text! += "\(number)"
            if validateTexFields()==4{
                calculateMissingComponent()
            }else if validateTexFields()==5{
                if lastChanged != nil {
                    lastChanged.text = ""
                    calculateMissingComponent()
                    //userDefaults.setValue(lastChanged, forKey: "C last Changed")
                }
                
            }
        }
        
        userDefaults.setValue(interest.text, forKey: "C Interest")
        userDefaults.setValue(principleAmnt.text, forKey: "C Principle Amount")
        userDefaults.setValue(monthlyPay.text, forKey: "C Monthly Payment")
        userDefaults.setValue(numOfPay.text, forKey: "C Num Pay")
        userDefaults.setValue(futureVal.text, forKey: "C Future Values")

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
                if validateTexFields()==4{
                    calculateMissingComponent()
                      
                }
            }
        }
    }
    
    func didPressHide(_ value: Bool) {
        keyboard.isHidden = value
    }
    
    

}




