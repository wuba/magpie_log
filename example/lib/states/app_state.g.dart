// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountState _$CountStateFromJson(Map<String, dynamic> json) {
  return CountState(
    json['count'] as int,
    param1: json['param1'] as String,
    param2: json['param2'] as int,
  );
}

Map<String, dynamic> _$CountStateToJson(CountState instance) =>
    <String, dynamic>{
      'count': instance.count,
      'param1': instance.param1,
      'param2': instance.param2,
    };

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
    countState: json['countState'] == null
        ? null
        : CountState.fromJson(json['countState'] as Map<String, dynamic>),
    listState: (json['listState'] as List)
        ?.map((e) =>
            e == null ? null : ListItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    otherState: json['otherState'] == null
        ? null
        : OtherState.fromJson(json['otherState'] as Map<String, dynamic>),
    param1: json['param1'] as String,
    param2: json['param2'] as int,
  );
}
Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
  'countState': instance.countState != null
      ? instance.countState.toJson()
      : instance.countState,
  'otherState': instance.otherState != null
      ? instance.otherState.toJson()
      : instance.otherState,
  'listState': instance.listState != null
      ? encodeListToJson(instance.listState)
      : instance.listState,
  'param1': instance.param1,
  'param2': instance.param2,
};

List encodeListToJson(List list) {
  List jsonList = List();
  list.map((item) => jsonList.add(item.toJson())).toList();
  return jsonList;
}

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
    title: json['title'] as String,
    content: json['content'] as String,
    isChecked: json['isChecked'] as bool,
  );
}

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'isChecked': instance.isChecked,
    };

OtherState _$OtherStateFromJson(Map<String, dynamic> json) {
  return OtherState(
    json['param1'] as String,
    json['param2'] as int,
  );
}

Map<String, dynamic> _$OtherStateToJson(OtherState instance) =>
    <String, dynamic>{
      'param1': instance.param1,
      'param2': instance.param2,
    };
