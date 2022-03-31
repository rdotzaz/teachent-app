class NameConsts {
  static const appName = 'Teachent';
  static const welcomeText = 'Welcome in Teachent';
}

class DatabaseObjectName {
  static const users = 'users';
  static const teachers = 'teachers';
  static const students = 'students';
  static const lessonDates = 'lessonDates';
  static const requests = 'requests';
  static const lessons = 'lessons';
  static const reports = 'reports';
  static const reviews = 'reviews';
  static const topics = 'topics';
  static const tools = 'tools';
  static const places = 'places';
  static const levels = 'levels';
}

class DatabaseConsts {
  static const emulatorPort = 9000;
  static const androidFirebaseHost = '10.0.2.2';
  static const webFirebaseHost = 'localhost';

  static const emptyKey = '';
  static const emptyField = '';
}

class HiveConsts {
  static const hiveConfigBox = 'config';
  static const userId = 'userId';
  static const userMode = 'mode';
  static const themeMode = 'themeMode';
}

class LoginPageConsts {
  static const login = 'Login';
  static const logIn = 'Log in';
  static const password = 'Password';
  static const signUpQuery = 'Don\'t have an account?';
  static const signUp = 'Sign up';

  static const loginError = 'Login cannot be empty';
  static const passwordError = 'Password cannot be empty';
  static const loginNotFound = 'Login has not been found';
  static const validationFailed = 'Validation failed';

}

class ProfilePageConsts {
  static const selectProfile = 'Select account profile';
  static const teacher = 'Teacher';
  static const student = 'Student';
}

class TeacherCreationPageConsts {
  static const back = 'Back';
  static const next = 'Next';
  static const done = 'Done';
  static const name = 'Name';
  static const description = 'Description';
  static const descriptionLabel = 'Few words about you...';
  static const namePageNumber = 0;
  static const topicPageNumber = 1;
  static const placePageNumber = 2;
  static const addOtherTopic = 'Add other topic';
  static const add = 'Add';
  static const inPlace = 'In place';
  static const remote = 'Remote';
  static const place = 'place';
  static const tool = 'tool';
  static String addOther(String name) => 'Add other $name';

  static const headers = [
    'What\'s your name?',
    'In what topics do you feel well?',
    'How\'d you like to work?'
  ];
  static const nameEmptyError = 'Name cannot be empty';
  static const nameLengthError = 'Name length must be greater than 4';
  static const nameLengthTreshold = 5;

  static const noTopicSelected = 'No topic selected';
  static const toolOrPlaceError = 'Select at least\none tool or place';
  static const topicExists = 'Such topic is already exists';
  static const placeExists = 'Such place is already exists';
  static const toolExists = 'Such tool is already exists';
}

class WorkModeConsts {
  static const none = 0;
  static const place = 1;
  static const placeWithAdding = 3;
  static const remote = 2;
  static const remoteWithAdding = 4;
}

class StudentCreationPageConsts {
  static const back = 'Back';
  static const next = 'Next';
  static const done = 'Done';
  static const name = 'Name';
  static const namePageNumber = 0;
  static const levelPageNumber = 1;

  static const nameEmptyError = 'Name cannot be empty';
  static const nameLengthError = 'Name length must be greater than 4';
  static const nameLengthTreshold = 5;
  static const noLevelError = 'No education level selected';

  static const headers = ['What\'s your name?', 'Choose your education level'];

}

class AccountCreationPageConsts {
  static const header = 'Almost done...';
}

class StudentConsts {
  static const levelNotSpecified = 'Not specified';
}

class TeacherConsts {
  static const emptyRate = -1;
}
