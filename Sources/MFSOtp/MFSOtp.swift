import UIKit

public class OTPStackView: UIStackView {

    var textFieldArray = [OTPTextField]()
    public var numberOfOTPdigit = 6
    
    var otpNumber = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
        setTextFields()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setTextFields()
    }
    
    private func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func showRedNumbers(){
        self.subviews.forEach { field in
            if let field = field as? UITextField {
                field.textColor = .red
            }
        }
    }
    
    public func showDefaultNumbers(){
        self.subviews.forEach { field in
            if let field = field as? UITextField {
                field.textColor = .lightGray
            }
        }
    }
    
    public func clearAllFields(){
        otpNumber = ""
        self.subviews.forEach { field in
            if let field = field as? UITextField {
                field.text = ""
                
                field.subviews.forEach { view in
                    if view.layer.opacity == 0 { view.layer.opacity = 0.6 }
                }
            }
            
        }
    }
    
    public func setOtpCode(otpNumber:String){
//        self.otpNumber = otpNumber
//        var count = 0
//        self.subviews.forEach { field in
//            if let field = field as? UITextField {
//                //field.text = otpNumber[count]
//                count += 1
//            }
//        }
    }
    
    @objc public func keyboardWillHide(notification: NSNotification) {
        otpNumber = ""
        textFieldArray.forEach { field in
            otpNumber += field.text ?? ""
        }
    }
    
    private func setTextFields() {
        for i in 0..<numberOfOTPdigit {
            let field = OTPTextField()
                       
            addArrangedSubview(field)
            textFieldArray.append(field)
            
            field.delegate = self
            field.backgroundColor = .clear
            field.keyboardType = .decimalPad
            field.layer.opacity = 1
            field.textAlignment = .center
            field.textColor = .lightGray
            field.font = UIFont.systemFont(ofSize: 16)
            addBottomBorder(textField: field)
            
            //LAST TAG
            i == (numberOfOTPdigit - 1) ? field.tag = -1 : ()
            
            i != 0 ? (field.previousTextField = textFieldArray[i-1]) : ()
            
            i != 0 ? (textFieldArray[i-1].nextTextFiled = textFieldArray[i]) : ()
            
            i == 2 ? addArrangedSubview(otpMiddleLineView()) : ()
            
        }
    }
        
    private func otpMiddleLineView() -> UIView{
        let view = UIView()
        view.backgroundColor = .clear
        let line = UIView()
        view.addSubview(line)
        line.backgroundColor = .lightGray
        line.layer.opacity = 0.6
        line.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 2),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            line.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        return view
    }
    
    
    private func addBottomBorder(textField:UITextField){
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        bottomLine.layer.opacity = 0.6
        textField.borderStyle = .none
        textField.addSubview(bottomLine)
          
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 10),
            bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -10),
            bottomLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
  
}


extension OTPStackView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? OTPTextField else {
            return true
        }
        if !string.isEmpty {
            field.text = string
            if field.tag == -1 {field.resignFirstResponder()}
            field.nextTextFiled?.becomeFirstResponder()
            field.subviews.forEach { view in
                if view.layer.opacity == 0.6 { view.layer.opacity = 0 }
            }
            return true
        }
        return true
    }
}

class OTPTextField: UITextField {
    var previousTextField: UITextField?
    var nextTextFiled: UITextField?
    
    override func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
        self.subviews.forEach { view in
            if view.layer.opacity == 0 { view.layer.opacity = 0.6 }
        }
        
    }
}
