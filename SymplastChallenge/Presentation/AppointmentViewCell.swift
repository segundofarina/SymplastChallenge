//
//  AppointmentViewCell.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 03/02/2023.
//

import UIKit

class AppointmentViewCell: UITableViewCell {
  
  var title: UILabel = UILabel()
  var subtitle: UILabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(title)
    addSubview(subtitle)
    setupTitle()
    setTitleConstraints()
    setSubtitleConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupTitle() {
    self.title.font = .systemFont(ofSize: title.font.pointSize, weight: .semibold)
//    self.title.numberOfLines = 0
  }
  
  private func setTitleConstraints() {
    title.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      title.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12),
      title.heightAnchor.constraint(equalToConstant: 16)
    ])
  }
  
  private func setSubtitleConstraints() {
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
      subtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      subtitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12),
      subtitle.heightAnchor.constraint(equalToConstant: 16)
    ])
  }
  
  func setAppointment(appointment: Appointment) {
    self.title.text = appointment.overrideName
    let fmt = NumberFormatter()
    fmt.numberStyle = .currency
    let amount: String = fmt.string(for: appointment.bookingDeposit) ?? ""
    self.subtitle.text = "\(appointment.durationInMinutes) min, \(amount)"
  }
  
}
