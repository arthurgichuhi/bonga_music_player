// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_music_file_paths.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAllMusicFilesCollection on Isar {
  IsarCollection<AllMusicFiles> get allMusicFiles => this.collection();
}

const AllMusicFilesSchema = CollectionSchema(
  name: r'AllMusicFiles',
  id: -1089919500741059977,
  properties: {
    r'musicFilePaths': PropertySchema(
      id: 0,
      name: r'musicFilePaths',
      type: IsarType.stringList,
    )
  },
  estimateSize: _allMusicFilesEstimateSize,
  serialize: _allMusicFilesSerialize,
  deserialize: _allMusicFilesDeserialize,
  deserializeProp: _allMusicFilesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _allMusicFilesGetId,
  getLinks: _allMusicFilesGetLinks,
  attach: _allMusicFilesAttach,
  version: '3.1.0+1',
);

int _allMusicFilesEstimateSize(
  AllMusicFiles object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.musicFilePaths;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _allMusicFilesSerialize(
  AllMusicFiles object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.musicFilePaths);
}

AllMusicFiles _allMusicFilesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AllMusicFiles();
  object.id = id;
  object.musicFilePaths = reader.readStringList(offsets[0]);
  return object;
}

P _allMusicFilesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _allMusicFilesGetId(AllMusicFiles object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _allMusicFilesGetLinks(AllMusicFiles object) {
  return [];
}

void _allMusicFilesAttach(
    IsarCollection<dynamic> col, Id id, AllMusicFiles object) {
  object.id = id;
}

extension AllMusicFilesQueryWhereSort
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QWhere> {
  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AllMusicFilesQueryWhere
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QWhereClause> {
  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterWhereClause> idBetween(
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

extension AllMusicFilesQueryFilter
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QFilterCondition> {
  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'musicFilePaths',
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'musicFilePaths',
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musicFilePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'musicFilePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'musicFilePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'musicFilePaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'musicFilePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'musicFilePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'musicFilePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'musicFilePaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musicFilePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'musicFilePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musicFilePaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musicFilePaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musicFilePaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musicFilePaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musicFilePaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterFilterCondition>
      musicFilePathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musicFilePaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AllMusicFilesQueryObject
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QFilterCondition> {}

extension AllMusicFilesQueryLinks
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QFilterCondition> {}

extension AllMusicFilesQuerySortBy
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QSortBy> {}

extension AllMusicFilesQuerySortThenBy
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QSortThenBy> {
  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AllMusicFiles, AllMusicFiles, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AllMusicFilesQueryWhereDistinct
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QDistinct> {
  QueryBuilder<AllMusicFiles, AllMusicFiles, QDistinct>
      distinctByMusicFilePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'musicFilePaths');
    });
  }
}

extension AllMusicFilesQueryProperty
    on QueryBuilder<AllMusicFiles, AllMusicFiles, QQueryProperty> {
  QueryBuilder<AllMusicFiles, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AllMusicFiles, List<String>?, QQueryOperations>
      musicFilePathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'musicFilePaths');
    });
  }
}
