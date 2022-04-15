import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/items_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/person_type_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

import 'teacher_search_bar.dart';
import 'user_card.dart';

class TeacherSearchPage extends StatelessWidget {
  TeacherSearchPage({Key? key}) : super(key: key);

  final controller = TeacherSearchPageController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ItemsBloc(controller)),
          BlocProvider(create: (_) => PersonTypeBloc(controller))
        ],
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Search', style: TextStyle(color: Colors.black)),
              elevation: 0,
              backgroundColor: Colors.transparent),
            body: Column(
              children: [
                TeacherSearchBarWidget(controller: controller),
                filtersWidget(),
                foundListWidget()
              ],
            )));
  }

  Widget filtersWidget() {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Filters',
                style: TextStyle(fontSize: 18, color: Colors.black))),
        BlocBuilder<PersonTypeBloc, PersonType>(builder: (context, personType) {
          final isAllMarked = personType == PersonType.all;
          final isTeachersMarked = personType == PersonType.teachers;
          final isStudentsMarked = personType == PersonType.students;
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ActionChip(
                  padding: const EdgeInsets.all(12.0),
                  label: Text('All',
                      style: TextStyle(
                          fontSize: 14,
                          color: isAllMarked ? Colors.white : Colors.black)),
                  backgroundColor: isAllMarked ? Colors.blue : Colors.grey,
                  elevation: 2,
                  onPressed: () {
                    context.read<PersonTypeBloc>().add(ToggleAllEvent());
                  },
                ),
                const SizedBox(width: 15),
                ActionChip(
                  padding: const EdgeInsets.all(12.0),
                  label: Text('Teachers',
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              isTeachersMarked ? Colors.white : Colors.black)),
                  backgroundColor: isTeachersMarked ? Colors.blue : Colors.grey,
                  elevation: 2,
                  onPressed: () {
                    context
                        .read<PersonTypeBloc>()
                        .add(ToggleTeachersOnlyEvent());
                  },
                ),
                const SizedBox(width: 15),
                ActionChip(
                  padding: const EdgeInsets.all(12.0),
                  label: Text('Students',
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              isStudentsMarked ? Colors.white : Colors.black)),
                  backgroundColor: isStudentsMarked ? Colors.blue : Colors.grey,
                  elevation: 2,
                  onPressed: () {
                    context
                        .read<PersonTypeBloc>()
                        .add(ToggleStudentsOnlyEvent());
                  },
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  Widget foundListWidget() {
    return BlocBuilder<ItemsBloc, String>(builder: (context, phrase) {
      if (phrase.isEmpty) {
        return const Center(child: Text('No items found'));
      }
      return BlocBuilder<PersonTypeBloc, PersonType>(
          builder: (context, personType) {
        final isTeachersMarked = personType != PersonType.students;
        final isStudentsMarked = personType != PersonType.teachers;
        return SingleChildScrollView(
          child: Column(
            children: [
              if (isTeachersMarked)
                const Padding(
                    padding: EdgeInsets.all(8.0), child: Text('Teachers')),
              if (isTeachersMarked)
                ListView.builder(
                    itemCount: controller.teachers.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return TeacherCardWidget(
                          teacher: controller.teachers[index],
                          onPressed: () {});
                    }),
              if (isStudentsMarked)
                const Padding(
                    padding: EdgeInsets.all(8.0), child: Text('Students')),
              if (isStudentsMarked)
                ListView.builder(
                    itemCount: controller.students.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return StudentCardWidget(
                        student: controller.students[index],
                        onPressed: () {},
                      );
                    }),
            ],
          ),
        );
      });
    });
  }
}
