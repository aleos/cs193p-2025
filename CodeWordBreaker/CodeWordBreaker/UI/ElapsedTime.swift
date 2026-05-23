//
//  ElapsedTime.swift
//  CodeWordBreaker
//
//  Created by Alexander Ostrovsky on 31/3/2026.
//

import SwiftUI

struct ElapsedTime: View {
    // MARK: Data In
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    var isShowPause = false
    
    // MARK: - Body
    
    var format: SystemFormatStyle.DateOffset {
        let date =
        if let endTime {
            endTime - elapsedTime
        } else if let startTime {
            startTime - elapsedTime
        } else {
            .now - elapsedTime
        }
        return .offset(to: date, allowedFields: [.minute, .second], sign: .never)
    }
    
    var body: some View {
        if isShowPause, startTime == nil {
            Image(systemName: "pause")
        } else {
            if let endTime {
                Text(endTime, format: format) // ignore start time
            } else if let _ = startTime {
                Text(TimeDataSource<Date>.currentDate, format: format)
            } else {
                Text(.now, format: format) // no start and end time, only elapsed
            }
        }
    }
}

#Preview {
    HStack {
        ElapsedTime(startTime: .now - 50, endTime: nil, elapsedTime: 5)
        ElapsedTime(startTime: .now - 50, endTime: nil, elapsedTime: 5, isShowPause: true)
    }
    HStack {
        ElapsedTime(startTime: .now - 50, endTime: .now, elapsedTime: 5)
        ElapsedTime(startTime: .now - 50, endTime: .now, elapsedTime: 5, isShowPause: true)
    }
    HStack {
        ElapsedTime(startTime: nil, endTime: .now, elapsedTime: 5)
        ElapsedTime(startTime: nil, endTime: .now, elapsedTime: 5, isShowPause: true)
    }
    HStack {
        ElapsedTime(startTime: nil, endTime: nil, elapsedTime: 5)
        ElapsedTime(startTime: nil, endTime: nil, elapsedTime: 5, isShowPause: true)
    }
}
