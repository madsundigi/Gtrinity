import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/duties/bloc/duties_bloc.dart';
import 'package:chef_king/presentation/duties/bloc/duties_event.dart';
import 'package:chef_king/presentation/duties/bloc/duties_state.dart';
import 'widget/duties_body.dart';

class DutiesScreen extends CKBaseScreen<DutiesBloc, DutiesState> {
  const DutiesScreen({super.key});

  @override
  void onInit(BuildContext context) {
    context.read<DutiesBloc>().add(const LoadDuties());
  }

  @override
  bool isLoading(DutiesState state) => state.isLoading;

  @override
  Widget buildBody(BuildContext context, DutiesState state) {
    return DutiesBody(state: state);
  }
}
