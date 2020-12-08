//
//  DashboardView.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 8.12.20.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGray5).ignoresSafeArea()
            VStack {
                HStack {
                    
                    DashboardItemView(icon: Image(systemName: "tray.2.fill"), count: "550", title: "All", iconColor: .blue)
                    DashboardItemView(icon: Image(systemName: "calendar"), count: "50", title: "Today", iconColor: .gray)
                }
                HStack {
                    
                    DashboardItemView(icon: Image(systemName: "flag.circle.fill"), count: "4", title: "Flagged", iconColor: .red)
                }
            }
            
        }
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}



struct DashboardItemView: View {
    let icon: Image
    let count: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            Button(action: {}, label: {
                VStack(alignment: .center) {
                    HStack {
                        icon
                            .font(.title)
                            .foregroundColor(iconColor)
                        Text(count)
                            .font(.title)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    Text(title)
                        
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15.0)
            })
        }
    }
}
