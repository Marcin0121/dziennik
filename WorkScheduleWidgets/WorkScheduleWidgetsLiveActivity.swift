//
//  WorkScheduleWidgetsLiveActivity.swift
//  WorkScheduleWidgets
//
//  Created by Marcin Seńko on 2/26/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WorkScheduleWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WorkScheduleWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkScheduleWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WorkScheduleWidgetsAttributes {
    fileprivate static var preview: WorkScheduleWidgetsAttributes {
        WorkScheduleWidgetsAttributes(name: "World")
    }
}

extension WorkScheduleWidgetsAttributes.ContentState {
    fileprivate static var smiley: WorkScheduleWidgetsAttributes.ContentState {
        WorkScheduleWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WorkScheduleWidgetsAttributes.ContentState {
         WorkScheduleWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WorkScheduleWidgetsAttributes.preview) {
   WorkScheduleWidgetsLiveActivity()
} contentStates: {
    WorkScheduleWidgetsAttributes.ContentState.smiley
    WorkScheduleWidgetsAttributes.ContentState.starEyes
}
