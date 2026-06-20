import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/duties/bloc/duties_bloc.dart';
import 'package:chef_king/presentation/duties/bloc/duties_event.dart';
import 'package:chef_king/presentation/duties/bloc/duties_state.dart';
import 'duty_card.dart';

class DutiesBody extends StatelessWidget {
  final DutiesState state;

  const DutiesBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.duties.isEmpty && !state.isLoading) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<DutiesBloc>().add(const LoadDuties());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: CKText(
              "No duties assigned yet.",
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.subTitleTextColor,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DutiesBloc>().add(const LoadDuties());
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!state.hasReachedMax &&
                    !state.isMoreLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  context.read<DutiesBloc>().add(LoadMoreDuties());
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.duties.length + (state.isMoreLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.duties.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return DutyCard(duty: state.duties[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        16,
      ),
      alignment: Alignment.centerLeft,
      child: CKText(
        "Duty Schedules",
        style: context.textTheme.titleMedium?.copyWith(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
