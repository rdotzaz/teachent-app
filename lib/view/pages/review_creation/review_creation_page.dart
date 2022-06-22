import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/review_creation/review_creation_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/pages/review_creation/review_rate_widget.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/error_message_widget.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

/// Page where student can create new review about teacher
/// Input:
/// [teacherId] - teacher id
/// [studentId] - student id
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
    _reviewCreationPageController =
        ReviewCreationPageController(widget.teacherId, widget.studentId);
  }

  @override
  void dispose() {
    _reviewCreationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add review')),
        body: FutureBuilder(
            future: _reviewCreationPageController.init(),
            builder: (context, snapshot) {
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
    return SingleChildScrollView(
      child: Form(
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
              ReviewRateWidget(controller: _reviewCreationPageController),
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
          )),
    );
  }
}
