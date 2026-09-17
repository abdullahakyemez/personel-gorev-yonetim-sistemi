class LanHealthResult {
  final bool isSuccess;
  final int pingMs;
  final String? appName;
  final int? schemaVersion;
  final String? errorMessage;
  final DateTime? serverTime;

  const LanHealthResult({
    required this.isSuccess,
    required this.pingMs,
    this.appName,
    this.schemaVersion,
    this.errorMessage,
    this.serverTime,
  });

  factory LanHealthResult.success({
    required int pingMs,
    required String appName,
    required int schemaVersion,
    DateTime? serverTime,
  }) {
    return LanHealthResult(
      isSuccess: true,
      pingMs: pingMs,
      appName: appName,
      schemaVersion: schemaVersion,
      serverTime: serverTime ?? DateTime.now(),
    );
  }

  factory LanHealthResult.failure({
    required int pingMs,
    required String errorMessage,
  }) {
    return LanHealthResult(
      isSuccess: false,
      pingMs: pingMs,
      errorMessage: errorMessage,
    );
  }
}
