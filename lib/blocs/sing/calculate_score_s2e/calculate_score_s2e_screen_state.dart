abstract class CalculateScoreS2EScreenState {
  const CalculateScoreS2EScreenState();
}

class CalculateScoreS2EScreenInitialState extends CalculateScoreS2EScreenState {
}

class CalculateScoreS2EDoneState extends CalculateScoreS2EScreenState {
  final bool isSuccess;
  final String error;

  const CalculateScoreS2EDoneState({required this.isSuccess, this.error = ''});
}
