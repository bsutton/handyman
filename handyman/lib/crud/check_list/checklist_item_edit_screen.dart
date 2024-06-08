import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';
import 'package:money2/money2.dart';

import '../../dao/dao_check_list_item_type.dart';
import '../../dao/dao_checklist_item.dart';
import '../../dao/join_adaptors/dao_join_adaptor.dart';
import '../../entity/check_list.dart';
import '../../entity/check_list_item.dart';
import '../../entity/check_list_item_type.dart';
import '../../entity/entity.dart';
import '../../util/fixed_ex.dart';
import '../../util/money_ex.dart';
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
  late TextEditingController _effortInHoursController;
  late FocusNode _descriptionFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.checkListItem?.description);
    _costController =
        TextEditingController(text: widget.checkListItem?.cost.toString());
    _effortInHoursController = TextEditingController(
        text: widget.checkListItem?.effortInHours.toString());

    _descriptionFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_descriptionFocusNode);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    _effortInHoursController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NestedEntityEditScreen<CheckListItem, CheckList>(
        entity: widget.checkListItem,
        entityName: 'CheckListItem',
        dao: DaoCheckListItem(),
        onInsert: (checkListItem) async =>
            widget.daoJoin.insertForParent(checkListItem!, widget.parent),
        entityState: this,
        editor: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HMBTextField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                labelText: 'Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              _chooseItemType(),
              HMBTextField(
                controller: _costController,
                labelText: 'Cost',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cost';
                  }
                  return null;
                },
              ),
              HMBTextField(
                controller: _effortInHoursController,
                labelText: 'Effort (in hours)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the effort in hours';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );

  HMBDroplist<CheckListItemType> _chooseItemType() =>
      HMBDroplist<CheckListItemType>(
        title: 'Item Type',
        initialItem: () async =>
            DaoCheckListItemType().getById(widget.checkListItem?.itemTypeId),
        items: (filter) async => DaoCheckListItemType().getByFilter(filter),
        format: (taskStatus) => taskStatus.name,
        onChanged: (item) =>
            June.getState(CheckListItemTypeStatus.new).checkListItemType = item,
      );

  @override
  Future<CheckListItem> forUpdate(CheckListItem checkListItem) async =>
      CheckListItem.forUpdate(
        entity: checkListItem,
        checkListId: widget.checkListItem!.checkListId,
        description: _descriptionController.text,
        itemTypeId:
            June.getState(CheckListItemTypeStatus.new).checkListItemType?.id ??
                0,
        cost: MoneyEx.tryParse(_costController.text),
        effortInHours: Fixed.parse(_effortInHoursController.text),
      );

  @override
  Future<CheckListItem> forInsert() async => CheckListItem.forInsert(
        checkListId: widget.parent.id,
        description: _descriptionController.text,
        itemTypeId:
            June.getState(CheckListItemTypeStatus.new).checkListItemType?.id ??
                0,
        cost: MoneyEx.tryParse(_costController.text),
        effortInHours: FixedEx.tryParse(_effortInHoursController.text),
      );
}

class CheckListItemTypeStatus {
  CheckListItemType? checkListItemType;
}
