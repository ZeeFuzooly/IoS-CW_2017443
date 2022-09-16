//

//  LoanController.swift

//  Calculately

//

//  Created by Ziran Fuzooly on 2022-03-18.

//

import UIKit

import Foundation

class LoanController: UIViewController {

    @IBOutlet var textfields: [UITextField]!

    @IBOutlet weak var loanAmnt: UITextField!

    @IBOutlet weak var loanInterest: UITextField!

    @IBOutlet weak var payment: UITextField!

    @IBOutlet weak var numOfPayment: UITextField!

    @IBOutlet weak var labelToSwitch: UILabel!
    
    @IBOutlet weak var keyboard: Keyboard!

    var conversion: Loan?

    @IBOutlet weak var showYears: UISwitch!

    

    var lastChanged : UITextField!

    let userDefaults = UserDefaults();

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.

        keyboard.delegate = self

        keyboard.isHidden = true
        
        if let value = userDefaults.value(forKey: "L loan Amount") as? String {
            loanAmnt.text = value
        }
        
        if let value = userDefaults.value(forKey: "L Interest") as? String {
            loanInterest.text = value
        }
        
        if let value = userDefaults.value(forKey: "L Payment") as? String {
            payment.text = value
        }
        
        if let value = userDefaults.value(forKey: "L Num Pay") as? String {
             numOfPayment.text = value
        }
        if let value = userDefaults.value(forKey: "L switch") as? Bool {
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

        if !(loanAmnt.text?.isEmpty)! {

            counter += 1

        }

        if !(loanInterest.text?.isEmpty)! {

            counter += 1

        }

        if !(payment.text?.isEmpty)! {

            counter += 1

        }

        if !(numOfPayment.text?.isEmpty)! {

            counter += 1

        }
        
        return counter

    }

    

    

    

    func calculateMissingComponent() {

        let LoanAmount = Double(loanAmnt.text!)

        let Rate = Double(loanInterest.text!)

        let PaymentValue = Double(payment.text!)

        //let Np = Double(numOfPayment.text!)

        let NumOfPay = Double(numOfPayment.text!)

        /// Identify missing component and Perform relavant calculation

        var missingValue = 0.0

        if (loanAmnt.text?.isEmpty)! {

            let N = NumOfPay!

            let R = (Rate! / 100.0) / 12

            let PMT = PaymentValue!

            let P = (PMT / R) * (1 - (1 / pow(1 + R, N)))

            missingValue = P

            loanAmnt.text = String(missingValue)

            lastChanged = loanAmnt


        }

        if (loanInterest.text?.isEmpty)! {

            var x = 1 + (((PaymentValue!*NumOfPay!/LoanAmount!) - 1) / 12)

            /// var x = 0.1;

            let FINANCIAL_PRECISION = Double(0.000001) // 1e-6

            

            func F(_ x: Double) -> Double { // f(x)

                /// (loan * x * (1 + x)^n) / ((1+x)^n - 1) - pmt

                return Double(PaymentValue! * x * pow(1 + x, NumOfPay!) / (pow(1+x, NumOfPay!) - 1) - PaymentValue!);

            }

                                

            func FPrime(_ x: Double) -> Double { // f'(x)

                /// (loan * (x+1)^(n-1) * ((x*(x+1)^n + (x+1)^n-n*x-x-1)) / ((x+1)^n - 1)^2)

                let c_derivative = pow(x+1, NumOfPay!)

                return Double(PaymentValue! * pow(x+1, NumOfPay!-1) *

                    (x * c_derivative + c_derivative - (NumOfPay!*x) - x - 1)) / pow(c_derivative - 1, 2)

            }

            

            while(abs(F(x)) > FINANCIAL_PRECISION) {

                x = x - F(x) / FPrime(x)

            }



            /// Convert to yearly interest & Return as a percentage

            /// with two decimal fraction digits

            let R = Double(12 * x * 100)



            /// if the found value for I is inf or less than zero

            /// there's no interest applied

            if R.isNaN || R.isInfinite || R < 0 {

                missingValue = 0.00;

            } else {

              /// this may return a value more than 100% for cases such as

              /// where payment = 2000, terms = 12, amount = 10000  <--- unreal figures

              missingValue = R

            }
            
            loanInterest.text = String(missingValue)

            lastChanged = loanInterest
        }

        if (payment.text?.isEmpty)! {

      

            let R = (Rate! / 100.0) / 12

            let P = LoanAmount!

            let N = NumOfPay!

            let PMT = (R * P) / (1 - pow(1 + R, -N))

            missingValue = PMT

            payment.text = String(missingValue)

            lastChanged = payment

             }

        if (numOfPayment.text?.isEmpty)! {

            let R = (Rate! / 100.0) / 12

            let PMT = PaymentValue!
            
            let P = (PMT / R) * (1 - (1 / pow(1 + R, 1)))

            missingValue = P

            let minMonthlyPayment = missingValue - P

            if Int(PMT) <= Int(minMonthlyPayment) {

                print("error")

            }

            let PMT1 = PaymentValue

            let P1 = LoanAmount

            let I1 = (Rate! / 100.0) / 12

            let D1 = PMT1! / I1

            let N1 = (log(D1 / (D1 - P1!)) / log(1 + I1))

            missingValue = N1

            numOfPayment.text = String(missingValue)

            lastChanged = numOfPayment

        }

    }

    

    

    @IBAction func showYears(_ sender: UISwitch) {
    
        if sender.isOn{
            userDefaults.setValue(true, forKey: "L switch")
            labelToSwitch.text = "Number of Years"
            if numOfPayment.text != ""{
                let N = Double(numOfPayment.text!)
                let value = N!/12
                numOfPayment.text = String(value)
            }
            
        }else{
            userDefaults.setValue(false, forKey: "L switch")
            labelToSwitch.text = "Number of Payments"
            if numOfPayment.text != ""{
                let N = Double(numOfPayment.text!)
                let value = N!*12
                numOfPayment.text = String(value)
            }
        }
        userDefaults.setValue(numOfPayment.text, forKey: "L Num Pay")
    }

    @IBAction func xx(_ sender: Any) {

        keyboard.isHidden = false

    }

    

    @IBAction func resetFields(_ sender: Any) {

        loanAmnt.text = ""

        loanInterest.text = ""

        payment.text = ""

        numOfPayment.text = ""
    }
}







extension LoanController: ReusableProtocol {



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
        
        
        userDefaults.setValue(loanAmnt.text, forKey: "L loan Amount")
        userDefaults.setValue(loanInterest.text, forKey: "L Interest")
        userDefaults.setValue(payment.text, forKey: "L Payment")
        userDefaults.setValue(numOfPayment.text, forKey: "L Num Pay")

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
        keyboard.isHidden = value
    }
    


}
