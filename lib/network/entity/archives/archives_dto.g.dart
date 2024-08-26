// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archives_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchivesDTO _$ArchivesDTOFromJson(Map<String, dynamic> json) => ArchivesDTO(
      DATA: json['DATA'] == null
          ? null
          : ArchivesData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$ArchivesDTOToJson(ArchivesDTO instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

ArchivesData _$ArchivesDataFromJson(Map<String, dynamic> json) => ArchivesData(
      magazines: json['magazines'] == null
          ? null
          : Magazines.fromJson(json['magazines'] as Map<String, dynamic>),
      newspapers: json['newspapers'] == null
          ? null
          : Magazines.fromJson(json['newspapers'] as Map<String, dynamic>),
      publications: (json['publications'] as List<dynamic>?)
          ?.map((e) => Publication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArchivesDataToJson(ArchivesData instance) =>
    <String, dynamic>{
      'magazines': instance.magazines,
      'newspapers': instance.newspapers,
      'publications': instance.publications,
    };

Magazines _$MagazinesFromJson(Map<String, dynamic> json) => Magazines(
      current_page: json['current_page'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PaperDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      first_page_url: json['first_page_url'] as String?,
      from: json['from'] as int?,
      last_page: json['last_page'] as int?,
      last_page_url: json['last_page_url'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => Links.fromJson(e as Map<String, dynamic>))
          .toList(),
      next_page_url: json['next_page_url'] as String?,
      path: json['path'] as String?,
      per_page: json['per_page'] as int?,
      prev_page_url: json['prev_page_url'] as String?,
      to: json['to'] as int?,
      total: json['total'] as int?,
    );

Map<String, dynamic> _$MagazinesToJson(Magazines instance) => <String, dynamic>{
      'current_page': instance.current_page,
      'data': instance.data,
      'first_page_url': instance.first_page_url,
      'from': instance.from,
      'last_page': instance.last_page,
      'last_page_url': instance.last_page_url,
      'links': instance.links,
      'next_page_url': instance.next_page_url,
      'path': instance.path,
      'per_page': instance.per_page,
      'prev_page_url': instance.prev_page_url,
      'to': instance.to,
      'total': instance.total,
    };

PaperDTO _$PaperDTOFromJson(Map<String, dynamic> json) => PaperDTO(
      id: json['id'] as int?,
      u_id: json['u_id'] as int?,
      title: json['title'] as String?,
      short_description: json['short_description'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      currency: json['currency'] as String?,
      cover_image: json['cover_image'] as String?,
      thumbnail_image: json['thumbnail_image'] as String?,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      publication: json['publication'] == null
          ? null
          : Publication.fromJson(json['publication'] as Map<String, dynamic>),
      published_date: json['published_date'] as String?,
      published_date_readable: json['published_date_readable'] as String?,
      bookmark: json['bookmark'] as bool?,
      grid_view: json['grid_view'] as bool?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$PaperDTOToJson(PaperDTO instance) => <String, dynamic>{
      'id': instance.id,
      'u_id': instance.u_id,
      'title': instance.title,
      'short_description': instance.short_description,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'cover_image': instance.cover_image,
      'thumbnail_image': instance.thumbnail_image,
      'category': instance.category,
      'publication': instance.publication,
      'published_date': instance.published_date,
      'published_date_readable': instance.published_date_readable,
      'bookmark': instance.bookmark,
      'grid_view': instance.grid_view,
      'type': instance.type,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

Publication _$PublicationFromJson(Map<String, dynamic> json) => Publication(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'status': instance.status,
    };

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      url: json['url'] as String?,
      label: json['label'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
