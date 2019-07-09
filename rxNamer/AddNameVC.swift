//
//  AddNameVC.swift
//  rxNamer
//
//  Created by AHMED on 3/24/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {

  @IBOutlet weak var newNameTxtField: UITextField!
  @IBOutlet weak var submitBtn: UIButton!
  
  let disposeBag = DisposeBag()
  let nameSubject = PublishSubject<String>()
  
  override func viewDidLoad() {
        super.viewDidLoad()
      bindSubmitBtn()
  }
  
  func bindSubmitBtn() {
    submitBtn.rx.tap
      .subscribe(onNext: {
        if self.newNameTxtField.text != "" {
          self.nameSubject.onNext(self.newNameTxtField.text!)
        }
      })
      .addDisposableTo(disposeBag)
  }

}
