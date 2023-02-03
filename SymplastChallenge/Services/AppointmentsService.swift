//
//  AppointmentsService.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 02/02/2023.
//

import Foundation
import Combine

protocol AppointmentsService {
  func getAppointments() -> AnyPublisher<[Appointment], Error>
}
