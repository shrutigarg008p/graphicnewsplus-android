import 'package:flutter/widgets.dart';
import 'package:focus_detector/focus_detector.dart';

/// Created by Amit Rawat on 12/9/2021.
class LifeCycleManager extends StatefulWidget {
  final Widget? child;

  Function? audioPlayerTxt;
  Function? ttspeach;
  Function? refresh;

  LifeCycleManager(
      {Key? key, this.child, this.audioPlayerTxt, this.ttspeach, this.refresh})
      : super(key: key);

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    callingMethod();
    super.dispose();
  }

  callingMethod() {
    if (widget.audioPlayerTxt != null) {
      widget.audioPlayerTxt!();
    }
    if (widget.ttspeach != null) {
      widget.ttspeach!();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        callingMethod();
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () {
        print(
          'Focus Lost.'
          '\nTriggered when either [onVisibilityLost] or [onForegroundLost] '
          'is called.'
          '\nEquivalent to onPause() on Android or viewDidDisappear() on iOS.',
        );
      },
      onFocusGained: () {
        if (widget.refresh != null) {
          widget.refresh!();
        }
        print(
          'Focus Gained.'
          '\nTriggered when either [onVisibilityGained] or [onForegroundGained] '
          'is called.'
          '\nEquivalent to onResume() on Android or viewDidAppear() on iOS.',
        );
      },
      onVisibilityLost: () {
        callingMethod();
        print(
          'Visibility Lost.'
          '\nIt means the widget is no longer visible within your app.',
        );
      },
      onVisibilityGained: () {
        print(
          'Visibility Gained.'
          '\nIt means the widget is now visible within your app.',
        );
      },
      onForegroundLost: () {
        print(
          'Foreground Lost.'
          '\nIt means, for example, that the user sent your app to the background by opening '
          'another app or turned off the device\'s screen while your '
          'widget was visible.',
        );
      },
      onForegroundGained: () {
        print(
          'Foreground Gained.'
          '\nIt means, for example, that the user switched back to your app or turned the '
          'device\'s screen back on while your widget was visible.',
        );
      },
      child: Container(
        child: widget.child,
      ),
    );
  }
}
