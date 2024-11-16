//
//  BookingScheduleDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct BookingScheduleDetailsView: View {
    let bookingSchedule: BookingSchedule

    var body: some View {
        Form {
            Section(header: Text("Schedule Details")) {
                Text("Schedule ID: \(bookingSchedule.schedule_id)")
                Text("Booking ID: \(bookingSchedule.booking_id)")
                Text("Start Date: \(formattedDate(bookingSchedule.startDate))")
                Text("End Date: \(formattedDate(bookingSchedule.endDate))")
            }
        }
        .navigationTitle("Booking Schedule Details")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

#Preview {
    BookingScheduleDetailsView(
        bookingSchedule: .init(
            schedule_id: 1,
            booking_id: 1,
            startDate: Date(),
            endDate: Date().addingTimeInterval(60 * 60 * 24 * 7)
        )
    )
}
