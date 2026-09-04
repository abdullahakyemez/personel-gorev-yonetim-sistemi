import '../models/task_category.dart';

extension TaskCategoryExtension on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.precaution:
        return 'Tedbir Görevi';
      case TaskCategory.exam:
        return 'Sınav Görevi';
      case TaskCategory.match:
        return 'Maç Görevi';
      case TaskCategory.outOfTown:
        return 'İl Dışı Görevi';
      case TaskCategory.checkpoint:
        return 'Uygulama Noktası';
    }
  }
}
