//
//  AppointmentViewCell.swift
//  SymplastChallenge
//
//  Created by Segundo Fariña on 03/02/2023.
//

import UIKit
import SnapKit

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
    title.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview().offset(12)
      make.height.equalTo(16)
    }
  }
  
  private func setSubtitleConstraints() {
    subtitle.snp.makeConstraints { make in
      make.top.equalTo(title.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().offset(12)
      make.height.equalTo(16)
    }
  }
  
  func setAppointment(appointment: Appointment) {
    self.title.text = appointment.overrideName
    let fmt = NumberFormatter()
    fmt.numberStyle = .currency
    let amount: String = fmt.string(for: appointment.bookingDeposit) ?? ""
    self.subtitle.text = "\(appointment.durationInMinutes) min, \(amount)"
  }
  
}
