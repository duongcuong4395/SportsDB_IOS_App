//
//  Team.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct Team: Equatable, Identifiable {
    var id = UUID()
    var idTeam: String? = ""
    var idSoccerXML: String? = ""
    var idAPIfootball: String? = ""
    
    var loved: String? = ""
    var teamName: String = ""
    var teamAlternate: String? = ""
    
    var sportType: SportType? = .AmericanFootball
    var leagueName: String?  = ""
    var leagueAlternate: String? = ""
    var division: String? = ""
    var idCup: String? = ""
    
    var currentSeason: String? = ""
    var formedYear: String? = ""
    var dateFirstEvent: String? = ""
    
    var website: String? = ""
    var facebook: String? = ""
    var instagram: String? = ""
    var twitter: String? = ""
    var youtube: String? = ""
    var rss: String? = ""
    
    var descriptionEN: String? = ""
    var descriptionDE: String? = ""
    var descriptionFR: String? = ""
    var descriptionIT: String? = ""
    
    var descriptionCN: String? = ""
    var descriptionJP: String? = ""
    var descriptionRU: String? = ""
    var descriptionES: String? = ""
    
    var descriptionPT: String? = ""
    var descriptionSE: String? = ""
    var descriptionNL: String? = ""
    var descriptionHU: String? = ""
    
    var descriptionNO: String? = ""
    var descriptionPL: String? = ""
    var descriptionIL: String? = ""
    
    var colour1: String? = ""
    var colour2: String? = ""
    var colour3: String? = ""
    
    var gender: String? = ""
    var country: String? = ""
    
    var banner: String? = ""
    var badge: String? = ""
    var logo: String? = ""
    
    var fanart1: String? = ""
    var fanart2: String? = ""
    var fanart3: String? = ""
    var fanart4: String? = ""
    
    var equipment: String? = ""
    var locked: String? = ""
    
    var teamShort: String? = ""
    
    var idLeague: String? = ""
    var league2Name: String? = ""
    var idLeague2: String? = ""
    var league3Name: String? = ""
    var idLeague3: String? = ""
    var league4Name: String? = ""
    var idLeague4: String? = ""
    var league5Name:String? = ""
    var idLeague5: String? = ""
    var league6Name: String? = ""
    var idLeague6: String? = ""
    var league7Name: String? = ""
    var idLeague7: String? = ""
    
    var divisionName: String? = ""
    var idVenue: String? = ""
    var stadiumName: String? = ""
    var keywords: String? = ""
    
    var locationName: String? = ""
    var stadiumCapacity: String? = ""
}


extension Team {
    
    
    func fetchPlayersAndTrophies() async -> ([Player], [TrophyGroup]) {
        
        do {
            let htmlContent = try await fetchHTML(from: "https://www.thesportsdb.com/team/\(idTeam ?? "")-\(teamName)?a=1#alltrophies")
            let htmlPlayersAndTrophies = getHTML(of: htmlContent, from: ">Team Members</b>", to: "<b>Fanart<")
            
            let trophies = parseTrophies(from: htmlPlayersAndTrophies)
            let players = parsePlayers(from: htmlPlayersAndTrophies)
        
            let trophyGroups = groupTrophies(trophies)
            return (players, trophyGroups)
        } catch {
            return ([], [])
        }
        
    }
    
    func groupTrophies(_ trophies: [Trophy]) -> [TrophyGroup] {
        let grouped = Dictionary(grouping: trophies) { trophy in
            TrophyGroupKey(title: trophy.title, honourArtworkLink: trophy.honourArtworkLink)
        }

        return grouped.map { key, values in
            TrophyGroup(
                title: key.title,
                honourArtworkLink: key.honourArtworkLink,
                listSeason: values.map { $0.season }.sorted()
            )
        }
    }
}

import SwiftSoup

func parseTrophies(from html: String) -> [Trophy] {
    var trophies: [Trophy] = []

    do {
        let doc: Document = try SwiftSoup.parse(html)
        let tdElements = try doc.select("td[align=center]")
        for td in tdElements {
            
            guard
                let a = try? td.select("a").first(),
                let img = try? td.select("img").first(),
                let year = try? td.ownText().trimmingCharacters(in: .whitespacesAndNewlines),
                let title = try? img.attr("title"),
                let imageURL = try? img.attr("src")
            else { continue }
            let trophy = Trophy(title: title, years: [year], honourArtworkLink: imageURL)
            trophies.append(trophy)
        }

    } catch {
        print("⚠️ Parse error: \(error)")
    }

    
    return trophies
}

func parsePlayers(from html: String) -> [Player] {
    var players: [Player] = []

    do {
        let doc: Document = try SwiftSoup.parse(html)
        let tdElements = try doc.select("td[valign=top]")
        for td in tdElements {
            
            guard
                let a = try? td.select("a").first(),
                let img = try? td.select("img[alt=player render]").first(),
                let h = try? td.ownText().trimmingCharacters(in: .whitespacesAndNewlines),
                let imageURL = try? img.attr("src"),
                let pathFullName = try? a.attr("href")
            else { continue }

            guard let index = pathFullName.firstIndex(of: "-") else {
                continue
            }
            
            let afterColonIndex = pathFullName.index(after: index)
            var fullName = String(pathFullName[afterColonIndex...])
            fullName = decodeAndFormat(fullName)
            let player = Player(player: fullName, cutout: imageURL, render: imageURL)
            players.append(player)
        }

    } catch {
        print("⚠️ Parse error: \(error)")
    }

    
    return players
}


func decodeAndFormat(_ raw: String) -> String {
    // 1. Decode percent-encoding
    guard let decoded = raw.removingPercentEncoding else { return raw }
    
    // 2. Replace hyphens with spaces
    let spaced = decoded.replacingOccurrences(of: "-", with: " ")
    
    // 3. Capitalize each word
    let formatted = spaced.capitalized(with: Locale(identifier: "tr_TR")) // Turkish locale
    
    return formatted
}
