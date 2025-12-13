//
//  ListLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct ListLeagueRouteView: View {
    var body: some View {
        RouteGenericView(
            headerView: ListLeagueRouteHeaderView()
            , contentView: ListLeagueRouteContentView())
    }
}

struct ListLeagueRouteContentView: View {
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    
    var body: some View {
        if let countrySelected = countryListVM.countrySelected {
            
            ScrollView(showsIndicators: false) {
                ListLeaguesView(country: countrySelected.name, sport: sportVM.sportSelected.rawValue, onRetry: {
                    print("=== onRetry ListLeaguesView", countrySelected)
                })
            }
        }
    }
}

struct ListLeagueRouteHeaderView: View {
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                leagueListVM.resetAll()
                sportRouter.pop()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            if let country = countryListVM.countrySelected {
                HStack(spacing: 5) {
                    KFImage(URL(string: country.getFlag(by: .Medium)))
                        .placeholder {
                            ProgressView()
                        }
                        .font(.caption)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    Text(country.name)
                        .font(.body.bold())
                }
            }
            Spacer()
        }
        //.backgroundOfRouteHeaderView(with: 70)
        .backgroundByTheme(for: .Header(height: 70))
    }
}

struct ListLeaguesView: View {
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    let country: String
    let sport: String
    
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    
    @State var numbRetry: Int = 0
    @State var onRetry: () -> Void
    
    var body: some View {
        switch leagueListVM.leaguesStatus {
        case .loading:
            SmartContainer(maxWidth: .grid) {
                SmartGrid(columns: DeviceSize.current.isPad ? 5 : 3, spacing: .medium) {
                    getExampleView()
                }
            }
        case .success(data: _):
            SmartContainer(maxWidth: .grid) {
                SmartGrid(columns: DeviceSize.current.isPad ? 5 : 3, spacing: .medium) {
                    LeaguesView(leagues: leagueListVM.leagues, badgeImageSizePerLeague: badgeImageSizePerLeague, tappedLeague: tappedLeague)
                }
            }
        case .idle:
            Spacer()
        case .failure(error: _):
            Text("Please return in a few minutes.")
                .font(.caption2.italic())
                .onAppear {
                    numbRetry += 1
                    guard numbRetry <= 3 else { numbRetry = 0 ; return }
                    onRetry()
                }
        }
        
    }
    
    @ViewBuilder
    func getExampleView() -> some View {
        let league = getLeaguesExample()
        ForEach(0 ..< 12) {_ in
            VStack {
                LeagueItemView(league: league, badgeImageSize: badgeImageSizePerLeague)
            }
            .redacted(reason: .placeholder)
            .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
            //.backgroundOfItemTouched(color: .clear)
            
        }
    }
    
    func tappedLeague(by league: League) {
        
        Task {
            await seasonListVM.getListSeasons(leagueID: league.idLeague ?? "")
            leagueDetailVM.setLeague(by: league)
            sportRouter.navigateToLeagueDetail(by: league.idLeague ?? "")
            // Get list teams
            await teamListVM.getListTeams(leagueName: league.leagueName ?? "", sportName: sport, countryName: country)
        }
        
        eventsRecentOfLeagueVM.getEvents(by: league.idLeague ?? "")
    }
    
}

