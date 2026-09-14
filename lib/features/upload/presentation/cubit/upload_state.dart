part of 'upload_cubit.dart';

sealed class UploadState {}

final class UploadInitialState extends UploadState {}

final class UploadLoadingState extends UploadState {
  final double progress;

  UploadLoadingState(this.progress);
}

final class UploadSuccessState extends UploadState {}

final class UploadFailureState extends UploadState {
  final String message;

  UploadFailureState(this.message);
}
