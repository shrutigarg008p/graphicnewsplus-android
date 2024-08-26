enum ObserverState { INIT, LIST_CHANGED, QUESTIONS }

abstract class CommonStateListner {
  void onStateChanged(ObserverState state);
}

//Singleton reusable class
class StateProvider {
  List<CommonStateListner>? observers;

  static final StateProvider _instance = new StateProvider.internal();
  factory StateProvider() => _instance;
  bool stateChanged = false;

  StateProvider.internal() {
    observers = <CommonStateListner>[];

    initState();
  }

  void initState() async {
    print("state listener init state");
    notify(
      ObserverState.INIT,
    );
  }

  void subscribe(CommonStateListner listener) {
    print("state listener subscribe");
    observers!.add(listener);
  }

  void notify(dynamic state) {
    print("state listener notify");
    observers!.forEach((CommonStateListner obj) => obj.onStateChanged(state));
  }

  void dispose(CommonStateListner thisObserver) {
    print("state listener dispose");
    for (var obj in observers!) {
      if (obj == thisObserver) {
        observers!.remove(obj);
      }
    }
  }
}
