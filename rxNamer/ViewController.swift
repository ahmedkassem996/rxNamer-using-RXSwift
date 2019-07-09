//
//  ViewController.swift
//  rxNamer
//
//  Created by AHMED on 3/23/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var helloLbl: UILabel!
  @IBOutlet weak var nameEntryTxtField: UITextField!
  @IBOutlet weak var submitBtn: UIButton!
  @IBOutlet weak var namesLbl: UILabel!
  @IBOutlet weak var addNameBtn: UIButton!
  
  let disposeBag = DisposeBag()
  var namesArray: Variable<[String]> = Variable([])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindTextfield()
    bindSubmitButton()
    bindAddNameButton()
    
    namesArray.asObservable()
      .subscribe(onNext: { names in
        self.namesLbl.text = names.joined(separator: ", ")
      })
      .addDisposableTo(disposeBag)
  }
  
  func bindTextfield(){
    nameEntryTxtField.rx.text
      .debounce(0.5, scheduler: MainScheduler.instance)
        .map{
          if $0 == ""{
            return "Type your name below."
          }else{
            return "Hello, \($0!)."
          }
        }
        .bind(to: helloLbl.rx.text)
        .disposed(by: disposeBag)
  }
  
  func bindSubmitButton(){
    submitBtn.rx.tap
      .subscribe(onNext:{
        if self.nameEntryTxtField.text != ""{
          self.namesArray.value.append(self.nameEntryTxtField.text!)
          self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ","))
          self.nameEntryTxtField.rx.text.onNext("")
          self.helloLbl.rx.text.onNext("Type your name below.")
        }
      })
      .disposed(by: disposeBag)
  }

  func bindAddNameButton(){
    addNameBtn.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).subscribe(onNext:{
      guard let addNameVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNameVC") as? AddNameVC else{fatalError("Could not creat AddNameVC")}
      addNameVC.nameSubject.subscribe(onNext: { name in
        self.namesArray.value.append(name)
        addNameVC.dismiss(animated: true, completion: nil)
      })
        .disposed(by: self.disposeBag)
    self.present(addNameVC, animated: true, completion: nil)
    })
  }

}