struct LeaguesSuccessView: View {
    let leagues: [League] // Adjust type
    let columns: [GridItem]
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    let tappedLeague: (League) -> Void
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            LeaguesView(
                leagues: leagues,
                badgeImageSizePerLeague: badgeImageSizePerLeague,
                tappedLeague: tappedLeague
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

func getLeaguesExample() -> League {
    if let jsonEventDTOData = LeagueExampleJson.data(using: .utf8) {
        do {
            let decoder = JSONDecoder()
            let eventDTO = try decoder.decode(LeagueDTO.self, from: jsonEventDTOData)
            let domainModel = eventDTO.toDomain()
            return domainModel
        } catch {
            print("❌ JSON decode failed: \(error)")
        }
    }
    
    return League()
}

let LeagueExampleJson = """
{
            "idLeague": "4406",
            "idSoccerXML": null,
            "idAPIfootball": "7000",
            "strSport": "Soccer",
            "strLeague": "Argentinian Primera Division",
            "strLeagueAlternate": "Liga Profesional de Fútbol",
            "intDivision": "1",
            "idCup": "0",
            "strCurrentSeason": "2025",
            "intFormedYear": "1891",
            "dateFirstEvent": "2015-02-13",
            "strGender": "Male",
            "strCountry": "Argentina",
            "strWebsite": "www.ligaprofesional.ar",
            "strFacebook": "www.facebook.com/ligaprofesionalAFA",
            "strInstagram": "",
            "strTwitter": "twitter.com/LigaAFA",
            "strYoutube": "www.youtube.com/channel/UCJmCVoUfCBQb9lcfXIS8nXQ",
            "strRSS": "",
            "strDescriptionEN": "The Primera División, named Liga Profesional de Fútbol since 2020, is a professional football league in Argentina, organised by the Argentine Football Association (AFA).\r\n\r\nThe Primera División is the country's premier football division and is the top division of the Argentine football league system. It operates on a system of promotion and relegation with the Primera Nacional (Second Division), with the teams placed lowest at the end of the season being relegated.\r\n\r\nWith the first championship held in 1891, Argentina became the first country outside the United Kingdom (where the Football League had been debuted in 1888) to establish a football league. In the early years, only teams from Buenos Aires, Greater Buenos Aires, La Plata and Rosario were affiliated to the national association. Teams from other cities would join in later years.\r\n\r\nThe Primera División turned professional in 1931 when 18 clubs broke away from the amateur leagues to form a professional one. Since then, the season has been contested annually in four different formats and calendars.\r\n\r\nThe Argentine championship was ranked in the top 10 as one of the strongest leagues in the world (for 1 January 2015 – 31 December 2015 period) by the International Federation of Football History & Statistics (IFFHS). Argentina placed 4th after La Liga (Spain), Serie A (Italy), and Bundesliga (Germany).",
            "strDescriptionDE": null,
            "strDescriptionFR": "Le Championnat d'Argentine de football (espagnol : Primera División) est une compétition de football organisée par l'AFA (Asociación del Fútbol Argentino), opposant les 20 meilleures équipes d'Argentine et couronnant deux champions par an. La première partie du championnat, appelée Initial (Inicial) se dispute d'août à décembre et la seconde partie, appelée Final, se dispute de février à juin.\r\n\r\nLe championnat d'Argentine est, selon l'IFFHS, l'un des meilleurs championnats du monde. Il était en 2013 considéré comme le 6e meilleur du monde. Il alimente en joueurs de très nombreux championnats européens et mondiaux, notamment la Liga espagnole, la Serie A ou la Premier League.\r\n\r\nLes clubs argentins ont obtenu 62 titres internationaux, un record mondial.\r\n\r\nPromotions et relégations n'ont lieu qu'en juin, à l'issue du tournoi Final, par un système complexe de moyennes. Les équipes ayant obtenu les plus mauvaises moyennes sont reléguées en deuxième division.",
            "strDescriptionIT": "La Primera División, nota anche come Liga Profesional de Fútbol (LPF), è il massimo livello del campionato di calcio argentino.\r\n\r\nDapprima strutturata in un torneo unico, dalla stagione 1990-1991 alla stagione 2013-2014 è stata divisa in due tornei, denominati Apertura e Clausura (dalla stagione 1990-1991 alla stagione 2011-2012) e Tornei Inicial e Final (stagioni 2012-2013 e 2013-2014), di cui il primo equivaleva al girone di andata dei campionati europei ed il secondo al girone di ritorno.[1][2]\r\n\r\nNel 2015 è stata varata una riforma che ha portato il campionato ad avere 30 squadre[3]. Ciononostante, nel 2016 la modifica è stata rivoltata, pertanto la quantità di squadre diminuirà gradualmente fino ad avere 22 squadre nella stagione 2020-21.[4]. La situazione creata dall'emergenza COVID-19 ha però rinviato quanto precedentemente deciso.\r\n\r\nIl campionato 2019-2020 a 24 squadre, è iniziato a luglio 2019 e terminato il marzo successivo, con la disputa del solo girone di andata.\r\n\r\nL'inizio della stagione 2020-21 è stato ripetutamente ritardato a causa del perdurare dell'emergenza COVID-19, fino a quando il governo ha finalmente concesso di poter iniziare ad ottobre. Pertanto l'AFA, dopo aver deciso di iniziare, salvo che la situazione sanitaria dovesse precipitare repentinamente, ha posticipato il campionato nazionale a marzo 2021 (e pertanto, per la prima volta dal 1892 il campionato, nel 2020, non verrà giocato) e organizzato l'edizione 2020 della Copa de la Liga Profesional, concepita come un torneo di emergenza, con la partecipazione delle 24 squadre della massima serie.\r\n\r\nIl club più titolato è il River Plate, vincitore di 36 campionati.[5][6]\r\n\r\nAlla Coppa Libertadores si qualificano il campione e le squadre collocate al secondo e terzo posto nella classifica finale. Un'altra piazza, valida per i preliminari, spetta a quella situata in quarta posizione. Gli altri due qualificati sono i vincitori della Copa Argentina e della Copa de la Superliga Argentina. Esiste anche una seconda competizione continentale, la Copa Sudamericana, a cui si qualificano le squadre collocate tra il quinto e il nono posto, più il secondo posto della Copa de la Superliga Argentina.\r\n\r\nRetrocedono direttamente nella Primera B Nacional le quattro squadre con la peggior media punti delle tre stagioni precedenti (quello che in Argentina viene chiamato promedio), e vengono promossi i due club che hanno ottenuto più punti nell'ultima stagione. La media punti delle squadre neo-promosse si conteggia a partire dalla loro promozione. Questo complesso sistema, che penalizza le squadre più deboli e le neo-promosse, è stato varato nel 1983, due anni dopo la retrocessione del San Lorenzo de Almagro. Quell'anno, il River Plate finì diciottesimo e scampò la seconda categoria, mentre il Racing Club e il Nueva Chicago furono i primi a retrocedere.\r\n\r\nIl massimo goleador storico del campionato argentino è il paraguaiano Arsenio Erico, con 295 gol. D'altra parte, Bernabé Ferreyra ha la miglior media-gol: 1,03 (206 reti in 197 gare disputate).\r\n\r\nNel 2020 il campionato argentino si è posizionato al 9º posto della classifica mondiale dei campionati stilata annualmente dall'IFFHS e al 3º posto a livello continentale.",
            "strDescriptionCN": null,
            "strDescriptionJP": null,
            "strDescriptionRU": null,
            "strDescriptionES": "El campeonato de Primera División del fútbol argentino es un torneo organizado por la Asociación del Fútbol Argentino (AFA) y es la máxima categoría del sistema de campeonatos de dicho deporte en Argentina.\r\n\r\nEn el certamen actual participan treinta equipos, los que son presentados por clubes, asociaciones civiles sin fines de lucro, aunque desde el año 2000 puede darse la situación de que el equipo esté gerenciado por una empresa privada, en representación y con la aprobación del club respectivo.\r\n\r\nA pesar de haberse decidido oficialmente que, a partir del Campeonato 2015, se cambiaría el modelo de dos torneos cortos, utilizando calendario europeo, a un solo concurso que transcurriría en el año calendario, aumentando el número de participantes a 30 equipos,9 en su reunión del 11 de noviembre de 2014, el Comité Ejecutivo de la Asociación propuso una revisión de lo actuado. Por ese motivo se produjo una controversia sobre el modo de disputa y el calendario de ese certamen,10 11 12 13 14 aunque finalmente, ante la intervención de directivos de la televisión y el gobierno, se propuso respetar lo acordado en la reunión del 3 de junio de 2014 y ratificar el modo de disputa del torneo.15\r\n\r\nEl concurso se realiza en una ronda de todos contra todos, con el agregado de un partido según los emparejamientos realizados por la Asociación, basado, en la mayoría de los casos, en los que se consideran rivales clásicos. Esos partidos se jugarán en la 24.ª fecha y en los mismos se invertirá la condición de local con respecto al otro enfrentamiento. De esta manera, cada equipo disputará un total de 30 partidos.\r\n\r\nPor otro lado, se producirán dos descensos a la segunda división, la Primera B Nacional, determinados según la tabla de promedios de los cuatro últimos torneos. Asimismo, se producirá la clasificación de 3 equipos a la Copa Libertadores 2016 y de otros 5 a la Copa Sudamericana del mismo año, cuyos cupos se completarán con la realización de dos liguillas, método que se reflotará luego de haberse empleado por última vez en la temporada 1991/92.\r\n\r\nEl Campeonato de Primera División es uno de los mejores del mundo de acuerdo con la Federación Internacional de Historia y Estadística de Fútbol. En la última clasificación, la del año 2014, ocupa el cuarto puesto en el ranking anual de dicha institución,16 que se elabora desde 1991. La Primera División de Argentina, a excepción de 1993, siempre estuvo entre las diez primeras. Su mejor ubicación en este ranking se dio en 2008, cuando logró el tercer lugar, siendo superada apenas por la Premier League de Inglaterra y por la Serie A de Italia. Estas mismas ligas son las que ocupan los tres primeros lugares del escalafón actual, junto con la Primera División de España.",
            "strDescriptionPT": null,
            "strDescriptionSE": null,
            "strDescriptionNL": null,
            "strDescriptionHU": null,
            "strDescriptionNO": null,
            "strDescriptionPL": null,
            "strDescriptionIL": null,
            "strTvRights": "US - CBS Sports [2021-2024]",
            "strFanart1": "https://r2.thesportsdb.com/images/media/league/fanart/wrppvx1422244030.jpg",
            "strFanart2": "https://r2.thesportsdb.com/images/media/league/fanart/s21imk1695735200.jpg",
            "strFanart3": "https://r2.thesportsdb.com/images/media/league/fanart/7704o21695735236.jpg",
            "strFanart4": "https://r2.thesportsdb.com/images/media/league/fanart/7gng001695735260.jpg",
            "strBanner": "https://r2.thesportsdb.com/images/media/league/banner/7x4xmv1567241754.jpg",
            "strBadge": "https://r2.thesportsdb.com/images/media/league/badge/1vslha1589960216.png",
            "strLogo": "https://r2.thesportsdb.com/images/media/league/logo/v4zcaz1589960217.png",
            "strPoster": "https://r2.thesportsdb.com/images/media/league/poster/wr7uyy1636806020.jpg",
            "strTrophy": "https://r2.thesportsdb.com/images/media/league/trophy/xrvqvx1422244125.png",
            "strNaming": "{strHomeTeam} vs {strAwayTeam}",
            "strComplete": "yes",
            "strLocked": "unlocked"
        }
"""
