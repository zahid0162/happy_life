import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';

class LoaderCubit extends Cubit<bool> {
  LoaderCubit() : super(false);

  void showLoader() => emit(true);
  void hideLoader() => emit(false);
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderCubit, bool>(
      builder: (context, isLoading) {
        if (!isLoading) return const SizedBox.shrink();

        return Stack(
          alignment:  Alignment.center,
          children: [
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.darkText),
                  strokeWidth: 2,
                  color: ColorConstants.darkText,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}