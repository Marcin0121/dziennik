//
//  Provider.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/26/25.
//


import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = <#type#>
    
    typealias Intent = <#type#>
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), workSchedule: sampleWorkSchedule())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, workSchedule: sampleWorkSchedule())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, workSchedule: sampleWorkSchedule())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let workSchedule: [WorkSchedule]
}

struct WorkSchedule {
    let day: String
    let hours: String
}

func sampleWorkSchedule() -> [WorkSchedule] {
    return [
        WorkSchedule(day: "Poniedziałek", hours: "9:00 - 17:00"),
        WorkSchedule(day: "Wtorek", hours: "9:00 - 17:00"),
        WorkSchedule(day: "Środa", hours: "9:00 - 17:00"),
        WorkSchedule(day: "Czwartek", hours: "9:00 - 17:00"),
        WorkSchedule(day: "Piątek", hours: "9:00 - 17:00")
    ]
}

struct WorkScheduleWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(entry.workSchedule, id: \.day) { schedule in
                HStack {
                    Text(schedule.day)
                    Spacer()
                    Text(schedule.hours)
                }
            }
        }
        .padding()
    }
}

@main
struct WorkScheduleWidgets: Widget {
    let kind: String = "WorkScheduleWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WorkScheduleWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Work Schedule Widget")
        .description("Displays your work schedule.")
    }
}

struct WorkScheduleWidgets_Previews: PreviewProvider {
    static var previews: some View {
        WorkScheduleWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), workSchedule: sampleWorkSchedule()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
