//
//  WorkScheduleWidgetsBundle.swift
//  WorkScheduleWidgets
//
//  Created by Marcin Seńko on 2/26/25.
//

import WidgetKit
import SwiftUI

@main
struct WorkScheduleWidgetsBundle: WidgetBundle {
    var body: some Widget {
        WorkScheduleWidgets()
        WorkScheduleWidgetsControl()
        WorkScheduleWidgetsLiveActivity()
    }
}
