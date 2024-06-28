import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

import '../../dao/dao_check_list_item_type.dart';
import '../../dao/dao_checklist_item.dart';
import '../../dao/join_adaptors/dao_join_adaptor.dart';
import '../../entity/check_list.dart';
import '../../entity/check_list_item.dart';
import '../../entity/check_list_item_type.dart';
import '../../entity/entity.dart';
import '../../util/fixed_ex.dart';
import '../../util/money_ex.dart';
import '../../util/platform_ex.dart';
import '../../widgets/hmb_droplist.dart';
import '../../widgets/hmb_text_field.dart';
import '../base_nested/nested_edit_screen.dart';

class CheckListItemEditScreen<P extends Entity<P>> extends StatefulWidget {
  const CheckListItemEditScreen(
      {required this.parent,
      required this.daoJoin,
      super.key,
      this.checkListItem});
  final DaoJoinAdaptor daoJoin;
  final P parent;
  final CheckListItem? checkListItem;

  @override
  // ignore: library_private_types_in_public_api
  _CheckListItemEditScreenState createState() =>
      _CheckListItemEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<CheckListItem?>('checkListItem', checkListItem));
  }
}

class _CheckListItemEditScreenState extends State<CheckListItemEditScreen>
    implements NestedEntityState<CheckListItem> {
  late TextEditingController _descriptionController;
  late TextEditingController _costController;
  late TextEditingController _quantityController;
  late TextEditingController _effortInHoursController;
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.checkListItem?.description);
    _costController =
        TextEditingController(text: widget.checkListItem?.unitCost.toString());
    _quantityController =
        TextEditingController(text: widget.checkListItem?.quantity.toString());

    _effortInHoursController = TextEditingController(
        text: widget.checkListItem?.effortInHours.toString());

    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    _quantityController.dispose();
    _effortInHoursController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NestedEntityEditScreen<CheckListItem, CheckList>(
        entity: widget.checkListItem,
        entityName: 'Check List Item',
        dao: DaoCheckListItem(),
        onInsert: (checkListItem) async =>
            widget.daoJoin.insertForParent(checkListItem!, widget.parent),
        entityState: this,
        editor: (checklistItem) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HMBTextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              autofocus: isNotMobile,
              labelText: 'Description',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the description';
                }
                return null;
              },
            ),
            _chooseItemType(checklistItem),
            HMBTextField(
              controller: _costController,
              labelText: 'Cost',
              keyboardType: TextInputType.number,
            ),
            HMBTextField(
              controller: _quantityController,
              labelText: 'Quantity',
              keyboardType: TextInputType.number,
            ),
            HMBTextField(
              controller: _effortInHoursController,
              labelText: 'Effort (in hours)',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      );

  HMBDroplist<CheckListItemType> _chooseItemType(
          CheckListItem? checkListItem) =>
      HMBDroplist<CheckListItemType>(
        title: 'Item Type',
        initialItem: () async =>
            DaoCheckListItemType().getById(checkListItem?.itemTypeId),
        items: (filter) async => DaoCheckListItemType().getByFilter(filter),
        format: (taskStatus) => taskStatus.name,
        onChanged: (item) =>
            June.getState(CheckListItemTypeStatus.new).checkListItemType = item,
      );

  @override
  Future<CheckListItem> forUpdate(CheckListItem checkListItem) async =>
      CheckListItem.forUpdate(
          entity: checkListItem,
          checkListId: checkListItem.checkListId,
          description: _descriptionController.text,
          itemTypeId: June.getState(CheckListItemTypeStatus.new)
                  .checkListItemType
                  ?.id ??
              0,
          billed: false,
          unitCost: MoneyEx.tryParse(_costController.text),
          quantity: FixedEx.tryParse(_quantityController.text),
          effortInHours: FixedEx.tryParse(_effortInHoursController.text),
          completed: checkListItem.completed);

  @override
  Future<CheckListItem> forInsert() async => CheckListItem.forInsert(
        checkListId: widget.parent.id,
        description: _descriptionController.text,
        itemTypeId:
            June.getState(CheckListItemTypeStatus.new).checkListItemType?.id ??
                0,
        unitCost: MoneyEx.tryParse(_costController.text),
        quantity: FixedEx.tryParse(_quantityController.text),
        effortInHours: FixedEx.tryParse(_effortInHoursController.text),
      );

  @override
  void refresh() {
    setState(() {});
  }
}

class CheckListItemTypeStatus {
  CheckListItemType? checkListItemType;
}
