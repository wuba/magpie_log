import 'package:json_annotation/json_annotation.dart';
import 'package:magpie_log/magpie_log.dart';

part 'app_state.g.dart';

///State中所有属性都应该是只读的

@JsonSerializable()
class CountState {
  final int count;
  final String param1;
  final int param2;
  int param3;

  CountState(this.count, {this.param1, this.param2});

  CountState.initState({this.param1, this.param2}) : count = 0;

  Map<String, dynamic> toJson() => _$CountStateToJson(this);

  factory CountState.fromJson(Map<String, dynamic> json) =>
      _$CountStateFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class AppState extends LogState {
  final CountState countState;
  final List<ListItem> listState;
  final OtherState otherState;
  final String param1;
  final int param2;

  AppState(
      {this.countState,
      this.listState,
      this.otherState,
      this.param1,
      this.param2});

  AppState.initState({this.param1, this.param2, this.otherState})
      : countState = CountState.initState(),
        listState = initListState();

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}

List<ListItem> initListState() {
  List<ListItem> list = [];
  for (int i = 0; i < 20; i++) {
    list.add(ListItem(
        title: "Title：" + i.toString(), content: "Content：" + i.toString()));
  }
  return list;
}

@JsonSerializable()
class ListItem {
  final String title;
  final String content;
  final bool isChecked;

  ListItem({this.title, this.content, this.isChecked = false});

  Map<String, dynamic> toJson() => _$ListItemToJson(this);

  factory ListItem.fromJson(Map<String, dynamic> json) =>
      _$ListItemFromJson(json);
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
const String actionListClick = "listClick";

///reducer会根据传进来的action生成新的CountState
AppState reducer(AppState state, action) {
  //匹配Action

  if (action is LogAction && action.actionName == actionAddCount) {
    return AppState(
        countState: CountState(state.countState.count + 1),
        listState: state.listState);
  } else if (action is LogAction && action.actionName == actionListClick) {
    ListItem listItem = state.listState[action.index];

    state.listState[action.index] = ListItem(
        title: listItem.title,
        content: listItem.content,
        isChecked: !listItem.isChecked);
  }
  return state;
}
