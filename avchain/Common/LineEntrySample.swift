//
//  LineEntrySample.swift
//  avchain
//

import DGCharts
import Foundation

struct LineEntrySample {
    
    
    static func getData() -> LineChartData {
        let yVals3 = (0..<10).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(20) + 500)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let dataSet = LineChartDataSet(entries: yVals3)
        dataSet.setColor(.systemBlue)
        let lineChartData = LineChartData(dataSet: dataSet)
        
        return lineChartData
    }
    
}
