import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entities/activity.dart';
import '../entities/address.dart';
import '../entities/attachment.dart';
import '../entities/check_list_item_type.dart';
import '../entities/contact.dart';
import '../entities/contact_role.dart';
import '../entities/customer.dart';
import '../entities/entity.dart';
import '../entities/organisation.dart';
import '../entities/role.dart';
import '../entities/stage.dart';
import '../entities/task.dart';
import '../entities/tutorial.dart';
import '../repository/repos.dart';
import '../transaction/transaction.dart';

///
/// An [ER] is used to wrap entities.
///
/// When fetching entities across the network boundary
/// the entities are returned as json.
/// To limit data retrieved any child entities are not
/// return, just their guid.
/// An ER is used to wrap these child entites guid's to
/// make it easy to retrieve them when needed.
/// Top level entities should never leave the [Entity]
/// wrapped but all child entities (this directly contained in a parent)
/// MUST be wrapped.
class ER<E extends Entity<E>> {
  /// Creates an ER from an already resolved entity.
  /// This is used when construction entities on the
  /// client which are going to be sent to the server
  /// or even just temporary entities.
  ER(E entity)
      : _resolvedEntity = entity,
        guid = entity.guid;

  /// Creates an ER from a guid.
  ///
  /// Calling [resolve] will trigger the process
  /// to resolve the entity (i.e. do the network call)
  ER.fromGUID(this.guid);

  static ER<E>? fromJson<E extends Entity<E>>(Map<String, dynamic>? json) =>
      json == null ? null : ER.fromGUID(GUID(json as String));

  GUID? guid;

  // Once the entity has been resolved we cache it here.
  E? _resolvedEntity;

  /// Returns a future to the entity and starts the process
  ///  of 'completing' the future.
  ///
  /// A call to this method will trigger
  /// a network call to retrieve the entity.
  ///
  /// If the entity is already  [isResolved]
  /// then the future will be completed immediately.
  ///
  /// This method can be chained to resolve a subtree of entities.
  ///
  /// example:
  /// ```dart
  /// DND dnd = await Repos.dnd.getByUser(Repos.user.viewAsUser);
  ///
  /// // resolve the dnd and its field callForwardTarget
  /// await dnd.callForwardTarget.resolve;
  ///
  /// // now access the resolved entities.
  /// Log.d(dnd.endTime);
  /// Log.d(dnd.callForwardTarget.entity.externalNo)
  ///
  /// ```
  Future<E?> get resolve => _resolve(null);

  Future<E> resolveWithinTransaction(Transaction? transaction) =>
      _resolve(transaction);

  //
  /// A convenience method which resolves
  /// the ER and then returns Future<this>.
  /// a Future<ER<E>>
  /// You can chain mulitple resolves to
  Future<ER<E>> get resolveER async {
    final completer = CompleterEx<ER<E>>();

    await _resolve(null);
    completer.complete(this);

    return completer.future;
  }

  Future<E> _resolve(Transaction? transaction) async {
    Repos().of<E>();

    return Future.value(_resolvedEntity);
  }

  /// Use this method when updating an entity so that the ER
  /// has a copy of the most recent version.
  /// You can ONLY UPDATE an enity with an entity with the same
  /// guid.
  /// The ER MUST be resolved before you call this method.
  void replace(E entity) {
    if (!isResolved) {
      throw UnresolvedEntityException();
    }

    if (entity.guid != guid) {
      throw InvalidReplaceEntityException(guid!, entity.guid);
    }

    _resolvedEntity = entity;
  }

  ///
  /// Returns the completed entity.
  /// Note: it is illegal to call this method
  /// if the entity is not already [isResolved].
  /// An entity can be resolved in one of two ways:
  /// 1)
  /// The ER was created with a resolved entity by calling [ER(entity)].
  /// 2)
  /// The ER was resolved by a call to [ER.resolve] and that future
  /// has completed.
  ///
  /// You can call 'isResolved' to determine if the entity has been resolved.
  E get entity => _resolvedEntity!;

  bool get isResolved => _resolvedEntity != null;

  /// completes the future on the ER's entity and
  /// then executes the provided function against
  /// the resolved entity.
  /// This method is designed as a short cut
  /// method of access fields of an entity wrapped
  /// via an ER.
  /// example:
  /// ```dart
  /// class Customer {
  ///   String name;
  /// }
  ///
  /// ER<Customer> rCustomer;
  ///
  /// rCustomer.resolve((customer) => customer.name);
  ///
  /// ```
  ///
  Future<R> call<R>(R Function(E? entity) fn) async {
    final completer = CompleterEx<R>();

    final entity = await resolve;
    completer.complete(fn(entity));

    return completer.future;
  }

  ///
  /// This method is a short cut to getting
  /// the [ER]'s future and then calling
  /// [then()].
  /// example:
  /// The long way
  /// ```dart
  /// ref.future.then((e) => fn());
  /// ```
  /// The short way
  /// ```dart
  /// ref.then((e) => fn())
  /// ```
  /// The returned future will only complete
  /// once the entity is resolved AND the
  /// function [fn] has completed.
  Future<E> then(void Function(E?) fn) {
    final completer = CompleterEx<E>();
    resolve.then((entity) {
      fn(entity);
      completer.complete(entity);
    });
    return completer.future;
  }

