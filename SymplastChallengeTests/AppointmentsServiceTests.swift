//
//  AppointmentsServiceTests.swift
//  SymplastChallengeTests
//
//  Created by Segundo Fariña on 03/02/2023.
//

import XCTest
@testable import SymplastChallenge

final class AppointmentServiceTests: XCTestCase {
  
  private func makeSUT() -> AppointmentsService {
    return AppointmentsServiceImpl()
  }
  
  func test_AppointmentService_getAppointments_returnsAppointments() throws {
    let sut = makeSUT()
    let appointments = try awaitPublisher(sut.getAppointments())
    XCTAssertFalse(appointments.isEmpty)
  }
  
}

