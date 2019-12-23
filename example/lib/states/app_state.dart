import 'package:json_annotation/json_annotation.dart';
import 'package:magpie_log/magpie_log.dart';

part 'app_state.g.dart';

///State中所有属性都应该是只读的

@JsonSerializable()
class CountState {
  final int count;
  final String param1;
  final int param2;

  CountState(this.count, {this.param1, this.param2});

  CountState.initState({this.param1, this.param2}) : count = 0;

  Map<String, dynamic> toJson() => _$CountStateToJson(this);

  factory CountState.fromJson(Map<String, dynamic> json) =>
      _$CountStateFromJson(json);
}

@JsonSerializable()
class AppState extends LogState {
  final CountState countState;
  final OtherState otherState;
  final String param1;
  final int param2;

  AppState({this.countState, this.otherState, this.param1, this.param2});

  AppState.initState({this.param1, this.param2, this.otherState})
      : countState = CountState.initState();

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}

@JsonSerializable()
class OtherState {
  final String param1;
  final int param2;

  OtherState(this.param1, this.param2);

  Map<String, dynamic> toJson() => _$OtherStateToJson(this);

  factory OtherState.fromJson(Map<String, dynamic> json) =>
      _$OtherStateFromJson(json);
}

const String actionAddCount = "addCount";

///reducer会根据传进来的action生成新的CountState
AppState reducer(AppState state, action) {
  //匹配Action

  if (action is LogAction && action.actionName == actionAddCount) {
    return AppState(countState: CountState(state.countState.count + 1));
  }
  return state;
}
