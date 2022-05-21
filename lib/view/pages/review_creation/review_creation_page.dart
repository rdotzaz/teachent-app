import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/review_creation/review_creation_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/error_message_widget.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

class ReviewCreationPage extends StatefulWidget {
  final KeyId teacherId;
  final KeyId studentId;
  const ReviewCreationPage(
      {Key? key, required this.teacherId, required this.studentId})
      : super(key: key);

  @override
  State<ReviewCreationPage> createState() => _ReviewCreationPageState();
}

class _ReviewCreationPageState extends State<ReviewCreationPage> {
  late ReviewCreationPageController _reviewCreationPageController;

  @override
  void initState() {
    super.initState();
    _reviewCreationPageController = ReviewCreationPageController(
        refresh, widget.teacherId, widget.studentId);
  }

  @override
  void dispose() {
    _reviewCreationPageController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add review')),
        body: FutureBuilder(builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingBody();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return _body();
          }
          return ErrorMessageWidget(
              text: snapshot.error.toString(),
              backgroundColor: Colors.white,
              color: Colors.red);
        }));
  }

  Widget _loadingBody() {
    return Column(
      children: const [
        CardLoadingWidget(title: 'Teacher', backgroundColor: Colors.white)
      ],
    );
  }

  Widget _body() {
    return Form(
        key: _reviewCreationPageController.formKey,
        child: Column(
          children: [
            SingleCardWidget(
              title: 'Teacher',
              bodyWidget:
                  Label(text: _reviewCreationPageController.teacherName),
              titleColor: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (title) =>
                      _reviewCreationPageController.validateTitle(title),
                  onChanged: (title) =>
                      _reviewCreationPageController.setTitle(title),
                  decoration: blackInputDecorator('Review title')),
            ),
            SingleCardWidget(
                title: 'Your rate',
                bodyWidget: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () =>
                            _reviewCreationPageController.setRateNumber(index),
                        child: Icon(Icons.star,
                            size: 60,
                            color:
                                index + 1 < _reviewCreationPageController.rate
                                    ? Colors.yellow
                                    : Colors.white),
                      );
                    }))),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                keyboardType: TextInputType.text,
                onChanged: (description) =>
                    _reviewCreationPageController.setDescription(description),
                decoration: blackInputDecorator('Something about teacher'),
              ),
            ),
            CustomButton(
                text: 'Save',
                fontSize: 18,
                onPressed: () =>
                    _reviewCreationPageController.saveReview(context),
                buttonColor: Colors.blue)
          ],
        ));
  }
}
