class PersonnelImportResult {
  final int insertedCount;
  final int updatedCount;
  final int skippedCount;

  const PersonnelImportResult({
    required this.insertedCount,
    required this.updatedCount,
    required this.skippedCount,
  });

  int get totalProcessed => insertedCount + updatedCount + skippedCount;
}
