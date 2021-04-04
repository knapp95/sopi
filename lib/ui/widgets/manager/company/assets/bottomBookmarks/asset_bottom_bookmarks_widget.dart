import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/models/assets/enums/assets_enum_bookmark.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

class AssetBottomBookmarksWidget extends StatefulWidget {
  @override
  _AssetBottomBookmarksWidgetState createState() =>
      _AssetBottomBookmarksWidgetState();
}


class _AssetBottomBookmarksWidgetState
    extends State<AssetBottomBookmarksWidget> {
  AssetsEnumBookmark _displayBookmarks = AssetsEnumBookmark.EMPLOYEES;

  void _changeDisplayBookmarks() {
    setState(() {
      _displayBookmarks = _displayBookmarks == AssetsEnumBookmark.EMPLOYEES
          ? AssetsEnumBookmark.TYPES
          : AssetsEnumBookmark.EMPLOYEES;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          _buildBottomBookmarks(
              'Employees', _displayBookmarks == AssetsEnumBookmark.EMPLOYEES),
          SizedBox(width: 5),
          _buildBottomBookmarks('Types', _displayBookmarks == AssetsEnumBookmark.TYPES),
        ],
      ),
      /// TODO  Expanded(child: AssetEmployeeListWidget(_employees)),
    );
  }

  Widget _buildBottomBookmarks(String title, bool selected) {
    return GestureDetector(
      onTap: _changeDisplayBookmarks,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: selected ? Colors.white : Colors.grey),
              ),
              if (selected)
                Row(
                  children: [
                    formSizedBoxWidth,
                    FaIcon(
                      FontAwesomeIcons.angleDoubleUp,
                      color: Colors.white,
                      size: 12,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
