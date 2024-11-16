//
//  BookingScheduleListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct BookingScheduleListView: View {
    
    @ObservedObject private var bookingScheduleViewModel = BookingScheduleViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookingScheduleViewModel.bookingSchedules) { bookingSchedule in
                    NavigationLink("Booking ID: \(bookingSchedule.booking_id), Schedule ID: \(bookingSchedule.schedule_id)") {
                        BookingScheduleDetailsView(bookingSchedule: bookingSchedule)
                    }
                }
            }
            .navigationTitle("Booking Schedules")
        }
    }
}

#Preview {
    BookingScheduleListView()
}
