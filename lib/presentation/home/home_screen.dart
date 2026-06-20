import 'package:chef_king/core/imports/app_imports.dart';
import 'widget/home_body.dart';

class HomeScreen extends CKBaseScreen<HomeBloc, HomeState> {
  const HomeScreen({super.key});

  @override
  void onInit(BuildContext context) {
    context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  bool isLoading(HomeState state) => state.isLoading || state.isPunching;

  @override
  bool listenWhen(HomeState previous, HomeState current) =>
      (current.attendanceMessage != null && previous.attendanceMessage != current.attendanceMessage) ||
      (current.errorMessage != null && previous.errorMessage != current.errorMessage);

  @override
  void listener(BuildContext context, HomeState state) {
    if (state.attendanceMessage != null && state.attendanceMessage!.isNotEmpty) {
      CKSnackBar.showSuccess(context, state.attendanceMessage!);
    } else if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      CKSnackBar.showError(context, state.errorMessage!);
    }
  }

  @override
  Widget buildBody(BuildContext context, HomeState state) {
    return HomeBody(state: state);
  }
}
