import 'package:strings/strings.dart';

import '../../util/is_type_of.dart';
import '../entities/entity.dart';
import 'activity_repository.dart';
import 'attachment_respository.dart';
import 'check_list_item_repository.dart';
import 'check_list_item_type_repository.dart';
import 'check_list_repository.dart';
import 'check_list_template_repository.dart';
import 'contact_repository.dart';
import 'contact_role_repository.dart';
import 'customer_repository.dart';
import 'email_verification_repository.dart';
import 'job_repository.dart';
import 'organisation_repository.dart';
import 'repository.dart';
import 'repository_search.dart';
import 'role_repository.dart';
import 'system_repository.dart';
import 'unauthed_action_repository.dart';
import 'user_repository.dart';

class Repos {
  factory Repos() {
    _self ??= Repos._internal();
    return _self!;
  }

  Repos._internal() {
    activity = register(ActivityRepository());
    attachment = register(AttachmentRepository());
    checklistItem = register(ChecklistItemRepository());
    checklistItemType = register(ChecklistItemTypeRepository());
    checkList = register(ChecklistRepository());
    checklistTemplate = register(ChecklistTemplateRepository());
    contact = register(ContactRepository());
    contactRole = register(ContactRoleRepository());
    customer = register(CustomerRepository());
    job = register(JobRepository());
    organisation = register(OrganisationRepository());
    role = register(RoleRepository());
    emailVerification = register(EmailVerificationRepository());
    unAuthedActions = register(UnAuthedActionRepository());
    user = register(UserRepository());

    // This is the NjContactClient and it's special, it communicates
    // directly with njadmin and it
    // doesn't use Entities at all so
    // it won't be registered. It also doesn't get wrapped up in
    // transactions as it does things like long polling
    system = SystemRepository();

    // register(tutorial);
  }
  static Repos? _self;

  late ActivityRepository activity;
  late AttachmentRepository attachment;
  late ChecklistItemRepository checklistItem;
  late ChecklistItemTypeRepository checklistItemType;
  late ChecklistRepository checkList;
  late ChecklistTemplateRepository checklistTemplate;
  late ContactRepository contact;
  late EmailVerificationRepository emailVerification;
  late UnAuthedActionRepository unAuthedActions;
  late ContactRoleRepository contactRole;
  late CustomerRepository customer;
  late JobRepository job;
  late OrganisationRepository organisation;
  late RoleRepository role;
  late UserRepository user;
  late SystemRepository system;

  Map<String, Repository> repos = <String, Repository>{};

  //Repository<T> register<T extends Entity<T>>(Repository<T> repository) {
  R register<R>(R repository) {
    final repoType = repository.runtimeType.toString(); // typeOfGeneric<T>();
    final type = Strings.left(repoType, repoType.length - 'Repository'.length);

    repos[type] = repository as Repository;

    return repository;
  }

  Repository<T> of<T extends Entity<T>>() =>
      repos[typeOfGeneric<T>()]! as Repository<T>;

  RepositorySearch<T> searchOf<T extends Entity<T>>() =>
      repos[typeOfGeneric<T>()]! as RepositorySearch<T>;
}
