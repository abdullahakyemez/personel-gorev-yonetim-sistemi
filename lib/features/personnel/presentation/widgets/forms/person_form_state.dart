class PersonFormState {
  final bool isLoading;

  final bool isSaving;

  final String? error;

  const PersonFormState({
    this.isLoading = false,

    this.isSaving = false,

    this.error,
  });

  PersonFormState copyWith({bool? isLoading, bool? isSaving, String? error}) {
    return PersonFormState(
      isLoading: isLoading ?? this.isLoading,

      isSaving: isSaving ?? this.isSaving,

      error: error,
    );
  }
}
