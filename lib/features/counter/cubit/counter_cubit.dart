import 'package:flutter_bloc/flutter_bloc.dart';

// BlocWidgets 
// 1 - BlocProvider ( اجباري )
// 2 - BlocBuilder ( UI )
// 3 - BlocListener ( Navigations )
// 4 - BlocConsumer ( BlocBuilder + BlocListener )

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
  }

  void decrement() {
    emit(state - 1);
  }
}
