import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/interfaces.dart';

@immutable
class AdminSetup {
  final GameLevel level;

  AdminSetup({@required this.level });

  AdminSetup copyWith({
  GameLevel level
  }) {
   return AdminSetup(level: level ?? this.level);
  }
}

class HotMods implements IDisposable {
  final Subject<AdminSetup> _adminSetup$ = PublishSubject<AdminSetup>();
  AdminSetup _adminSetup;

  HotMods._(this._adminSetup) {
    RawKeyboard.instance.addListener(_onKeydown);
  }

  Stream<AdminSetup> get adminSetup$ { return  _adminSetup$.asBroadcastStream(); }

  void _onKeydown(RawKeyEvent value) {
  }

  void update(AdminSetup setup) {
    this._adminSetup = setup;
    this._adminSetup$.add(setup);
  }

  static HotMods _instance;
  static HotMods createInstance(AdminSetup setup) => _instance = HotMods._(setup);
  static HotMods get instance => _instance;

  @override
  void dispose() {
    _adminSetup$?.close();
  }
}

