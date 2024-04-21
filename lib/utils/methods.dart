import '../model/Exercise.dart';
import '../model/ExerciseGroup.dart';
import '../model/ExerciseModel.dart';

String? getIdFromName(String? selectedGroup, List<ExerciseGroup> exerciseGroups) {
  for (final e in exerciseGroups) {
    if (e.name == selectedGroup) {
      return e.id;
    }
  }
  return null;
}


String? exerciseNameFromId(String? selectedExercise, List<Exercise> exercises) {
  for (final e in exercises) {
    if (e.id == selectedExercise) {
      return e.name;
    }
  }
  return null;
}

String? exerciseNameFromList(String? selectedExercise, List<ExerciseModel> exercises) {
  for (final e in exercises) {
    if (e.name == selectedExercise) {
      return e.name;
    }
  }
  return null;
}