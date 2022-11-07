
import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository
    
    let formatter = ISO8601DateFormatter()
    var daysSinceLastAtivity: Int {
        calculateDaysSinceLastActivity(from: repo.pushedAt)
    }
    
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                HStack {
                    Image(uiImage: UIImage(data:repo.avatarData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50,height: 50)
                        .clipShape(Circle())
                    
                    Text(repo.name)
                        .font(.title2)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    
                }
                .padding(.bottom,6)
                
                HStack {
                    statsLabel(value:repo.watchers, systemImageName: "star.fill")
                    statsLabel(value:repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        statsLabel(value:repo.openIssues , systemImageName: "exclamationmark.triangle.fill")
                    }
                    
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
    
    func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let LastActivityDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day],from: LastActivityDate,to: .now).day ?? 0
        return daysSinceLastActivity
    }
    
}


struct RepoMediumView_Previews: PreviewProvider {
    static var previews: some View {
        RepoMediumView(repo: MockData.RepoOne)
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
