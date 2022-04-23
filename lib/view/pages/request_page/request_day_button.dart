import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

class RequestDayButton extends StatelessWidget {
  const RequestDayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        text: 'Choose another day',
        fontSize: 14,
        onPressed: () {
          context.read<RequestDayBloc>().add(ToggleRequestDayField());
        });
  }
}
