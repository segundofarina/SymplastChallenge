//
//  AppointmentsServiceImpl.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 02/02/2023.
//

import Foundation
import Combine

struct ApiResponse<T>: Decodable where T:Decodable{
  let result: T
  let statusCode: Int
  let version: String
}

class AppointmentsServiceImpl: AppointmentsService {
  func getAppointments() -> AnyPublisher<[Appointment], Error> {
    let url = URL(string: "https://appointmentrequestsapi-dev.symplast.com/AppointmentTypesPurposes?tenantId=1007")!
        return URLSession.shared.dataTaskPublisher(for: url)
          .catch { error in
            return Fail(error: error).eraseToAnyPublisher()
          }.map({ $0.data })
          .decode(type: ApiResponse<[Appointment]>.self, decoder: JSONDecoder())
          .map{$0.result}
          .eraseToAnyPublisher()
      }
}
