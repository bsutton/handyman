import 'package:flutter/material.dart';

import '../../../../dao/entities/team.dart';

class SelectedTeam extends ChangeNotifier {

  factory SelectedTeam() => _self;

  SelectedTeam._internal();
  static final SelectedTeam _self = SelectedTeam._internal();
  Team? _team;

  /// The selected team is set to the default
  /// Primary team during the login process.
  Team? get team => _team;

  set team(Team? team) {
    _team = team;
    notifyListeners();
  }

  Future<String> get teamName async => _team?.name ?? '';

  void notify() {
    notifyListeners();
  }
}
