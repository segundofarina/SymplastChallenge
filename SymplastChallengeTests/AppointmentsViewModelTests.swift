//
//  AppointmentsViewModelTests.swift
//  SymplastChallengeTests
//
//  Created by Segundo Fariña on 03/02/2023.
//

import XCTest
@testable import SymplastChallenge
import Combine

final class AppointmentsViewModelTests: XCTestCase {
  
  private class AppointmentsServiceSpy: AppointmentsService {
    
    static let appointment1 = Appointment(id: 1, durationInMinutes: 15, overrideName: "Test 1", bookingDeposit: 20)
    static let appointment2 = Appointment(id: 2, durationInMinutes: 35, overrideName: "Test 2-hello", bookingDeposit: 30)
    static let appointment3 = Appointment(id: 3, durationInMinutes: 25, overrideName: "Test 3-hello", bookingDeposit: 40)
    
    var appointments: [Appointment] = [Appointment(id: 1, durationInMinutes: 15, overrideName: "Test 1", bookingDeposit: 20)]
    
    
    func getAppointments() -> AnyPublisher<[SymplastChallenge.Appointment], Error> {
      Just(appointments)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  }
  
  private func makeSUT() -> (AppointmentsViewModel, AppointmentsServiceSpy) {
    let service = AppointmentsServiceSpy()
    let vm = AppointmentsViewModel(appointmentsService: service)
    return (vm, service)
  }
  
  func test_fetchAppointments_dispatchesAppointmentsUpdated() {
    let (vm, _) = makeSUT()
    
    let expectation = self.expectation(description: "Appointments updated dispatched")
    
    let cancellable = vm.eventDispatch.sink { event in
      switch (event) {
      case .appointmentsUpdated:
        expectation.fulfill()
      default: break
      }
    }
    vm.fetchAppointments()
    
    waitForExpectations(timeout: 1)
    
    cancellable.cancel()
    
  }
  
  func test_fetchAppointments_dispatchesStatusLoading() {
    let (vm, _) = makeSUT()
    
    let statusLoading = self.expectation(description: "loading status dispatched")
    
    let cancellable = vm.eventDispatch.sink { event in
      switch (event) {
      case .fetchingStatus(let status):
        if(status == .loading) { statusLoading.fulfill() }
      default: break
      }
    }
    vm.fetchAppointments()
    
    waitForExpectations(timeout: 1)
    
    cancellable.cancel()
  }
    
  
  func test_fetchAppointments_dispatchesStatusFinished() {
    let (vm, _) = makeSUT()
    
    let statusLoading = self.expectation(description: "finished status dispatched")
    
    let cancellable = vm.eventDispatch.sink { event in
      switch (event) {
      case .fetchingStatus(let status):
        if(status == .finished) { statusLoading.fulfill() }
      default: break
      }
    }
    vm.fetchAppointments()
    
    waitForExpectations(timeout: 1)
    
    cancellable.cancel()
  }
  
  func test_fetchAppointments_dispatchesThreeEvents() {
    let (vm, _) = makeSUT()
    var eventsDispatched = 0
    let expectation = self.expectation(description: "wait 1 second")
    
    let cancellable = vm.eventDispatch.sink { event in
      eventsDispatched += 1
    }
    vm.fetchAppointments()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 2)
    
    cancellable.cancel()
    XCTAssertEqual(eventsDispatched, 3)
  }
  
  func test_fetchAppointments_updatesAppointments() {
    let (vm, service) = makeSUT()
    vm.fetchAppointments()
    XCTAssertEqual(vm.appointments, service.appointments)
  }
  
  func test_refreshAppointments_updatesAppointments() {
    let (vm, service) = makeSUT()
  
    vm.fetchAppointments()
    XCTAssertEqual(vm.appointments, service.appointments)
    service.appointments = [AppointmentsServiceSpy.appointment1, AppointmentsServiceSpy.appointment2]
    vm.reloadAppointments()
    XCTAssertEqual(vm.appointments, service.appointments)
    
  }
  
  func test_updateSearchTerm_filtersAppointments() {
    let (vm, service) = makeSUT()
    service.appointments = [AppointmentsServiceSpy.appointment1, AppointmentsServiceSpy.appointment2, AppointmentsServiceSpy.appointment3]
    let expectedFiltered = [AppointmentsServiceSpy.appointment2]
    vm.fetchAppointments()
    
    XCTAssertEqual(vm.appointments, service.appointments)
    
    vm.updateSearchTerm(term: "test 2")
    
    XCTAssertEqual(vm.appointments, expectedFiltered)
    
  }
  
  func test_updateSearchTerm_dispatchesSearchTermUpdated() {
      let (vm, _) = makeSUT()
      
      let expectation = self.expectation(description: "search term updated dispatched")
      
      let cancellable = vm.eventDispatch.sink { event in
        switch (event) {
        case .searchTermUpdated:
          expectation.fulfill()
        default: break
        }
      }
      vm.updateSearchTerm(term: "hello")
      
      waitForExpectations(timeout: 1)
      
      cancellable.cancel()
    
  }
  
  func test_updateSearchTerm_caseInsensitive() {
    let (vm, service) = makeSUT()
    service.appointments = [AppointmentsServiceSpy.appointment1, AppointmentsServiceSpy.appointment2, AppointmentsServiceSpy.appointment3]
    let expectedFiltered = [AppointmentsServiceSpy.appointment2]
    vm.fetchAppointments()
    
    XCTAssertEqual(vm.appointments, service.appointments)
    
    vm.updateSearchTerm(term: "TeST 2")
    
    XCTAssertEqual(vm.appointments, expectedFiltered)
    
  }
  
  func test_updateSearchTerm_partial() {
    let (vm, service) = makeSUT()
    service.appointments = [AppointmentsServiceSpy.appointment1, AppointmentsServiceSpy.appointment2, AppointmentsServiceSpy.appointment3]
    let expectedFiltered = [AppointmentsServiceSpy.appointment2, AppointmentsServiceSpy.appointment3]
    vm.fetchAppointments()
    
    XCTAssertEqual(vm.appointments, service.appointments)
    
    vm.updateSearchTerm(term: "hello")
    
    XCTAssertEqual(vm.appointments, expectedFiltered)
    
  }
  

  
  
  
  
  
  
  
  
}
