//
//  AdminPortal.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct AdminPortal: View {
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                
                Text("Stakeholders")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                NavigationLink(destination: UsersListView()) {
                    Text("Users List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: TourGuidesListView()) {
                    Text("Tour Guides List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: TravelAgencyListView() ) {
                    Text("Travel Agency List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Text("Facilities")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink(destination: TouristDestinationsListView()) {
                    Text("Tourist Destinations List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: TransportsListView()) {
                    Text("Transport List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: AccommodationsListView()) {
                    Text("Accomodation List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: ReviewsListView()) {
                    Text("Reviews List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: BookingsListView()) {
                    Text("Bookings List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: PaymentsListView()) {
                    Text("Payments List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: ItineraryListView()) {
                    Text("Itinerary List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: ActivitiesListView()) {
                    Text("Activities List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: SchedulesListView()) {
                    Text("Schedules List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: AssetsListView()) {
                    Text("Assets List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                
                Text("Contracts")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink(destination: GuideContractsListView()) {
                    Text("Guide Contracts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: AccommodationsContractsListView()) {
                    Text("Accommodation Contracts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: TransportContractsListView()) {
                    Text("Transport Contracts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: AssetContractListView()) {
                    Text("Asset Contracts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Customer Support view
                // Booking Schedule View ?
                
            }
        }
        .padding()
        .navigationTitle("Admin Portal")
    }
}

#Preview {
    AdminPortal()
}
