//
//  BookingDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct BookingDetailsView: View {
    let booking: Booking

    var body: some View {
        Form {
            Section(header: Text("Booking Details")) {
                Text("Booking ID: \(booking.booking_id)")
                Text("Booking Date: \(booking.booking_date)")
                Text("Total Cost: \(String(format: "%.2f", booking.total_cost))")
                Text("Payment Status: \(booking.payment_status)")
            }
            Section(header: Text("User")) {
                Text("User ID: \(booking.user_id)")
            }
            Section(header: Text("Itinerary")) {
                Text("Itinerary ID: \(booking.itinerary_id)")
            }
            if let accommodationId = booking.accommodation_id {
                Section(header: Text("Accommodation")) {
                    Text("Accommodation ID: \(accommodationId)")
                }
            }
            if let activityId = booking.activity_id {
                Section(header: Text("Activity")) {
                    Text("Activity ID: \(activityId)")
                }
            }
            if let scheduleId = booking.schedule_id {
                Section(header: Text("Schedule")) {
                    Text("Schedule ID: \(scheduleId)")
                }
            }
        }
        .navigationTitle("Booking Details")
    }
}

#Preview {
    BookingDetailsView(
        booking: .init(
            booking_id: 1,
            user_id: 1,
            booking_date: "2023-12-01",
            total_cost: 1200.50,
            payment_status: "Paid",
            accommodation_id: 1,
            activity_id: nil,
            schedule_id: nil,
            itinerary_id: nil
        )
    )
}
