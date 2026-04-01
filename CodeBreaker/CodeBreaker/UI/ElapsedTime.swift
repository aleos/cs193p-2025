//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by Alexander Ostrovsky on 29/3/2026.
//

import SwiftUI

struct ElapsedTime: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var format: SystemFormatStyle.DateOffset {
        .offset(to: startTime! - elapsedTime, allowedFields: [.minute, .second])
    }
    
    var body: some View {
        if let _ = startTime {
            if let endTime {
                Text(endTime, format: format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format)
            }
        } else {
            Image(systemName: "pause")
        }
    }
}

#Preview {
    ElapsedTime(startTime: .now - 50, endTime: nil, elapsedTime: 5)
    ElapsedTime(startTime: .now - 50, endTime: .now, elapsedTime: 5)
}
