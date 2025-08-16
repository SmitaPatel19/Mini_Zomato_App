import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/status/delivery_status_bloc.dart';
import '../blocs/status/delivery_status_event.dart';


class OrderActionToggle extends StatefulWidget {
  final String orderId;
  const OrderActionToggle({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderActionToggleState createState() => _OrderActionToggleState();
}

class _OrderActionToggleState extends State<OrderActionToggle> {
  List<bool> _isSelected = [false, false]; // [Picked, Delivered]

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(8),
      selectedColor: Colors.white,
      fillColor: Colors.blue,
      isSelected: _isSelected,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _isSelected.length; i++) {
            _isSelected[i] = (i == index); // only one active
          }
        });

        if (index == 0) {
          context.read<OrderActionBloc>().add(AcceptOrder(widget.orderId));
        } else {
          context.read<OrderActionBloc>().add(RejectOrder(widget.orderId));
        }
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text("Picked"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text("Delivered"),
        ),
      ],
    );
  }
}
