import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../dao/bus/bus.dart';
import '../../dao/entities/entity.dart';
import '../../dao/repository/repos.dart';
import '../../dao/repository/repository.dart';
import '../../util/quick_snack.dart';
import '../blocking_ui.dart';
import '../theme/nj_button.dart';
import '../theme/nj_theme.dart';

typedef EntityCallback<T> = T Function();

class CrudEdit<T extends Entity<T>> extends StatefulWidget {
  const CrudEdit(
      {required this.formKey,
      required this.entity,
      required this.onSave,
      required this.children,
      super.key});

  final GlobalKey<FormState> formKey;
  final T entity;
  final EntityCallback<Future<T>> onSave;
  final List<Widget> children;

  @override
  CrudEditState<T> createState() => CrudEditState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GlobalKey<FormState>>('formKey', formKey))
      ..add(DiagnosticsProperty<T>('entity', entity))
      ..add(
          ObjectFlagProperty<EntityCallback<Future<T>>>.has('onSave', onSave));
  }
}

class CrudEditState<T extends Entity<T>> extends State<CrudEdit<T>> {
  final Repository<T> repository = Repos().of<T>();

  void _cancel() {
    Navigator.of(context).pop<bool>(false);
  }

  void _save() {
    if (!widget.formKey.currentState!.validate()) {
      return;
    }
    widget.formKey.currentState.save();

    BlockingUI().run<void>(() => widget.onSave().then((entity) {
          repository.update(entity).then((result) {
            Bus().add<T>(BusAction.update,
                instance: entity, oldInstance: widget.entity);
            Navigator.of(context).pop<bool>(true);
          }).catchError((dynamic error) {
            QuickSnack().error(context, error.toString());
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    final children = List<Widget>.from(widget.children);
    children.add(Expanded(child: Container()));
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        NJButtonPrimary(label: 'Cancel', onPressed: _cancel),
        NJButtonPrimary(label: 'Save', onPressed: _save),
      ],
    ));
    return AppScaffold(
      builder: (context) => Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.always,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Padding(
              padding: const EdgeInsets.all(NJTheme.padding),
              child: Column(
                children: children,
              )),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Repository<T>>('repository', repository));
  }
}
