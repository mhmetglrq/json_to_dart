import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_to_dart/config/constants/json_constants.dart';
import 'package:json_to_dart/config/extensions/context_extensions.dart';
import 'package:json_to_dart/config/items/borders.dart';
import 'package:json_to_dart/config/items/box_shadows.dart';

import '../../../../config/items/app_colors.dart';
import '../mixins/dashboard_mixin.dart';
import '../widgets/app_header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with DashboardMixin {
  final TextEditingController _jsonController =
      TextEditingController(text: JsonConstants.jsonHint);
  final TextEditingController _dartClassNameController =
      TextEditingController(text: "MyClass");
  final ScrollController _methodsController = ScrollController();
  final ScrollController _extraMethodsController = ScrollController();
  String _dartClass = JsonConstants.dartClassHint;
  String partDirective = 'my_class';
  bool isNullSafety = true;
  bool isTypesOnly = true;
  bool isEncoderDecoderInClass = true;
  bool arePropertiesRequired = false;
  bool arePropertiesFinal = true;
  bool isCopyWithGenerated = false;
  bool arePropertiesOptional = false;

  bool isFreezedCompatible = false;
  bool isHiveCompatible = false;
  bool isJsonSerializable = false;
  bool detectUUIDs = false;
  bool detectDates = false;
  bool detectMaps = false;
  bool mergeSimilarClasses = false;

  @override
  void dispose() {
    _jsonController.dispose();
    _dartClassNameController.dispose();
    _methodsController.dispose();
    _extraMethodsController.dispose();
    super.dispose();
  }

  void _convertJSON() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final String jsonString = _jsonController.text;

    try {
      final jsonData = jsonDecode(jsonString);

      if (jsonData is Map<String, dynamic>) {
        setState(() {
          _dartClass = generateDartClass(jsonData);
        });
      } else {
        setState(() {
          _dartClass = 'Invalid JSON format.';
        });
      }
    } catch (e) {
      setState(() {
        _dartClass = 'Error: ${e.toString()}';
      });
    }
  }

  String generateDartClass(Map<String, dynamic> jsonData) {
    final className = _dartClassNameController.text;
    StringBuffer classBuffer = StringBuffer();

    // JsonSerializable ile part directive ekleme
    if (isJsonSerializable || isFreezedCompatible || isHiveCompatible) {
      if (partDirective.isEmpty) {
        partDirective = 'my_class.g.dart';
      }
      classBuffer.writeln("part '$partDirective.g.dart';");
    }

    // JsonSerializable uyumluluğu
    if (isJsonSerializable) {
      classBuffer.writeln("@JsonSerializable()");
    }

    // Freezed uyumluluğu
    if (isFreezedCompatible) {
      classBuffer.writeln("@freezed");
      classBuffer.writeln("class $className with _\$$className {");
      classBuffer.writeln("  const factory $className({");
      jsonData.forEach((key, value) {
        String fieldType = _getFieldType(value);
        classBuffer
            .writeln("    ${isNullSafety ? '$fieldType?' : fieldType} $key,");
      });
      classBuffer.writeln("  }) = _$className;");
      classBuffer.writeln(
          "\n  factory $className.fromJson(Map<String, dynamic> json) => _\$FromJson(json);");
      classBuffer.writeln("}");
    } else {
      // Hive uyumluluğu
      if (isHiveCompatible) {
        classBuffer.writeln("@HiveType(typeId: 0)");
      }

      // Sınıf tanımı
      classBuffer.writeln(isHiveCompatible
          ? 'class $className extends HiveObject {'
          : 'class $className {');

      // Alanları tanımlama
      jsonData.forEach((key, value) {
        String fieldType = _getFieldType(value);
        String fieldDeclaration = '';

        // Hive Field annotations
        if (isHiveCompatible) {
          classBuffer
              .writeln("  @HiveField(${jsonData.keys.toList().indexOf(key)})");
        }

        // JsonKey anotasyonu
        if (isJsonSerializable) {
          classBuffer.writeln("  @JsonKey(name: '$key')");
        }

        // Final ve Null safety kontrolü
        if (arePropertiesFinal) {
          fieldDeclaration += 'final ';
        }

        fieldDeclaration +=
            isNullSafety ? '$fieldType? $key;' : '$fieldType $key;';
        classBuffer.writeln('  $fieldDeclaration');
      });

      // Constructor
      classBuffer.writeln('\n  $className({');
      jsonData.forEach((key, value) {
        if (arePropertiesRequired && isNullSafety) {
          classBuffer.writeln('    required this.$key,');
        } else {
          classBuffer.writeln('    this.$key,');
        }
      });
      classBuffer.writeln('  });');

      // fromJson ve toJson metotları (JsonSerializable veya isEncoderDecoderInClass kontrolü)
      if (isJsonSerializable) {
        classBuffer.writeln(
            '\n  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);');

        classBuffer.writeln(
            '\n  Map<String, dynamic> toJson() => _\$${className}ToJson(this);');
      }
      if (isEncoderDecoderInClass) {
        classBuffer.writeln(
            '\n  factory $className.fromJson(Map<String, dynamic> json) {');
        classBuffer.writeln('    return $className(');

        jsonData.forEach((key, value) {
          classBuffer.writeln('      $key: json[\'$key\'],');
        });

        classBuffer.writeln('    );');
        classBuffer.writeln('  }');

        classBuffer.writeln('\n  Map<String, dynamic> toJson() {');
        classBuffer.writeln('    return {');

        jsonData.forEach((key, value) {
          classBuffer.writeln('      \'$key\': $key,');
        });

        classBuffer.writeln('    };');
        classBuffer.writeln('  }');
      }

      // CopyWith metodu (isCopyWithGenerated kontrolü)
      if (isCopyWithGenerated) {
        classBuffer.writeln('\n  $className copyWith({');
        jsonData.forEach((key, value) {
          classBuffer.writeln('    ${value.runtimeType}? $key,');
        });
        classBuffer.writeln('  }) {');
        classBuffer.writeln('    return $className(');
        jsonData.forEach((key, value) {
          classBuffer.writeln('      $key: $key ?? this.$key,');
        });
        classBuffer.writeln('    );');
        classBuffer.writeln('  }');
      }

      // Merge Similar Classes (mergeSimilarClasses kontrolü)
      if (mergeSimilarClasses) {
        classBuffer.writeln(
            '\n  // Merge similar classes functionality could go here');
      }

      // Detect UUIDs, Dates, Maps özellikleri
      if (detectUUIDs || detectDates || detectMaps) {
        jsonData.forEach((key, value) {
          String fieldType = _getFieldType(value);

          if (detectUUIDs &&
              fieldType == 'String' &&
              key.toLowerCase().contains('uuid')) {
            classBuffer.writeln('  // Detected UUID: $key');
          }

          if (detectDates &&
              (fieldType == 'String' || fieldType == 'int') &&
              (key.toLowerCase().contains('date') ||
                  key.toLowerCase().contains('time'))) {
            classBuffer.writeln('  // Detected Date/Time: $key');
          }

          if (detectMaps && value is Map) {
            classBuffer.writeln('  // Detected Map: $key');
          }
        });
      }

      classBuffer.writeln('}');
    }

    return classBuffer.toString();
  }

