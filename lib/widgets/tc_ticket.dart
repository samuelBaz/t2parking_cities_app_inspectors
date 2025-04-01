import 'package:flutter/material.dart';
import 'package:t2parking_cities_inspector_app/models/ticket.dart';
import 'package:t2parking_cities_inspector_app/utils/string_utils.dart';

class TCTicket extends StatelessWidget {
  final Ticket ticket;

  const TCTicket({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Color(0XFFF3f3f3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset('images/logo.png', width: 130)),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text('Estacionamiento Tarifado'),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              ticket.parkingAreaName,
              style: TextStyle(color: Colors.black45),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MATRÍCULA',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(ticket.plate.toUpperCase()),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DURACIÓN', style: TextStyle(color: Colors.black45)),
                      Text('${ticket.duration.toString()} minutos'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FECHA', style: TextStyle(color: Colors.black45)),
                      Text(formatUtcTo3Letters(ticket.startDate.toString())),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HORA', style: TextStyle(color: Colors.black45)),
                      Text(
                        '${formatUtcToHours(ticket.startDate.toString())} - ${formatUtcToHours(ticket.endDate.toString())}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'N° TICKET',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(ticket.idTicketGenerator.toString()),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Container(
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Color(0XffDBD6EA),
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                'Total \$${ticket.amount.toInt()}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
