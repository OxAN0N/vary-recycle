class SignUpwithEmailAndPasswordFailure {
  final String message;

  const SignUpwithEmailAndPasswordFailure(
      [this.message = "An Unknown error occurred."]);

  factory SignUpwithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignUpwithEmailAndPasswordFailure(
            'Please enter a stronger password.');
      case 'invalid-email':
        return const SignUpwithEmailAndPasswordFailure(
            'Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignUpwithEmailAndPasswordFailure(
            'An account already exists for that email.');
      case 'operation-not-allowed':
        return const SignUpwithEmailAndPasswordFailure(
            'Operation is not allowed. Please contack support.');
      case 'user-disabled':
        return const SignUpwithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support for help.');
      default:
        return const SignUpwithEmailAndPasswordFailure();
    }
  }
}
