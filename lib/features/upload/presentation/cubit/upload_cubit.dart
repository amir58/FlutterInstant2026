import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/dio_factory.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/core/api/safe_api_call.dart';
import 'package:navigations/features/products/data/models/product_model.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadInitialState());

  Future<void> upload(File image, int productId) async {
    emit(UploadLoadingState(0));

    final result = await _uploadProductImage(
      productId: productId,
      image: image,
      onProgress: (sent, total) {
        if (total <= 0) return; // السيرفر ممكن ميبعتش الحجم
        if (isClosed) return; // ⚠️ الشاشة اتقفلت وسط الرفع
        emit(UploadLoadingState((sent / total))); // 0.0 → 1.0
      },
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(UploadSuccessState());
      case ApiFailure(:final failure):
        emit(UploadFailureState(failure.message));
    }
  }

  Future<ApiResult<ProductModel>> _uploadProductImage({
    required int productId,
    required File image,
    void Function(int sent, int total)? onProgress,
  }) {
    return safeApiCall(() async {
      final fileName = image.path.split('/').last;

      final formData = FormData.fromMap({
        'productId': productId,
        'title': 'صورة المنتج',
        'image': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final response = await DioFactory.getDio().post(
        EndPoints.addProduct,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(
            minutes: 5,
          ), // الرفع محتاج مهلة أطول
        ),
        onSendProgress: onProgress, // ← نسبة التقدّم
      );

      return ProductModel.fromJson(response.data);
    });
  }
}
