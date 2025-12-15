//
//  EventDetailRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 20/8/25.
//

import SwiftUI
import Kingfisher
struct EventDetailRouteContentView: View {
    @EnvironmentObject var eventDetailVM: EventDetailViewModel
    @State var isVisible: Bool = false
    @State var event: Event?
    
    @StateObject var venueListVM = VenueListViewModel(
        lookupVenueUseCase: LookupVenueUseCase(repository: VenueAPIService())
        , searchVenuesUseCase: SearchVenuesUseCase(repository: VenueAPIService()))
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                if let event {
                    Text(event.leagueName ?? "")
                        .font(.caption.bold())
                    Text(event.season ?? "")
                        .font(.caption)
                    
                    EventsGenericView(eventsViewModel: eventDetailVM, onRetry: { })
                    
                    if let banner = event.banner {
                        KFImage(URL(string: banner))
                            .resizable()
                            .scaledToFit()
                    }
                    
                    
                    VenueDetailView(event: event)
                }
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        //.backgroundOfCardView()
        .themedBackground(.card(material: .none))
        .environmentObject(venueListVM)
        .onAppear{
            
            switch eventDetailVM.eventsStatus {
            case .success(data: let events):
                //let event = [0]
                self.event = events.count > 0 ? events[0] : nil
            default: return
            }
            
            
        }
        
    }
}


struct VenueDetailView: View {
    var event: Event
    @EnvironmentObject var venueListVM: VenueListViewModel
    @State var venue: Venue?
    var body: some View {
        VStack(alignment: .leading) {
            if let venue {
                HStack {
                    Text("Venue:")
                        .font(.title3.bold())
                    Text("\(venue.venue ?? "") (\(venue.formedYear ?? "") )")
                        .font(.caption.bold())
                    Spacer()
                }
                
                
                //TitleComponentView(title: "Description")
                Text(venue.descriptionEN ?? "")
                    .font(.caption)
                    .lineLimit(nil)
                    .frame(alignment: .leading)
                
                Text(venue.capacity ?? "")
                    .font(.caption)
                Text(venue.cost ?? "")
                    .font(.caption)
                SocialView(facebook: venue.facebook
                           , twitter: venue.twitter
                           , instagram: venue.instagram
                           , youtube: venue.youtube
                           , website: venue.website)
                VenueAdsView(venue: venue)
            }
        }
        .onAppear{
            Task {
                await venueListVM.lookupVenue(eventID: event.idVenue ?? "")
                self.venue = venueListVM.venuesByLookup.count > 0 ? venueListVM.venuesByLookup[0] : nil
            }
        }
    }
}


struct VenueAdsView: View {
    var venue: Venue
    
    var column: [GridItem] = [GridItem(), GridItem()]
    var body: some View {
        VStack {
            KFImage(URL(string: venue.logo ?? ""))
                .placeholder { progress in
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
            
            LazyVGrid(columns: column) {
                KFImage(URL(string: venue.fanart1 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: venue.fanart2 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: venue.fanart3 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
                KFImage(URL(string: venue.fanart4 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
            }
            //.padding()
            
            KFImage(URL(string: venue.thumb ?? ""))
                .placeholder { progress in
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
                //.frame(width: UIScreen.main.bounds.width - 10, height: 500)
        }
    }
}
