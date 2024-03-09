import 'package:json_annotation/json_annotation.dart';
import '../types/er.dart';
import '../types/guid.dart';
import 'entity.dart';
import 'ivr_option.dart';

part 'ivr.g.dart';

@JsonSerializable()
class IVR extends Entity<IVR> {
  int get optionsCount => ivrOptions.length;

  @ERIVROptionConverter()
  List<ER<IVROption>> ivrOptions = [];

  IVR();

  /// Finds the highest ordinal no. and returns
  /// that no. + 1.
  /// Ordinals start from 0.
  Future<int> nextOrdinal() async {
    var maxOrdinal = -1;
    for (var option in ivrOptions) {
      var ordinal = await option.call((option) => option.ordinal);

      if (ordinal > maxOrdinal) {
        maxOrdinal = ordinal;
      }
    }
    return maxOrdinal + 1;
  }

  void deleteOption(IVROption toDelete) {
    ivrOptions.remove(toDelete);

    reorder();
  }

  /// Use this method to update the ordinals after a delete
  /// operation to keep the ordinals contiguous;
  void reorder() async {
    var nextOrdinal = 0;
    for (var option in ivrOptions) {
      await option.call((option) => option.ordinal = nextOrdinal++);
    }
    _validate();
  }

  /// moves this ordinal up in the list
  void moveUp(IVROption option) async {
    await ER.resolveList(ivrOptions);

    var swapWith = option.ordinal - 1;
    assert(swapWith >= 0, "Can't move ordinal up as its already the first one");

    await ivrOptions[swapWith].call((option) => option.ordinal++);
    option.ordinal--;

    ivrOptions.sort((lhs, rhs) => lhs.entity.ordinal - rhs.entity.ordinal);
    _validate();
  }

  // /// moves this ordinal up in the list
  // vo

  /// moves this ordinal up in the list
  void moveDown(IVROption option) async {
    var swapWith = option.ordinal + 1;
    assert(swapWith < ivrOptions.length,
        "Can't move ordinal down as its already the last one");

    await ER.resolveList(ivrOptions);

    ivrOptions[swapWith].entity.ordinal--;
    option.ordinal++;
    ivrOptions.sort((lhs, rhs) => lhs.entity.ordinal - rhs.entity.ordinal);
    _validate();
  }

  void _validate() {
    var nextOrdinal = 0;
    for (var option in ivrOptions) {
      assert(option.entity.ordinal == nextOrdinal,
          'IVROptions are no longer ordered: problem at $option');
      nextOrdinal++;
    }
  }

  factory IVR.fromJson(Map<String, dynamic> json) => _$IVRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IVRToJson(this);
}
