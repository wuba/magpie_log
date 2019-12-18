import 'package:json_annotation/json_annotation.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';

part 'count_state.g.dart';

///State中所有属性都应该是只读的

@JsonSerializable()
class CountState extends LogState {
  final int count;
  final int param1;
  final int param2;

  CountState(this.count, {this.param1, this.param2});

  CountState.initState({this.param1, this.param2}) : count = 0;

  Map<String, dynamic> toJson() => _$CountStateToJson(this);
}

///定义操作该State的全部Action
///这里只有增加count一个动作
enum LogAction { increment }

///reducer会根据传进来的action生成新的CountState
CountState reducer(CountState state, action) {
  //匹配Action
  if (action == LogAction.increment) {
    return CountState(state.count + 1);
  }
  return state;
}
