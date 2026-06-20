import 'package:chef_king/core/imports/app_imports.dart';

abstract class CKBaseScreen<B extends StateStreamableSource<S>, S> extends StatefulWidget {
  const CKBaseScreen({super.key});

  @override
  State<CKBaseScreen<B, S>> createState() => _CKBaseScreenState<B, S>();

  Widget buildBody(BuildContext context, S state);

  void listener(BuildContext context, S state) {}

  void onInit(BuildContext context) {}

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  Widget? buildFloatingActionButton(BuildContext context) => null;

  Widget? buildBottomNavigationBar(BuildContext context) => null;

  Widget? buildDrawer(BuildContext context) => null;

  Color? get backgroundColor => null;

  bool get extendBodyBehindAppBar => false;

  bool isLoading(S state) => false;

  SystemUiOverlayStyle getSystemUiOverlayStyle(BuildContext context) => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Makes SIM, battery, time icons white on Android
        statusBarBrightness: Brightness.dark,      // Makes SIM, battery, time icons white on iOS
      );

  bool listenWhen(S previous, S current) => true;

  bool buildWhen(S previous, S current) => true;
}

class _CKBaseScreenState<B extends StateStreamableSource<S>, S> extends State<CKBaseScreen<B, S>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: widget.getSystemUiOverlayStyle(context),
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: widget.buildAppBar(context),
        drawer: widget.buildDrawer(context),
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        body: BlocConsumer<B, S>(
          listener: widget.listener,
          builder: (context, state) {
            return CKOverlayLoader(
              isLoading: widget.isLoading(state),
              child: widget.buildBody(context, state),
            );
          },
          listenWhen: widget.listenWhen,
          buildWhen: widget.buildWhen,
        ),
        floatingActionButton: widget.buildFloatingActionButton(context),
        bottomNavigationBar: widget.buildBottomNavigationBar(context),
      ),
    );
  }
}
