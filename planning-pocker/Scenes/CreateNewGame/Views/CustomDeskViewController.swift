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
//    {
//        didSet {
//            displayCardValueCollectionView?.register(UINib(nibName: "CardToSelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardToSelectCollectionViewCell")
//        }
//    }
//    var deskValue: ((displayValue: String, arrayValue: [String])->())?
    var arrayDesk: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        displayCardValueCollectionView?.register(UINib(nibName: "CardToSelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardToSelectCollectionViewCell")
        displayCardValueCollectionView.dataSource = self
        displayCardValueCollectionView.delegate = self
        setupUI()
    }

    func splitDeskValueToGetArray(displayValue: String) -> [String] {
        let arrayAfterSplit = displayValue.filter{!$0.isWhitespace}.components(separatedBy: ",")
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
        if customDeskNameTextField.text?.isEmpty == true {
            customDeskNameTextField.text = deskValueTextField?.text!
        }
//        deskValue(customDeskNameTextField.text ?? "#", self.arrayDesk)
        self.dismiss(animated: true)
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
//
//    func reloadCollectionView(collectionView: UICollectionView, index:IndexPath){
//        let contentOffset = collectionView.contentOffset
//        collectionView.reloadData()
//        collectionView.layoutIfNeeded()
//        collectionView.setContentOffset(contentOffset, animated: false)
//        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//    }

}

extension CustomDeskViewController: UICollectionViewDataSource {
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDesk.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardToSelectCollectionViewCell", for: indexPath) as? CardToSelectCollectionViewCell
        cell?.config(name: self.arrayDesk[indexPath.row])
        return cell!
    }
}

extension CustomDeskViewController: UICollectionViewDelegateFlowLayout {
}
