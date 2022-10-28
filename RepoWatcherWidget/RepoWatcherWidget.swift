//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Nicolas Rios on 10/25/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(),repo: Respository.placeholder,avatarImageData: Data())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(),repo: Respository.placeholder,avatarImageData: Data())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
            Task {
                let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

                do {
                    let repo = try await NetworkManager.shared.getRepo(atURL: RepoURL.swiftNew)
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                    let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData ?? Data())
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
    let repo: Respository
    let avatarImageData: Data
}

struct RepoWatcherWidgetEntryView : View {
    var entry: RepoEntry
    let formatter = ISO8601DateFormatter()
    var daysSinceLastAtivity: Int {
        calculateDaysSinceLastActivity(from: entry.repo.pushedAt)
    }
    
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                HStack {
                    Image(uiImage: UIImage(data: entry.avatarImageData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50,height: 50)
                        .clipShape(Circle())
                        
                    Text(entry.repo.name)
                        .font(.title2)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    
                }
                .padding(.bottom,6)
                
                HStack {
                    statsLabel(value:entry.repo.watchers, systemImageName: "star.fill")
                    statsLabel(value:entry.repo.forks, systemImageName: "tuningfork")
                    statsLabel(value:entry.repo.openIssues , systemImageName: "exclamationmark.triangle.fill")
                }
                
            }
            
            Spacer()
            
            VStack {
                Text("\(daysSinceLastAtivity)")
                    .bold()
                    .font(.system(size:70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(daysSinceLastAtivity > 50 ? .pink: .green)
                
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    func calculateDaysSinceLastActivity(from dateString:String) -> Int{
        let LastActivityDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day],from: LastActivityDate,to: .now).day ?? 0
        return daysSinceLastActivity
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
        .supportedFamilies([.systemMedium])
    }
}

struct RepoWatcherWidget_Previews: PreviewProvider {
    static var previews: some View {
        RepoWatcherWidgetEntryView(entry: RepoEntry(date: Date(), repo: Respository.placeholder,avatarImageData: Data()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

fileprivate struct statsLabel: View {
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}


