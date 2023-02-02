//
//  BarChart.swift
//  avchain
//

import DGCharts
import SwiftUI

struct BarChart: UIViewRepresentable {
    let entries: [BarChartDataEntry]
    let captions: [String]
    let barChartView = BarChartView()
    func makeUIView(context: Context) -> BarChartView {
        barChartView.delegate = context.coordinator
        return barChartView
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = ""
        uiView.noDataText = "No Data"
        var barData = BarChartData(dataSet: dataSet)
        barData.barWidth = 0.4
        uiView.data = barData
        uiView.rightAxis.enabled = false
        uiView.zoom(scaleX: 1, scaleY: 1, x: 0, y: 0)
        uiView.doubleTapToZoomEnabled = false
        uiView.pinchZoomEnabled = false
        uiView.setScaleEnabled(false)
        
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: BarChart
        init(parent: BarChart) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func formatDataSet(dataSet: BarChartDataSet) {
        dataSet.colors = [ChartColorTemplates.material()[3]]
        dataSet.valueColors = [.black]
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = .black
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        // 그래프 가로축 value text
        xAxis.valueFormatter = IndexAxisValueFormatter(values: captions)
        xAxis.labelPosition = .bottom
        
    }
    
    func setXAxisValueFormat(_ uiView: BarChartView, values: [String]) {
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: values)
    }
    
    func formatLegend(legend: Legend) {
        legend.textColor = .black
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .bottom
        legend.drawInside = false
        legend.enabled = false
    }
}


struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(entries: WineTransaction.dataEntriesForYear(2019, transactions: WineTransaction.allTransactions), captions: WineTransaction.months)
    }
}
