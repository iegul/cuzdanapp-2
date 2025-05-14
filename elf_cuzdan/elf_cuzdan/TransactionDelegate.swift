protocol TransactionDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}
