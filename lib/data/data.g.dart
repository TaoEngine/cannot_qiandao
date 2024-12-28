// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConfigDBCollection on Isar {
  IsarCollection<ConfigDB> get configDBs => this.collection();
}

const ConfigDBSchema = CollectionSchema(
  name: r'ConfigDB',
  id: 3019306772389451719,
  properties: {
    r'falseLocation': PropertySchema(
      id: 0,
      name: r'falseLocation',
      type: IsarType.bool,
    ),
    r'pluginURL': PropertySchema(
      id: 1,
      name: r'pluginURL',
      type: IsarType.string,
    )
  },
  estimateSize: _configDBEstimateSize,
  serialize: _configDBSerialize,
  deserialize: _configDBDeserialize,
  deserializeProp: _configDBDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _configDBGetId,
  getLinks: _configDBGetLinks,
  attach: _configDBAttach,
  version: '3.1.0+1',
);

int _configDBEstimateSize(
  ConfigDB object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.pluginURL;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _configDBSerialize(
  ConfigDB object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.falseLocation);
  writer.writeString(offsets[1], object.pluginURL);
}

ConfigDB _configDBDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ConfigDB();
  object.falseLocation = reader.readBoolOrNull(offsets[0]);
  object.id = id;
  object.pluginURL = reader.readStringOrNull(offsets[1]);
  return object;
}

P _configDBDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _configDBGetId(ConfigDB object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _configDBGetLinks(ConfigDB object) {
  return [];
}

void _configDBAttach(IsarCollection<dynamic> col, Id id, ConfigDB object) {
  object.id = id;
}

extension ConfigDBQueryWhereSort on QueryBuilder<ConfigDB, ConfigDB, QWhere> {
  QueryBuilder<ConfigDB, ConfigDB, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ConfigDBQueryWhere on QueryBuilder<ConfigDB, ConfigDB, QWhereClause> {
  QueryBuilder<ConfigDB, ConfigDB, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ConfigDBQueryFilter
    on QueryBuilder<ConfigDB, ConfigDB, QFilterCondition> {
  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition>
      falseLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'falseLocation',
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition>
      falseLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'falseLocation',
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> falseLocationEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'falseLocation',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pluginURL',
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pluginURL',
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pluginURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pluginURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pluginURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pluginURL',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pluginURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pluginURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pluginURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pluginURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition> pluginURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pluginURL',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterFilterCondition>
      pluginURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pluginURL',
        value: '',
      ));
    });
  }
}

extension ConfigDBQueryObject
    on QueryBuilder<ConfigDB, ConfigDB, QFilterCondition> {}

extension ConfigDBQueryLinks
    on QueryBuilder<ConfigDB, ConfigDB, QFilterCondition> {}

extension ConfigDBQuerySortBy on QueryBuilder<ConfigDB, ConfigDB, QSortBy> {
  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> sortByFalseLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falseLocation', Sort.asc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> sortByFalseLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falseLocation', Sort.desc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> sortByPluginURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluginURL', Sort.asc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> sortByPluginURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluginURL', Sort.desc);
    });
  }
}

extension ConfigDBQuerySortThenBy
    on QueryBuilder<ConfigDB, ConfigDB, QSortThenBy> {
  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> thenByFalseLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falseLocation', Sort.asc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> thenByFalseLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falseLocation', Sort.desc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> thenByPluginURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluginURL', Sort.asc);
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QAfterSortBy> thenByPluginURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluginURL', Sort.desc);
    });
  }
}

extension ConfigDBQueryWhereDistinct
    on QueryBuilder<ConfigDB, ConfigDB, QDistinct> {
  QueryBuilder<ConfigDB, ConfigDB, QDistinct> distinctByFalseLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'falseLocation');
    });
  }

  QueryBuilder<ConfigDB, ConfigDB, QDistinct> distinctByPluginURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pluginURL', caseSensitive: caseSensitive);
    });
  }
}

