
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(),repo: MockData.RepoOne, bottomRepo: MockData.RepoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(),repo: MockData.RepoOne, bottomRepo: MockData.RepoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) 
            
            do {
               
                var repo = try await NetworkManager.shared.getRepo(atURL: RepoURL.swiftNews)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                var bottomRepo: Repository?
                
                if context.family == .systemLarge {
                    var repo = try await NetworkManager.shared.getRepo(atURL: RepoURL.publish)
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                    
                }
                
                let entry = RepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}


struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
    
}

struct RepoWatcherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: RepoEntry
    
    
    var body: some View {
        switch family {
            case.systemMedium:
                RepoMediumView(repo: entry.repo)
            case.systemLarge:
                VStack(spacing: 36) {
                    RepoMediumView(repo: entry.repo)
                    if let bottomRepo = entry.bottomRepo {
                        RepoMediumView(repo: bottomRepo)
                    }
                   
                }
            case.systemSmall,.systemExtraLarge,.accessoryCircular,.accessoryRectangular,.accessoryInline:
                EmptyView()
            @unknown default:
                EmptyView()
                
        }
        
    }
}


struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RepoWatcherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}

struct RepoWatcherWidget_Previews: PreviewProvider {
    static var previews: some View {
        RepoWatcherWidgetEntryView(entry: RepoEntry(date: Date(),
                                                    repo: MockData.RepoOne,
                                                    bottomRepo: MockData.RepoTwo))
                                                    
                                
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}




