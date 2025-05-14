import UIKit

class TransactionModalViewController: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var transactionType: String = "Gelir" // varsayılan
    weak var delegate: TransactionDelegate?
    
    @IBAction func kaydetTapped(_ sender: UIButton) {
        guard let category = categoryTextField.text, !category.isEmpty,
              let amountText = amountTextField.text, let amount = Double(amountText) else {
            return
        }

        let transaction = Transaction(type: transactionType, category: category, amount: amount, date: Date())
        delegate?.didAddTransaction(transaction)
        dismiss(animated: true, completion: nil)
    }
}
