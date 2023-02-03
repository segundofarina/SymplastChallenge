//
//  AppointmentsTableView.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 02/02/2023.
//

import Foundation
import UIKit


protocol AppointmentsRootViewDelegate: AnyObject {
  var appointments: [Appointment] {get}
  func refreshAppointments()
  func updateSearchTerm(term: String)
}


class AppointmentsRootView: UIView {
  
  private var refreshButton: UIButton!
  private var table: UITableView!
  private var searchBar: UISearchBar!
  private var activityIndicator: UIActivityIndicatorView!
  private weak var delegate: AppointmentsRootViewDelegate!
  
  init(delegate: AppointmentsRootViewDelegate) {
    self.delegate = delegate
    super.init(frame: .zero)
    self.backgroundColor = .systemBackground
    self.initTableView()
    self.initSearchBar()
    self.initActivityIndicator()
    self.initRefreshButton()
    self.initConstraints()
  }
  
  private func initRefreshButton() {
    self.refreshButton = UIButton()
    refreshButton.setTitle("Refresh", for: .normal)
    refreshButton.setTitleColor(.systemBlue, for: .normal)
    refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
    addSubview(refreshButton)
  }
  
  private func initTableView() {
    self.table = UITableView()
    self.table.dataSource = self
    self.table.delegate = self
    self.table.rowHeight = 72
    self.table.register(AppointmentViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    self.table.allowsSelection = false
    self.addSubview(table)
  }
  
  private func initSearchBar() {
    self.searchBar = UISearchBar()
    self.searchBar.placeholder = "Search appointment..."
    self.searchBar.delegate = self
    self.addSubview(searchBar)
  }
  
  private func initActivityIndicator() {
    self.activityIndicator = UIActivityIndicatorView()
    self.activityIndicator.hidesWhenStopped = true
    self.addSubview(activityIndicator)
  }
  
  private func initConstraints() {
    self.table.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.table.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10),
      self.table.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.table.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.table.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
    ])
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.searchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.searchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.searchBar.topAnchor.constraint(equalTo: self.refreshButton.bottomAnchor)
    ])
    
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.activityIndicator.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
      self.activityIndicator.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
      self.activityIndicator.heightAnchor.constraint(equalToConstant: 24),
      self.activityIndicator.widthAnchor.constraint(equalToConstant: 24)
    ])
    
    self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.refreshButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
      self.refreshButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 10),
      self.refreshButton.heightAnchor.constraint(equalToConstant: 20),
      self.refreshButton.widthAnchor.constraint(equalToConstant: 120)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reloadData() {
    self.table.reloadData()
  }
  
  func updateSearchTerm(_ term: String) {
    self.searchBar.text = term
  }
  
  func updateActivityIndicator(isEnabled: Bool) {
    if(isEnabled) {
      self.activityIndicator.startAnimating()
    } else {
      self.activityIndicator.stopAnimating()
    }
  }
  
  @objc func refreshButtonPressed() {
    delegate.refreshAppointments()
  }

}



extension AppointmentsRootView: UITableViewDelegate {
}

extension AppointmentsRootView: UITableViewDataSource {
  static private let cellIdentifier = "appointment_cell"
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.delegate.appointments.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier , for: indexPath) as! AppointmentViewCell
    cell.setAppointment(appointment: self.delegate.appointments[indexPath.row])
    return cell
  }
}

extension AppointmentsRootView: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    delegate.updateSearchTerm(term: searchText)
  }
}
