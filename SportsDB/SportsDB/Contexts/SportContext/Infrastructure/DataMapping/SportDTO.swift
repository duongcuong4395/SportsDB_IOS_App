//
//  SportDTO.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

import Foundation

enum CompetitionFormat: String, Codable {
    case oneVsOne = "Personal antagonism"
    case oneVsMany = "1 vs many"
    case teamVsTeam = "2 teams compete against each other"
    case teamVsTeams = "N teams compete against each other"
    case freeForAll = "All individuals compete independently"
    case relay = "Relay team"
    case doubles = "Doubles"
    case multiFormat = ""
}

import Kingfisher

enum SportType: String, Codable, CaseIterable, TabItem {
    @MainActor
    func getIcon() -> AnyView {
        AnyView(KFImage(URL(string: getImageUrl()))
            .placeholder({ progress in
                //LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                ProgressView()
            })
            .resizable()
            .scaledToFill())
    }
    
    
    case Motorsport = "Motorsport"
    case Soccer = "Soccer"
    case Darts = "Darts"
    case Fighting = "Fighting"
    case Baseball = "Baseball"
    case Basketball = "Basketball"
    case AmericanFootball = "American Football"
    case IceHockey = "Ice Hockey"
    case Golf = "Golf"
    case Rugby = "Rugby"
    case Tennis = "Tennis"
    case Cricket = "Cricket"
    case Cycling = "Cycling"
    case AustralianFootball = "Australian Football"
    case Esports = "ESports"
    case Volleyball = "Volleyball"
    case Netball = "Netball"
    case Handball = "Handball"
    case Snooker = "Snooker"
    case FieldHockey = "Field Hockey"
    case Athletics = "Athletics"
    case Badminton = "Badminton"
    case Climbing = "Climbing"
    case Equestrian = "Equestrian"
    case Gymnastics = "Gymnastics"
    case Shooting = "Shooting"
    case ExtremeSports = "Extreme Sports"
    case TableTennis = "Table Tennis"
    case MultiSports = "Multi Sports"
    case Watersports = "Watersports"
    case Weightlifting = "Weightlifting"
    case Skiing = "Skiing"
    case Skating = "Skating"
    case Wintersports = "Wintersports"
    case Lacrosse = "Lacrosse"
    case Gambling = "Gambling"
}


extension SportType{
    func getImageUrl(with selected: Bool = false) -> String {
        let baseURL = "https://www.thesportsdb.com/images/icons/sports/"
        var imageName = ""
        
        switch self {
        case .Motorsport:
            imageName = "motorsport"
        case .Soccer:
            imageName = "soccer"
        case .Darts:
            imageName = "darts"
        case .Fighting:
            imageName = "fighting"
        case .Baseball:
            imageName = "baseball"
        case .Basketball:
            imageName = "basketball"
        case .AmericanFootball:
            imageName = "americanfootball"
        case .IceHockey:
            imageName = "icehockey"
        case .Golf:
            imageName = "golf"
        case .Rugby:
            imageName = "rugby"
        case .Tennis:
            imageName = "tennis"
        case .Cricket:
            imageName = "cricket"
        case .Cycling:
            imageName = "cycling"
        case .AustralianFootball:
            imageName = "australianfootball"
        case .Esports:
            imageName = "esports"
        case .Volleyball:
            imageName = "volleyball"
        case .Netball:
            imageName = "netball"
        case .Handball:
            imageName = "handball"
        case .Snooker:
            imageName = "snooker"
        case .FieldHockey:
            imageName = "fieldhockey"
        case .Athletics:
            imageName = "athletics"
        case .Badminton:
            imageName = "badminton"
        case .Climbing:
            imageName = "climbing"
        case .Equestrian:
            imageName = "equestrian"
        case .Gymnastics:
            imageName = "gymnastics"
        case .Shooting:
            imageName = "shooting"
        case .ExtremeSports:
            imageName = "extremesports"
        case .TableTennis:
            imageName = "tabletennis"
        case .MultiSports:
            imageName = "multisports"
        case .Watersports:
            imageName = "watersports"
        case .Weightlifting:
            imageName = "weightlifting"
        case .Skiing:
            imageName = "skiing"
        case .Skating:
            imageName = "skating"
        case .Wintersports:
            imageName = "wintersports"
        case .Lacrosse:
            imageName = "lacrosse"
        case .Gambling:
            imageName = "gambling"
        }
        
        return baseURL + imageName + (selected ? "-hover" : "") + ".png"
    }
    
}

extension SportType {
    var competitionFormat: CompetitionFormat {
        switch self {
        case .Soccer, .Basketball, .Baseball, .AmericanFootball, .IceHockey, .Rugby, .AustralianFootball, .FieldHockey, .Volleyball, .Netball, .Handball, .Lacrosse:
            return .teamVsTeam
        case .Motorsport, .Esports:
            return .teamVsTeams
        case .Tennis, .Badminton, .TableTennis:
            return .doubles
        case .Darts, .Fighting, .Snooker:
            return .oneVsOne
        case .Golf, .Athletics, .Cycling, .Gymnastics, .Shooting, .Equestrian, .ExtremeSports, .Watersports, .Weightlifting, .Skiing, .Skating, .Climbing:
            return .freeForAll
        case .MultiSports, .Wintersports:
            return .multiFormat
        case .Gambling:
            return .freeForAll
        case .Cricket:
           return .teamVsTeam
        }
    }
}

import SwiftUI

extension SportType {
    func getFieldImage() -> Image {
        switch self {
        case .Soccer, .Motorsport, .Fighting, .Baseball, .Basketball, .AmericanFootball
            , .IceHockey, .Golf, .Rugby, .Tennis, .Cricket, .Cycling, .AustralianFootball
            , .Esports, .Volleyball, .Netball, .Handball, .Snooker, .FieldHockey, .Athletics
            , .Badminton, .Climbing, .Equestrian, .Gymnastics, .Shooting, .ExtremeSports
            , .TableTennis, .MultiSports, .Watersports, .Weightlifting, .Skiing, .Skating
            , .Wintersports, .Lacrosse, .Gambling:
            return Image("\(self.rawValue)_Field")
        default:
            return Image("Soccer_Field")
        }
    }
}
