import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigations/features/upload/presentation/cubit/upload_cubit.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  createState() => _UploadPage();
}

class _UploadPage extends State<UploadScreen> {
  File? file;

  @override
  Widget build(BuildContext context) {
    debugPrint(context.locale.languageCode);

    return Scaffold(
      appBar: AppBar(title: Text('upload_image'.tr())),
      body: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            if (file != null)
              Image.file(
                file!,
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Icon(Icons.image_rounded),

            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();

                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image == null) return;

                file = File(image.path);

                setState(() {});
              },
              child: Text('select_image'.tr()),
            ),

            ElevatedButton(
              onPressed: () {
                if (file == null) {
                  // toast
                  return;
                }

                context.read<UploadCubit>().upload(file!, 1);
              },
              child: Text('upload'.tr()),
            ),

            BlocBuilder<UploadCubit, UploadState>(
              builder: (context, state) => switch (state) {
                UploadLoadingState(:final progress) => Column(
                  children: [
                    LinearProgressIndicator(value: progress),
                    CircularProgressIndicator(value: progress),

                    Text('${(progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
                UploadSuccessState() => const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                UploadFailureState(:final message) => Text(message),
                _ => const SizedBox.shrink(),
              },
            ),

            Switch.adaptive(
              value: context.locale.languageCode == 'ar',
              onChanged: (value) {
                final languageCode =
                    context.locale.languageCode == 'ar' ? 'en' : 'ar';

                context.setLocale(Locale(languageCode));
              },
            ),
          ],
        ),
      ),
    );
  }
}
