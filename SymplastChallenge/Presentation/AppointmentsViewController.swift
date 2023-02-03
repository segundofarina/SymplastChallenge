//
//  AppointmentsViewController.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 02/02/2023.
//

import Foundation

import UIKit
import Combine

class AppointmentsViewController: UIViewController {
  
  private let vm = AppointmentsViewModel()
  private var rootView: AppointmentsRootView!
  
  private var cancellables = Set<AnyCancellable>()
  
  override func loadView() {
    rootView = AppointmentsRootView(delegate: self)
    view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.subscribeToViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    vm.fetchAppointments()
  }
  
  private func subscribeToViewModel() {
    vm.eventDispatch
      .receive(on: DispatchQueue.main)
      .sink { [weak self] event in
        switch event {
          
        case .fetchingStatus(let status):
          switch status {
          case .finished:
            self?.rootView.updateActivityIndicator(isEnabled: false)
          case .loading:
            self?.rootView.updateActivityIndicator(isEnabled: true)
          }
          
        case .appointmentsUpdated:
          self?.rootView.reloadData()
          self?.rootView.updateActivityIndicator(isEnabled: false)
          
        case .errorStatus(let error):
          if let error = error {
            self?.showError(message: error)
          }
          
        case .searchTermUpdated:
          self?.rootView.updateSearchTerm(self?.vm.searchTerm ?? "")
        }
      }.store(in: &cancellables)
    
  }
  
  func showError(title: String = "Oops!",  message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in}))
    self.present(alert, animated: true, completion: nil)
  }
}

extension AppointmentsViewController: AppointmentsRootViewDelegate {
  var appointments: [Appointment] {vm.appointments}
  
  func updateSearchTerm(term: String) {
    vm.updateSearchTerm(term: term)
  }
  
  func refreshAppointments() {
    vm.reloadAppointments()
  }
}