extension ConfigDBQueryProperty
    on QueryBuilder<ConfigDB, ConfigDB, QQueryProperty> {
  QueryBuilder<ConfigDB, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ConfigDB, bool?, QQueryOperations> falseLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'falseLocation');
    });
  }

  QueryBuilder<ConfigDB, String?, QQueryOperations> pluginURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pluginURL');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserDBCollection on Isar {
  IsarCollection<UserDB> get userDBs => this.collection();
}

const UserDBSchema = CollectionSchema(
  name: r'UserDB',
  id: 1304415983115204734,
  properties: {
    r'passwordmd5': PropertySchema(
      id: 0,
      name: r'passwordmd5',
      type: IsarType.string,
    ),
    r'userid': PropertySchema(
      id: 1,
      name: r'userid',
      type: IsarType.string,
    ),
    r'username': PropertySchema(
      id: 2,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _userDBEstimateSize,
  serialize: _userDBSerialize,
  deserialize: _userDBDeserialize,
  deserializeProp: _userDBDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userDBGetId,
  getLinks: _userDBGetLinks,
  attach: _userDBAttach,
  version: '3.1.0+1',
);

int _userDBEstimateSize(
  UserDB object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.passwordmd5;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.username;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userDBSerialize(
  UserDB object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.passwordmd5);
  writer.writeString(offsets[1], object.userid);
  writer.writeString(offsets[2], object.username);
}

UserDB _userDBDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserDB();
  object.id = id;
  object.passwordmd5 = reader.readStringOrNull(offsets[0]);
  object.userid = reader.readStringOrNull(offsets[1]);
  object.username = reader.readStringOrNull(offsets[2]);
  return object;
}

P _userDBDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userDBGetId(UserDB object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userDBGetLinks(UserDB object) {
  return [];
}

void _userDBAttach(IsarCollection<dynamic> col, Id id, UserDB object) {
  object.id = id;
}

extension UserDBQueryWhereSort on QueryBuilder<UserDB, UserDB, QWhere> {
  QueryBuilder<UserDB, UserDB, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserDBQueryWhere on QueryBuilder<UserDB, UserDB, QWhereClause> {
  QueryBuilder<UserDB, UserDB, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserDBQueryFilter on QueryBuilder<UserDB, UserDB, QFilterCondition> {
  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'passwordmd5',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'passwordmd5',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5EqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordmd5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5GreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'passwordmd5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5LessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'passwordmd5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5Between(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'passwordmd5',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'passwordmd5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'passwordmd5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'passwordmd5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'passwordmd5',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordmd5',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> passwordmd5IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'passwordmd5',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userid',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userid',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userid',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> useridIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userid',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension UserDBQueryObject on QueryBuilder<UserDB, UserDB, QFilterCondition> {}

extension UserDBQueryLinks on QueryBuilder<UserDB, UserDB, QFilterCondition> {}

extension UserDBQuerySortBy on QueryBuilder<UserDB, UserDB, QSortBy> {
  QueryBuilder<UserDB, UserDB, QAfterSortBy> sortByPasswordmd5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordmd5', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> sortByPasswordmd5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordmd5', Sort.desc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> sortByUserid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userid', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> sortByUseridDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userid', Sort.desc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserDBQuerySortThenBy on QueryBuilder<UserDB, UserDB, QSortThenBy> {
  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByPasswordmd5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordmd5', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByPasswordmd5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordmd5', Sort.desc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByUserid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userid', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByUseridDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userid', Sort.desc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserDB, UserDB, QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserDBQueryWhereDistinct on QueryBuilder<UserDB, UserDB, QDistinct> {
  QueryBuilder<UserDB, UserDB, QDistinct> distinctByPasswordmd5(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordmd5', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDB, UserDB, QDistinct> distinctByUserid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDB, UserDB, QDistinct> distinctByUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension UserDBQueryProperty on QueryBuilder<UserDB, UserDB, QQueryProperty> {
  QueryBuilder<UserDB, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserDB, String?, QQueryOperations> passwordmd5Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordmd5');
    });
  }

  QueryBuilder<UserDB, String?, QQueryOperations> useridProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userid');
    });
  }

  QueryBuilder<UserDB, String?, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
