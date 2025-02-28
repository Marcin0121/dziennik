//
//  MyAppWidgetsBundle.swift
//  MyAppWidgets
//
//  Created by Marcin Seńko on 2/26/25.
//

import WidgetKit
import SwiftUI

@main
struct MyAppWidgetsBundle: WidgetBundle {
    var body: some Widget {
        MyAppWidgets()
        MyAppWidgetsControl()
        MyAppWidgetsLiveActivity()
    }
}
