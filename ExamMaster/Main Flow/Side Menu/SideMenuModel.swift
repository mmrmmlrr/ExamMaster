//
//  SideMenuModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class SideMenuModel: Model {
  
  let examsCountSignal = Observable<Int>(0)
  
  private var examsCount = 0 {
    didSet { examsCountSignal.sendNext(examsCount) }
  }
  
  required init(parent: Model?) {
    super.init(parent: parent)
    register(for: AppEvent.ExamCreated)
    applyInitialState()
  }
  
  override func handle(globalEvent: GlobalEvent) {
    if globalEvent.name == AppEvent.ExamCreated { examsCount += 1 }
  }
  
  private func applyInitialState() {
    examsCount = 0
  }
  
  func logout() {
    session.closeWithParams(nil)
  }
  
  func startNewExam() {
    raise(AppEvent.StartExam)
  }
  
}