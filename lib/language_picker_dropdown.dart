import 'package:flutter/material.dart';

import 'languages.dart';
import 'utils/typedefs.dart';

///Provides a customizable [DropdownButton] for all languages
class LanguagePickerDropdown extends StatefulWidget {
  LanguagePickerDropdown({
    required this.itemBuilder,
    required this.initialValue,
    required this.onValuePicked,
    required this.languagesList,
  });

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and phoneCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final ItemBuilder itemBuilder;

  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in languagesList map of languages.dart file.
  final String initialValue;

  ///This function will be called whenever a Language item is selected.
  final ValueChanged<Language?> onValuePicked;

  /// List of languages available in this picker.
  final List<Language> languagesList;

  @override
  _LanguagePickerDropdownState createState() => _LanguagePickerDropdownState();
}

class _LanguagePickerDropdownState extends State<LanguagePickerDropdown> {
  late List<Language> _languages;
  Language? _selectedLanguage;

  @override
  void initState() {
    _languages = widget.languagesList;
    if (widget.initialValue != null) {
      try {
        _selectedLanguage = _languages
            .where((language) =>
                language.isoCode == widget.initialValue)
            .toList()[0];
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    } else {
      _selectedLanguage = _languages[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Language>> items = _languages
        .map((language) => DropdownMenuItem<Language>(
            value: language,
            child: widget.itemBuilder != null
                ? widget.itemBuilder(language)
                : _buildDefaultMenuItem(language)))
        .toList();

    return Row(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<Language>(
            isDense: true,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
                widget.onValuePicked(value);
              });
            },
            items: items,
            value: _selectedLanguage,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultMenuItem(Language language) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8.0,
        ),
        Text("${language.name} (${language.isoCode})"),
      ],
    );
  }
}
