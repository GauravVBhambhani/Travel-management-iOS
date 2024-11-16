//
//  BookingsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct BookingsListView: View {
    
    @ObservedObject private var bookingsViewModel = BookingsViewModel()
        
    var body: some View {
        NavigationView {
            List {
                ForEach(bookingsViewModel.bookings) { booking in
                    NavigationLink("Booking ID: \(booking.id)") {
                        BookingDetailsView(booking: booking)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let bookingToDelete = bookingsViewModel.bookings[index]
                        bookingsViewModel.deleteBooking(bookingToDelete)
                    }
                }
            }
            .navigationTitle("Bookings")
            
        }
    }
}

#Preview {
    BookingsListView()
}
