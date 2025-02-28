//
//  MyAppWidgetsLiveActivity.swift
//  MyAppWidgets
//
//  Created by Marcin Seńko on 2/26/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MyAppWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MyAppWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyAppWidgetsAttributes.self) { context in
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

extension MyAppWidgetsAttributes {
    fileprivate static var preview: MyAppWidgetsAttributes {
        MyAppWidgetsAttributes(name: "World")
    }
}

extension MyAppWidgetsAttributes.ContentState {
    fileprivate static var smiley: MyAppWidgetsAttributes.ContentState {
        MyAppWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MyAppWidgetsAttributes.ContentState {
         MyAppWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MyAppWidgetsAttributes.preview) {
   MyAppWidgetsLiveActivity()
} contentStates: {
    MyAppWidgetsAttributes.ContentState.smiley
    MyAppWidgetsAttributes.ContentState.starEyes
}