// _getFieldType fonksiyonu, field tipini döndüren bir yardımcı fonksiyon
  String _getFieldType(dynamic value) {
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) return 'List<${_getFieldType(value.first)}>';
    if (value is Map) return 'Map<String, dynamic>';
    return 'dynamic';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.dynamicHeight(0.07),
        ),
        child: const AppHeader(),
      ),
      body: Padding(
        padding: context.paddingAllDefault,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: context.paddingBottomLow,
                    child: Text(
                      'JSON to Dart Class Converter',
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Borders.kContainerBase,
                        boxShadow: const [
                          BoxShadows.kLarge,
                        ],
                      ),
                      padding: context.paddingAllLow,
                      child: Stack(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: context.paddingVerticalDefault,
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.top,
                                    controller: _dartClassNameController,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    cursorColor: AppColors.kPrimaryLight,
                                    mouseCursor: MouseCursor.defer,
                                    keyboardType: TextInputType.multiline,
                                    cursorErrorColor: AppColors.kError,
                                    maxLengthEnforcement: MaxLengthEnforcement
                                        .truncateAfterCompositionEnds,
                                    decoration: InputDecoration(
                                      labelText: 'Class Name',
                                      border: Borders.kTextInputBase,
                                      hintText: JsonConstants.jsonHint,
                                      disabledBorder:
                                          Borders.kTextInputDisabled,
                                      errorBorder: Borders.kTextInputError,
                                      focusedBorder: Borders.kTextInputFocused,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.top,
                                    controller: _jsonController,
                                    expands: true,
                                    maxLines: null,
                                    minLines: null,
                                    autofocus: true,
                                    cursorColor: AppColors.kPrimaryLight,
                                    mouseCursor: MouseCursor.defer,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.multiline,
                                    cursorErrorColor: AppColors.kError,
                                    validator: (value) => value!.isEmpty
                                        ? 'Please enter a valid JSON'
                                        : null,
                                    maxLengthEnforcement: MaxLengthEnforcement
                                        .truncateAfterCompositionEnds,
                                    decoration: InputDecoration(
                                      labelText: 'JSON',
                                      border: Borders.kTextInputBase,
                                      hintText: JsonConstants.jsonHint,
                                      disabledBorder:
                                          Borders.kTextInputDisabled,
                                      errorBorder: Borders.kTextInputError,
                                      focusedBorder: Borders.kTextInputFocused,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: context.paddingAllDefault,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: AppColors.kPrimaryLight,
                                onPressed: _convertJSON,
                                child: Padding(
                                  padding: context.paddingAllLow,
                                  child: Text(
                                    'Convert to Dart Class',
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.kWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Class Generation Options (Null Safety, Types only, etc.)
            SizedBox(
              width: context.dynamicWidth(0.01),
            ),
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: context.paddingBottomLow,
                        child: Text(
                          'Dart Class Output:',
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Borders.kContainerBase,
                          ),
                          padding: context.paddingAllLow,
                          width: double.infinity,
                          child: SelectableText(
                            _dartClass,
                            cursorColor: AppColors.kPrimaryLight,
                            textAlign: TextAlign.start,
                            cursorRadius: const Radius.circular(5),
                            textWidthBasis: TextWidthBasis.parent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: context.paddingRightDefault,
                      child: _methodsCard(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: context.defaultValue,
                        bottom: context.defaultValue,
                      ),
                      child: _extraMethodsCard(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodsCard() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.dynamicWidth(0.2),
        maxHeight: context.dynamicHeight(0.40),
        minHeight: context.dynamicHeight(0.40),
        minWidth: context.dynamicWidth(0.2),
      ),
      child: Container(
        padding: context.paddingAllLow,
        decoration: BoxDecoration(
          border: Borders.kContainerBase,
          color: AppColors.kNeutral10,
          boxShadow: const [
            BoxShadows.kLarge,
          ],
        ),
        child: Scrollbar(
          controller: _methodsController,
          thickness: 5,
          child: SingleChildScrollView(
            controller: _methodsController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: context.paddingBottomLow,
                  child: Text(
                    'Output Options',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  title:
                      Text('Null Safety', style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isNullSafety,
                      onChanged: (val) {
                        setState(() {
                          isNullSafety = val;
                        });
                        _convertJSON();
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Types only', style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isTypesOnly,
                      onChanged: (value) {
                        setState(() {
                          isTypesOnly = value;
                        });
                        _convertJSON();
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Put encoder & decoder in Class',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isEncoderDecoderInClass,
                      onChanged: (val) {
                        setState(() {
                          isEncoderDecoderInClass = val;
                          if (val) {
                            isJsonSerializable =
                                false; // EncoderDecoder açık olduğunda JsonSerializable kapalı
                          }
                        });

                        _convertJSON();
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Make all properties required',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: arePropertiesRequired,
                      onChanged: (val) {
                        setState(() {
                          arePropertiesRequired = val;
                        });
                        _convertJSON();
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Make all properties final',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: arePropertiesFinal,
                      onChanged: (val) {
                        setState(() {
                          arePropertiesFinal = val;
                        });
                        _convertJSON();
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Generate CopyWith method',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isCopyWithGenerated,
                      onChanged: (val) {
                        setState(() {
                          isCopyWithGenerated = val;
                        });
                        _convertJSON();
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Make all properties optional',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: arePropertiesOptional,
                      onChanged: (val) {
                        setState(() {
                          arePropertiesOptional = val;
                        });
                      },
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.kNeutral50,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _extraMethodsCard() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.dynamicWidth(0.2),
        maxHeight: context.dynamicHeight(0.40),
        minHeight: context.dynamicHeight(0.40),
        minWidth: context.dynamicWidth(0.2),
      ),
      child: Container(
        padding: context.paddingAllLow,
        decoration: BoxDecoration(
          border: Borders.kContainerBase,
          color: AppColors.kNeutral10,
          boxShadow: const [
            BoxShadows.kLarge,
          ],
        ),
        child: Scrollbar(
          controller: _extraMethodsController,
          thickness: 5,
          child: SingleChildScrollView(
            controller: _extraMethodsController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: context.paddingBottomLow,
                  child: Text(
                    'Extra Output Options',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                // Part directive
                ListTile(
                  title: Text('Use this name in `part` directive',
                      style: context.textTheme.bodySmall),
                  subtitle: TextFormField(
                    initialValue: partDirective,
                    decoration: InputDecoration(
                      border: Borders.kTextInputBase,
                      hintText: 'Enter part directive',
                    ),
                    onChanged: (val) {
                      setState(() {
                        partDirective = val;
                      });
                    },
                  ),
                ),
                // Existing features (Null Safety, Types Only, etc.)

                // New Features
                ListTile(
                  title: Text(
                      'Generate class definitions with freezed compatibility',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isFreezedCompatible,
                      onChanged: (val) {
                        setState(() {
                          isFreezedCompatible = val;
                          if (val) {
                            // Diğer seçenekleri kapat
                            isHiveCompatible = false;
                            isJsonSerializable = false;
                          }
                        });

                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Generate annotations for Hive type adapters',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isHiveCompatible,
                      onChanged: (val) {
                        setState(() {
                          isHiveCompatible = val;
                          if (val) {
                            // Diğer seçenekleri kapat
                            isFreezedCompatible = false;
                          }
                        });

                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Generate annotations for json_serializable',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: isJsonSerializable,
                      onChanged: (val) {
                        setState(() {
                          isJsonSerializable = val;
                          if (val) {
                            // Diğer seçenekleri kapat
                            isFreezedCompatible = false;
                            isEncoderDecoderInClass = false;
                          }
                        });
                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
                ListTile(
                  title:
                      Text('Detect UUIDs', style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: detectUUIDs,
                      onChanged: (val) {
                        setState(() {
                          detectUUIDs = val;
                        });
                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Detect dates & times',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: detectDates,
                      onChanged: (val) {
                        setState(() {
                          detectDates = val;
                        });
                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
                ListTile(
                  title:
                      Text('Detect maps', style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: detectMaps,
                      onChanged: (val) {
                        setState(() {
                          detectMaps = val;
                        });
                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Merge similar classes',
                      style: context.textTheme.bodySmall),
                  trailing: Transform.scale(
                    scale: context.dynamicHeight(0.0008),
                    child: Switch(
                      value: mergeSimilarClasses,
                      onChanged: (val) {
                        setState(() {
                          mergeSimilarClasses = val;
                        });
                        _convertJSON();
                      },
                      activeTrackColor: AppColors.kPrimaryLight,
                      activeColor: AppColors.kWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
