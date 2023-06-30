// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayListsCollection on Isar {
  IsarCollection<PlayLists> get playlists => this.collection();
}

const PlayListsSchema = CollectionSchema(
  name: r'PlayLists',
  id: -7716305863640779075,
  properties: {
    r'play_list_songs': PropertySchema(
      id: 0,
      name: r'play_list_songs',
      type: IsarType.stringList,
    )
  },
  estimateSize: _playListsEstimateSize,
  serialize: _playListsSerialize,
  deserialize: _playListsDeserialize,
  deserializeProp: _playListsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _playListsGetId,
  getLinks: _playListsGetLinks,
  attach: _playListsAttach,
  version: '3.1.0+1',
);

int _playListsEstimateSize(
  PlayLists object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.play_list_songs;
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

void _playListsSerialize(
  PlayLists object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.play_list_songs);
}

PlayLists _playListsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayLists();
  object.id = id;
  object.play_list_songs = reader.readStringList(offsets[0]);
  return object;
}

P _playListsDeserializeProp<P>(
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

Id _playListsGetId(PlayLists object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playListsGetLinks(PlayLists object) {
  return [];
}

void _playListsAttach(IsarCollection<dynamic> col, Id id, PlayLists object) {
  object.id = id;
}

extension PlayListsQueryWhereSort
    on QueryBuilder<PlayLists, PlayLists, QWhere> {
  QueryBuilder<PlayLists, PlayLists, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayListsQueryWhere
    on QueryBuilder<PlayLists, PlayLists, QWhereClause> {
  QueryBuilder<PlayLists, PlayLists, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PlayLists, PlayLists, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterWhereClause> idBetween(
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

extension PlayListsQueryFilter
    on QueryBuilder<PlayLists, PlayLists, QFilterCondition> {
  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'play_list_songs',
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'play_list_songs',
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'play_list_songs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'play_list_songs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'play_list_songs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'play_list_songs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'play_list_songs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'play_list_songs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'play_list_songs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'play_list_songs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'play_list_songs',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'play_list_songs',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'play_list_songs',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'play_list_songs',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'play_list_songs',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'play_list_songs',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'play_list_songs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterFilterCondition>
      play_list_songsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'play_list_songs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PlayListsQueryObject
    on QueryBuilder<PlayLists, PlayLists, QFilterCondition> {}

extension PlayListsQueryLinks
    on QueryBuilder<PlayLists, PlayLists, QFilterCondition> {}

extension PlayListsQuerySortBy on QueryBuilder<PlayLists, PlayLists, QSortBy> {}

extension PlayListsQuerySortThenBy
    on QueryBuilder<PlayLists, PlayLists, QSortThenBy> {
  QueryBuilder<PlayLists, PlayLists, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayLists, PlayLists, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PlayListsQueryWhereDistinct
    on QueryBuilder<PlayLists, PlayLists, QDistinct> {
  QueryBuilder<PlayLists, PlayLists, QDistinct> distinctByPlay_list_songs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'play_list_songs');
    });
  }
}

extension PlayListsQueryProperty
    on QueryBuilder<PlayLists, PlayLists, QQueryProperty> {
  QueryBuilder<PlayLists, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayLists, List<String>?, QQueryOperations>
      play_list_songsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'play_list_songs');
    });
  }
}
