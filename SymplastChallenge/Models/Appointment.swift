//
//  Appointment.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 02/02/2023.
//

import Foundation

struct Appointment: Codable, Equatable{
  let id: Int
  let durationInMinutes: Int
  let overrideName: String
  let bookingDeposit: Double
 
  // Not used
//  let appointmentTypeId: Int
//  let appointmentPurposeId: Int
}
