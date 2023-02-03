//
//  AppointmentsViewModel.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 02/02/2023.
//

import Foundation
import Combine

class AppointmentsViewModel {
  
  enum FetchingStatus {
    case loading
    case finished
  }
  enum Events {
    case errorStatus(message: String?)
    case appointmentsUpdated
    case searchTermUpdated
    case fetchingStatus(status: FetchingStatus)
  }
  
  private let appointmentsService: AppointmentsService
  let eventDispatch: PassthroughSubject<Events, Never> = .init()
  private var cancellables = Set<AnyCancellable>()
  
  var appointments: [Appointment] {
    if(searchTerm == "") {return allAppointments}
    return allAppointments.filter{$0.overrideName.lowercased().contains(searchTerm.lowercased())}
  }
  private(set) var searchTerm: String = ""
  private var allAppointments: [Appointment] = []
  
  public init(appointmentsService: AppointmentsService = AppointmentsServiceImpl()) {
    self.appointmentsService = appointmentsService
  }
  
  func fetchAppointments() {
    eventDispatch.send(.fetchingStatus(status: .loading))
    appointmentsService.getAppointments().sink {[weak self] completion in
      if case .failure(let error) = completion {
        self?.eventDispatch.send(.errorStatus(message: error.localizedDescription))
      }
      self?.eventDispatch.send(.fetchingStatus(status: .finished))
    } receiveValue: { [weak self] appointments in
      self?.allAppointments = appointments
      self?.eventDispatch.send(.appointmentsUpdated)
    }.store(in: &cancellables)
  }
  
  func reloadAppointments() {
    self.allAppointments = []
    self.searchTerm = ""
    eventDispatch.send(.searchTermUpdated)
    eventDispatch.send(.appointmentsUpdated)
    fetchAppointments()
  }
  
  func updateSearchTerm(term: String) {
    self.searchTerm = term
    self.eventDispatch.send(.searchTermUpdated)
    self.eventDispatch.send(.appointmentsUpdated)
  }
  
}
