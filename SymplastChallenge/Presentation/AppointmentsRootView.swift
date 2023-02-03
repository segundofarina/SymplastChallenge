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
    self.table.rowHeight = 96
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
    let padding = 12
    self.refreshButton.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).offset(padding)
      make.trailing.equalTo(safeAreaLayoutGuide).offset(-padding)
    }
    
    self.searchBar.snp.makeConstraints { make in
      make.leading.trailing.equalTo(safeAreaLayoutGuide)
      make.top.equalTo(refreshButton.snp.bottom).offset(8)
    }
    
    self.table.snp.makeConstraints{ make in
      make.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
      make.top.equalTo(searchBar.snp.bottom).offset(padding)
    }

    self.activityIndicator.snp.makeConstraints { make in
      make.centerX.centerY.equalTo(safeAreaLayoutGuide)
      make.height.width.equalTo(24)
    }
    
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
