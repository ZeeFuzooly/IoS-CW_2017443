//
//  ReusableView.swift
//  Calculately
//
//  Created by Ziran Fuzooly on 2022-03-20.
//

import UIKit

var yes: Bool = false
// ReusableProtocol for extending functionality
protocol ReusableProtocol {
    func didPressNumber(_ number: String)
    func didPressNegative(_ value: String)
    func didPressDelete()
    func didPressDecimal(_ value: String)
    func didPressHide(_ value: Bool)

}

class Keyboard: UIView {

    var delegate: ReusableProtocol? // variable to hold an instance to any object conforming to ReusableProtocol

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public func commonInit() {
        // Setting the nib view to this specific view
        guard let view = loadFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }

    // Loading a view from Nib
    private func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Keyboard", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func didPressNumber(_ sender: UIButton) {
        if let number = sender.titleLabel?.text {
            delegate?.didPressNumber(number)
        }
    }
    
    
    @IBAction func didPressNeg(_ sender: UIButton) {
        if let value = sender.titleLabel?.text {
            delegate?.didPressNegative(value)
        }
    }

    @IBAction func didPressDecimal(_ sender: UIButton) {
        if let value = sender.titleLabel?.text {
        delegate?.didPressDecimal(value)
        }
    }
    
    @IBAction func didPressDelete(_ sender: UIButton) {
        delegate?.didPressDelete()
    }
    
    @IBAction func hide(_ sender: Any) {
        delegate?.didPressHide(true)
    }

}
