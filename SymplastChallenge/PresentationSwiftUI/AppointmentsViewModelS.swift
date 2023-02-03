//
//  AppointmentsViewModelS.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 03/02/2023.
//

import Foundation
import Combine

class AppointmentsViewModelS: ObservableObject {
  @Published var allAppointments: [Appointment] = []
  @Published var searchTerm: String = ""
  @Published var errorMessage: String = ""
  @Published var isLoadingData = true
  @Published var isPresentingAlert = false
  
  var filteredAppointments: [Appointment] {
    if(searchTerm == "") { return allAppointments }
    return allAppointments.filter{ $0.overrideName.lowercased().contains(searchTerm.lowercased()) }
  }
  
  private let appointmentsService: AppointmentsService
  private var cancellables = Set<AnyCancellable>()
  
  
  public init(appointmentsService: AppointmentsService = AppointmentsServiceImpl()) {
    self.appointmentsService = appointmentsService
  }
  
  func fetchAppointments() {
    isLoadingData = true
    appointmentsService.getAppointments()
      .receive(on: DispatchQueue.main)
      .sink {[weak self] completion in
      if case .failure(let error) = completion {
        self?.errorMessage = error.localizedDescription
        self?.isPresentingAlert = true
      }
        self?.isLoadingData = false
    } receiveValue: { [weak self] appointments in
      self?.allAppointments = appointments
    }.store(in: &cancellables)
  }
  
}
