//
//  PatientProfileViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 9/3/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit
import Charts

class PatientProfileViewController: UIViewController {

//    @IBOutlet weak var focusTextField: UITextField!
//    @IBOutlet weak var frequencyTextField: UITextField!
//    @IBOutlet weak var patientDataButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var bubbleChartView: BubbleChartView!
    
    @IBOutlet weak var _tableView: UITableView!
    
    var patientId = 0
    
    var conversations : [Conversation] = []
    
//    @IBAction func patientDataButtonTapped(_ sender: Any) {
//        let alertController = UIAlertController(title: "Patient's Report", message: " Patient has shown 21.2% anxiety and 57.5% stress levels in the past week." , preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "Thanks Nova!", style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        navigateToPatientListVC()
    }
    
    override func viewDidLoad() {
        configureVC()
        loadAndRenderAnxietyChart()
        setUpTableView()
        loadConversationsForPatient(patientId: self.patientId)
        super.viewDidLoad()
    }
    
    func configureVC() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255.0, green: 94/255.0, blue: 97/255.0, alpha: 2.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        saveButton.layer.cornerRadius = 5
//        patientDataButton.layer.cornerRadius = 5
        
//        let navItem = UINavigationItem(title: "Back")
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonTapped))
        
//        self.navigationController?.navigationBar.setItems([navItem], animated: false)
        
        self.saveButton.isHidden = true
        
    }
    
    func setUpTableView() {
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    }
    
    func loadConversationsForPatient(patientId: Int) {
        BackendService.shared.getConversations(forPatientId: patientId, completion: {conversations in
            self.conversations = conversations
                
            self._tableView.reloadData()
        })
        

    }
        
    func navigateToPatientListVC() {
        let navigationController = UINavigationController(rootViewController: PatientListViewController())
        present(navigationController, animated: false, completion: nil)
    }
    
    func loadAndRenderAnxietyChart() {
        let anxietyValues = [4, 7, 3, 9, 1, 3, 10].sorted().reversed()
        
        var yVals1 = [BubbleChartDataEntry]()
        var yVals2 = [BubbleChartDataEntry]()
        var yVals3 = [BubbleChartDataEntry]()
        
        BackendService.shared.getAnxiety(forPatientId: patientId, completion: {CHANGE_TO_anxiety_values in
            
            var i = 0
            let chartDataEntries : [ChartDataEntry] = CHANGE_TO_anxiety_values.compactMap({ val in
                let entry = ChartDataEntry(x: Double(i), y: Double(val[0]))
                i = i + 1 // i++ was blocked by compiler
                
                var anxMinus1 = BubbleChartDataEntry(x: Double(i), y: -1, size: CGFloat(val[0]), icon: UIImage(named: "icon"))
                var anxMinus2 = BubbleChartDataEntry(x: Double(i), y: 0, size: CGFloat(val[1]), icon: UIImage(named: "icon"))
                var anxMinus3 = BubbleChartDataEntry(x: Double(i), y: 1, size: CGFloat(val[2]), icon: UIImage(named: "icon"))
                yVals1.append(anxMinus1)
                yVals2.append(anxMinus2)
                yVals3.append(anxMinus3)
                
                
                return entry
            })
            
            
            let set1 = BubbleChartDataSet(entries: yVals1, label: "Negative")
            set1.drawIconsEnabled = false
            set1.setColor(ChartColorTemplates.colorful()[0], alpha: 0.5)
            set1.drawValuesEnabled = true
            
            let set2 = BubbleChartDataSet(entries: yVals2, label: "Neutral")
            set2.drawIconsEnabled = false
            set2.iconsOffset = CGPoint(x: 0, y: 15)
            set2.setColor(ChartColorTemplates.colorful()[1], alpha: 0.5)
            set2.drawValuesEnabled = true
            
            let set3 = BubbleChartDataSet(entries: yVals3, label: "Positive")
            set3.setColor(ChartColorTemplates.colorful()[2], alpha: 0.5)
            set3.drawValuesEnabled = true
            
            let data = BubbleChartData(dataSets: [set1, set2, set3])
            data.setDrawValues(false)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 7)!)
            data.setHighlightCircleWidth(1.5)
            data.setValueTextColor(.white)
            
            self.bubbleChartView.data = data
            self.bubbleChartView.chartDescription?.text = "Mood"
            self.bubbleChartView.backgroundColor = .white
        })
        

    }
    
    func loadAndShowConversation(conversation: Conversation) {
        let alertController = UIAlertController(title: "Patient's Conversation", message: conversation.messages.map({ $0.text }).joined(separator: "\n\n") , preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Thanks Nova!", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Hide keyboard
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
//        frequencyTextField.resignFirstResponder()
//        focusTextField.resignFirstResponder()
    }
}

extension PatientProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.65)
        
        cell.textLabel!.text = self.conversations[indexPath.row].dateCreated.description
        
        return cell
    }
    

}

extension PatientProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        loadAndShowConversation(conversation: self.conversations[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Conversations"
    }
}
