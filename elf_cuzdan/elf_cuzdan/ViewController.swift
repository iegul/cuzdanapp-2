import UIKit
import DGCharts
import Charts

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var totalLabel: UILabel!

    var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        for i in 1...20 {
                let fake = Transaction(type: i % 2 == 0 ? "Gelir" : "Gider", category: "Kira \(i)", amount: Double(i) * 100, date: Date())
                transactions.append(fake)
            }
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let icon = UIImageView(image: UIImage(named: "para"))
            icon.frame = CGRect(x: 20, y: 60, width: 44, height: 24)
            icon.contentMode = .scaleAspectFit
            view.addSubview(icon)
        
        tableView.backgroundColor = UIColor(red: 1.2, green: 0.94, blue: 0.96, alpha: 1.0)
            
            updateUI()
        updateUI()
    }

    @IBAction func gelirEkleTapped(_ sender: UIButton) {
        showAddTransactionAlert(type: "Gelir")
    }

    @IBAction func giderEkleTapped(_ sender: UIButton) {
        showAddTransactionAlert(type: "Gider")
    }

    func showAddTransactionAlert(type: String) {
        let alert = UIAlertController(title: "\(type) Ekle", message: "Tür ve tutar girin", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Tür (örnek: Maaş, Kira)"
        }

        alert.addTextField { textField in
            textField.placeholder = "Tutar (₺)"
            textField.keyboardType = .decimalPad
        }

        let ekleAction = UIAlertAction(title: "Ekle", style: .default) { _ in
            guard let category = alert.textFields?[0].text, !category.isEmpty,
                  let amountText = alert.textFields?[1].text, let amount = Double(amountText) else {
                return
            }

            let newTransaction = Transaction(type: type, category: category, amount: amount, date: Date())
            self.transactions.insert(newTransaction, at: 0)
            self.tableView.reloadData()
            self.updateUI()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }

        alert.addAction(ekleAction)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let t = transactions[indexPath.row]

        // subtitle stilinde hücre oluştur
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }

        cell?.textLabel?.text = t.type

        let formattedAmount = String(format: "%.2f", t.amount)
        cell?.detailTextLabel?.text = "\(t.category) - \(formattedAmount)₺"

        if t.type == "Gelir" {
            cell?.backgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.85, alpha: 0.3)
            cell?.textLabel?.textColor = UIColor.systemPink
            cell?.detailTextLabel?.textColor = UIColor.darkGray
        } else {
            cell?.backgroundColor = UIColor(red: 0.85, green: 0.4, blue: 0.6, alpha: 0.3)
            cell?.textLabel?.textColor = UIColor.red
            cell?.detailTextLabel?.textColor = UIColor.darkGray
        }
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell!
    }

    func updateUI() {
        let gelir = transactions.filter { $0.type == "Gelir" }.map { $0.amount }.reduce(0, +)
        let gider = transactions.filter { $0.type == "Gider" }.map { $0.amount }.reduce(0, +)
        let toplam = gelir - gider

        totalLabel.text = "\(String(format: "%.2f", toplam))₺"

        let entries = [
            PieChartDataEntry(value: gelir, label: "Gelir"),
            PieChartDataEntry(value: gider, label: "Gider")
        ]

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [
            UIColor.systemPink, // ana pembe
            UIColor(red: 1.0, green: 0.75, blue: 0.85, alpha: 1.0), // açık pembe
            UIColor(red: 0.95, green: 0.5, blue: 0.7, alpha: 1.0), // orta pembe
            UIColor(red: 0.85, green: 0.4, blue: 0.6, alpha: 1.0)  // koyu pembe
        ]
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
        chartView.centerText = "\(String(format: "%.2f", toplam))₺"
        chartView.notifyDataSetChanged()
    }
}
