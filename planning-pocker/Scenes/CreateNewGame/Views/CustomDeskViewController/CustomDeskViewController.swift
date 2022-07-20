//
//  CustomDeskViewController.swift
//  planning-pocker
//
//  Created by Slime on 02/07/2022.
//

import UIKit

class CustomDeskViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveDeskButton: UIButton!
    @IBOutlet weak var customDeskNameTextField: UITextField!
    @IBOutlet weak var deskValueTextField: UITextField!
    @IBOutlet weak var displayCardValueCollectionView: UICollectionView!

    var arrayDesk: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        displayCardValueCollectionView?.register(UINib(nibName: "CardPreviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardPreviewCollectionViewCell")
        displayCardValueCollectionView.dataSource = self
        displayCardValueCollectionView.delegate = self
        setupUI()
    }

    func splitDeskValueToGetArray(displayValue: String) -> [String] {
        let arrayAfterSplit = displayValue.filter {!$0.isWhitespace}.components(separatedBy: ",")
        var arrayValue: [String] = []
        for item in arrayAfterSplit where item != "" {
            arrayValue.append(item)
        }
        return arrayValue
    }

    private func setupUI() {
        customDeskNameTextField.layer.borderColor = UIColor.gray.cgColor
        deskValueTextField.layer.borderColor = UIColor.gray.cgColor
        saveDeskButton.customButtonUI(borderRadius: 4, backgroundColor: UIColor.blueButtonColor, titleColor: UIColor.white)
        cancelButton.customButtonUI(borderWidth: 1, borderRadius: 4, borderColor: UIColor.gray, backgroundColor: UIColor.clear, titleColor: UIColor.blueButtonColor)
    }

    @IBAction func saveDesk(_ sender: Any) {
        guard deskValueTextField?.text?.isEmpty == false else {
            AppViewController.shared.popupAlert(title: "Desk values required", colorPopup: UIColor.systemRed)
            return
        }
        self.dismiss(animated: true)
        AppViewController.shared.pushToCreateNewGameScreen(customDesk: customDeskNameTextField.text, deskValue: arrayDesk)
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func listenValueFromTypeValueDesk(_ sender: Any) {

        self.arrayDesk = splitDeskValueToGetArray(displayValue: (deskValueTextField?.text)!)
        print(arrayDesk)
        displayCardValueCollectionView.reloadData()
    }
}

extension CustomDeskViewController: UICollectionViewDelegate {

}

extension CustomDeskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDesk.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardPreviewCollectionViewCell", for: indexPath) as? CardPreviewCollectionViewCell
        cell?.configName(cardNum: self.arrayDesk[indexPath.row])
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CardPreviewCollectionViewCell {
            cell.configSelected()

        }
    }
}

extension CustomDeskViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 54)
    }
}
