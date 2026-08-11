import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderDashboardChart extends StatelessWidget {
  final int pending;
  final int processing;
  final int confirmed;
  final int outForDelivery;

  const OrderDashboardChart({
    super.key,
    required this.pending,
    required this.processing,
    required this.confirmed,
    required this.outForDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final total = pending + processing + confirmed + outForDelivery;
    final data = [
      _ChartData('Pending', pending, Colors.orange),
      _ChartData('Packaging', processing, Colors.purple),
      _ChartData('Confirmed', confirmed, Colors.blue),
      _ChartData('Delivery', outForDelivery, Colors.green),
    ];

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              annotations: [
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$total',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      const Text('Orders')
                    ],
                  ),
                )
              ],
              series: <DoughnutSeries<_ChartData, String>>[
                DoughnutSeries<_ChartData, String>(
                  animationDuration: 1800,
                  animationDelay: 250,
                  radius: '88%',
                  innerRadius: '72%',
                  cornerStyle: CornerStyle.bothCurve,
                  dataSource: data,
                  xValueMapper: (d, _) => d.title,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) => d.color,
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data.map((e)=>_legend(e,total)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _legend(_ChartData item,int total){
    final p = total==0?0.0:item.value/total;
    return Column(
        children:[
          Row(
              children:[
                Container(width:10,height:10,decoration:BoxDecoration(color:item.color,shape:BoxShape.circle)),
                const SizedBox(width:8),
                Expanded(child:Text(item.title,overflow:TextOverflow.ellipsis)),
                Text('${item.value}',style:TextStyle(color:item.color,fontWeight:FontWeight.bold))
              ]
          ),
          const SizedBox(height:6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value:p,
              minHeight:6,
              backgroundColor:item.color.withOpacity(.15),
              valueColor:AlwaysStoppedAnimation(item.color),
            ),
          )
        ]
    );
  }
}

class _ChartData{
  final String title;
  final int value;
  final Color color;
  _ChartData(this.title,this.value,this.color);
}
