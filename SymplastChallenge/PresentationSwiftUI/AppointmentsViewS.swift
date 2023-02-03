//
//  AppointmentsViewS.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 03/02/2023.
//

import SwiftUI

struct AppointmentsViewS: View {
  let appointments: [Appointment]
  @Binding var query: String
  let isLoadingData: Bool
  
  var body: some View {
    NavigationView {
      Group {
        if(isLoadingData) {
          ProgressView()
            .scaleEffect(2)
        } else {
          List {
            ForEach(appointments, id: \.id) { appointment in
              VStack (alignment:.leading) {
                Text(appointment.overrideName)
                  .fontWeight(.semibold)
                HStack {
                  Text("\(appointment.durationInMinutes) min,")
                  Text(appointment.bookingDeposit.formatted(.currency(code: "USD")))
                    .monospacedDigit()
                }
              }
            }
          }
        }
      }
      .navigationTitle("Appointments")
      .searchable(text: $query, prompt: "Search appointment")
    }
  }
}


struct AppointmentsScene: View {
  @ObservedObject var viewModel = AppointmentsViewModelS()
  var body: some View {
    AppointmentsViewS(
      appointments: viewModel.filteredAppointments,
      query: $viewModel.searchTerm,
      isLoadingData: viewModel.isLoadingData
    )
    .alert(isPresented: $viewModel.isPresentingAlert) {
      Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
    }.onAppear {
      viewModel.fetchAppointments()
    }
  }
}

struct Appointments_Preview_Wrapper: View {
  let appointments: [Appointment] = [
    Appointment(id: 1, durationInMinutes: 15, overrideName: "Test 1", bookingDeposit: 20),
    Appointment(id: 2, durationInMinutes: 35, overrideName: "Test 2-hello", bookingDeposit: 30),
    Appointment(id: 3, durationInMinutes: 25, overrideName: "Test 3-hello", bookingDeposit: 40)
  ]
  @State var query = ""
  var filteredAppointments: [Appointment] {
    if(query == "") { return appointments }
    return appointments.filter{ $0.overrideName.lowercased().contains(query.lowercased()) }
  }
  var body: some View {
    AppointmentsViewS(appointments: filteredAppointments, query: $query, isLoadingData: false)
  }
}

struct AppointmentsViewS_Previews: PreviewProvider {
    static var previews: some View {
      Appointments_Preview_Wrapper()
    }
}
