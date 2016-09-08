//
//  LoginFlowNavigationController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit
import ModelsTreeKit

class LoginFlowNavigationController: UINavigationController {
  
  weak var model: LoginFlow! {
    didSet {
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentation(for: child)
        }.owned(by: self)
      
      model.authorizationProgressSignal.subscribeNext { inProgress in
        if inProgress { SVProgressHUD.show() }
        else { SVProgressHUD.dismiss() }
        }.owned(by: self)
      
      model.errorSignal.subscribeNext { [weak self] error in
        self?.showAlert(for: error)
        }.owned(by: self)
      
      model.pushInitialChildren()
    }
  }
  
  private func buildRepresentation(for model: Model) {
    switch model {
    case let model as SignInModel:
      let signInController = LoginFlowStoryboard.signInViewController()
      signInController.applyModel(model)
      self.viewControllers = [signInController]
      
    case let model as RegistrationModel:
      let controller = LoginFlowStoryboard.registrationViewController()
      controller.applyModel(model)
      pushViewController(controller, animated: true)
      
    default:
      break
    }
  }
  
}

extension LoginFlowNavigationController: RootModelAssignable {
  
  func assignRootModel(model: Model) {
    if let flowModel = model as? LoginFlow {
      self.model = flowModel
    }
  }
  
}
