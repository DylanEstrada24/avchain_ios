//
//  LineChart.swift
//  avchain
//

import DGCharts
import SwiftUI

struct LineChart: UIViewRepresentable {
    
//    var entries: [ChartDataEntry]
    var data: LineChartData
    var captions: [String] = []
    
    let lineChart = LineChartView()
    func makeUIView(context: Context) -> LineChartView {
        lineChart.delegate = context.coordinator
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
//        let dataSet = LineChartDataSet(entries: entries)
//        dataSet.setColor(.systemBlue)
//        let lineChartData = LineChartData(dataSet: dataSet)
//        uiView.data = lineChartData
        uiView.data = data
        uiView.zoom(scaleX: 1, scaleY: 1, x: 0, y: 0)
        uiView.rightAxis.enabled = false
        
        disablePinchZoom(uiView)
        disableDoubleTapZoom(uiView)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: LineChart
        init(parent: LineChart) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func disablePinchZoom(_ lineChart: LineChartView) {
        lineChart.pinchZoomEnabled = false
    }
    
    func disableDoubleTapZoom(_ lineChart: LineChartView) {
        lineChart.doubleTapToZoomEnabled = false
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = .black
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        leftAxis.labelPosition = .outsideChart
    }
    
    func formatXAxis(xAxis: XAxis) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: captions)
        xAxis.labelPosition = .bottom
    }
    
}

struct LineChart_Previews : PreviewProvider {
    
    static var previews: some View {
        LineChart(data: LineEntrySample.getData())
            .frame(height: 400)
            .padding()
    }
}