  ///
  /// This is a helper function which will resolve
  /// every ER in the passed list.
  /// Once this method returns you can access the entity
  /// via [ER.entity] of each item in the list.
  /// Resolution happens in parallel.
  /// We return the passed [entities] wrapped in a future as
  /// a convenience.
  static Future<List<ER<T>>> resolveList<T extends Entity<T>>(
      List<ER<T>> entities) async {
    final resolvers = <Future<T?>>[];
    for (final entity in entities) {
      resolvers.add(entity.resolve);
    }

    await Future.wait(resolvers);
    return Future.value(entities);
  }

  static Future<List<ER<C>>>
      resolveERListChild<P extends Entity<P>, C extends Entity<C>>(
          List<ER<P>> parents, Future<ER<C>> Function(P) getChild) async {
    await resolveList(parents);

    // Now build and resolve the list of children
    final children = <ER<C>>[];

    final resolvers = <Future<C?>>[];
    for (final parent in parents) {
      final child = getChild(parent.entity);
      resolvers.add((await child).resolve);
      children.add(await child);
    }

    await Future.wait(resolvers);
    return Future.value(children);
  }

  static Future<List<C?>>
      resolveListChild<P extends Entity<P>, C extends Entity<C>>(
          List<P> parents, Future<ER<C>> Function(P) getChild) async {
    // Now build and resolve the list of children
    final children = <C?>[];

    for (final parent in parents) {
      final child = getChild(parent);
      children.add(await (await child).resolve);
    }

    return children;
  }

  // ER<C> chain<C extends Entity>(ER<C> Function(E entity) fn) {

  //   return entity.then(())
  //   // entity.then(()).resolve<ER<DIDPool>>((entity) => entity.pool);

  //   // return refPool.then((pool) => pool.resolve<Region>((pool) => pool.region));
  // }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(covariant ER other) => guid == other.guid;

  /// Takes a list of [ER<Entity>] and returns a lost of the
  /// resolved Entties.
  static Future<List<E>> decantList<E extends Entity<E>>(
      List<ER<E>> erEntities) async {
    final entities = <E>[];
    for (final erEntity in erEntities) {
      final resolved = await erEntity.resolve;
      if (resolved != null) {
        entities.add(resolved);
      }
    }
    return entities;
  }

  String toJson() => guid == null ? '' : guid.toString();

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => guid.hashCode;
}

class ERConverterAddress extends ERConverter<Address> {
  const ERConverterAddress();
}

class ERConverterCustomer extends ERConverter<Customer> {
  const ERConverterCustomer();
}

class ERConverterUser extends ERConverter<User> {
  const ERConverterUser();
}

class ERConverterAttachment extends ERConverter<Attachment> {
  const ERConverterAttachment();
}

class ERConverterActivity extends ERConverter<Activity> {
  const ERConverterActivity();
}

class ERConverterChecklistItem extends ERConverter<ChecklistItem> {
  const ERConverterChecklistItem();
}

class ERConverterStage extends ERConverter<Stage> {
  const ERConverterStage();
}

class ERConverterTask extends ERConverter<Task> {
  const ERConverterTask();
}

class ERConverterContactRole extends ERConverter<ContactRole> {
  const ERConverterContactRole();
}

class ERConverterContact extends ERConverter<Contact> {
  const ERConverterContact();
}

class ERConverterRole extends ERConverter<Role> {
  const ERConverterRole();
}

class ERConverterOrganisation extends ERConverter<Organisation> {
  const ERConverterOrganisation();
}

class ERConverterJob extends ERConverter<Job> {
  const ERConverterJob();
}

class ERConverterChecklistItemType extends ERConverter<ChecklistItemType> {
  const ERConverterChecklistItemType();
}

class ERTutorialConverter extends ERConverter<Tutorial> {
  const ERTutorialConverter();
}

class ERConverter<T extends Entity<T>> implements JsonConverter<ER<T>, String> {
  const ERConverter();

  @override
  ER<T> fromJson(String json) => ER<T>.fromGUID(GUID(json));

  @override
  String toJson(ER<T>? er) => er == null ? '' : er.guid.toString();
}

class UnresolvedEntityException implements Exception {
  UnresolvedEntityException();

  @override
  String toString() => 'You must resolve the entity before calling ER.entity';
}

class IllegalEntityForER implements Exception {
  IllegalEntityForER();

  @override
  String toString() =>
      'The passed entity was null. You must have a valid entity to create an ER';
}

class InvalidGUIDException implements Exception {
  InvalidGUIDException();

  @override
  String toString() =>
      'The entity does not have a valid guid and as such cannot be resolved.';
}

class InvalidReplaceEntityException implements Exception {
  InvalidReplaceEntityException(this.existingGUID, this.newGUID);
  final GUID existingGUID;

  final GUID? newGUID;

  @override
  String toString() => '''
You attempted to replace the enity of an ER with an entity that had a different GUID Existing: $existingGUID New: $newGUID.''';
}
