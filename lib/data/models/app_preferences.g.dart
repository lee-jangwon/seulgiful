// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppPreferences _$AppPreferencesFromJson(Map<String, dynamic> json) =>
    _AppPreferences(
      currencyConversionWarnings: json['currencyConversionWarnings'] as bool,
      quickAddEnabled: json['quickAddEnabled'] as bool,
      defaultTransactionTime: json['defaultTransactionTime'] as String,
    );

Map<String, dynamic> _$AppPreferencesToJson(_AppPreferences instance) =>
    <String, dynamic>{
      'currencyConversionWarnings': instance.currencyConversionWarnings,
      'quickAddEnabled': instance.quickAddEnabled,
      'defaultTransactionTime': instance.defaultTransactionTime,
    };
