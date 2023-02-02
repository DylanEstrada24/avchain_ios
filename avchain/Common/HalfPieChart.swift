//
//  PieChart.swift
//  avchain
//

import DGCharts
import SwiftUI

struct HalfPieChart: UIViewRepresentable {
    
    var entries: [PieChartDataEntry]
    var color: NSUIColor = NSUIColor(red: 193/255.0, green: 37/255.0, blue: 82/255.0, alpha: 1.0)
    @State var category: String
    let pieChart = PieChartView()
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        pieChart.maxAngle = 180 // Half chart
        pieChart.rotationAngle = 180 // Rotate to make the half on the upper side
        pieChart.centerTextOffset = CGPoint(x: 0, y: -20)
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [color, .lightGray]
        dataSet.label = ""
        let pieChartData = PieChartData(dataSet: dataSet)
        uiView.data = pieChartData
        uiView.holeRadiusPercent = 0.5
        configureChart(uiView)
        formatCenter(uiView)
//        formatDescription(uiView.chartDescription)
        formatLegend(uiView.legend)
        formatDataSet(dataSet)
        uiView.notifyDataSetChanged()
        uiView.usePercentValuesEnabled = true
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: HalfPieChart
        init(parent: HalfPieChart) {
            self.parent = parent
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//            let labelText = entry.value(forKey: "label")! as! String
            let num = entry.value(forKey: "value")! as! Double
            parent.pieChart.centerText = """
            \(num)
            """
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // 그래프 설정
    func configureChart( _ pieChart: PieChartView) {
        pieChart.rotationEnabled = false
        pieChart.animate(xAxisDuration: 0.5, easingOption: .easeInOutCirc)
        pieChart.drawEntryLabelsEnabled = false
        pieChart.highlightValue(x: -1, dataSetIndex: 0, callDelegate: false)
    }
    
    // 그래프 중앙 설정
    func formatCenter(_ pieChart: PieChartView) {
        pieChart.holeColor = UIColor.systemBackground
        pieChart.centerText = category
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    // 우측 하단에 그래프의 설명 기입
    func formatDescription( _ description: Description) {
//        description.text = category
//        description.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    // 좌측 하단에 항목 설명
    func formatLegend(_ legend: Legend) {
        legend.enabled = false
    }
    
    // 그래프의 항목별 값 설정
    func formatDataSet(_ dataSet: ChartDataSet) {
        dataSet.drawValuesEnabled = false
    }
}

struct HalfPieChart_Previews : PreviewProvider {
    static var previews: some View {
        HalfPieChart(entries: Wine.entriesForWines(Wine.allWines, category: .variety), category: "4.5")
            .frame(height: 400)
            .padding()
    }
}
