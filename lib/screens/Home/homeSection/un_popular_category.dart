/// Created by Amit Rawat on 11/10/2021.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphics_news/network/response/home_response.dart';

/// Created by Amit Rawat on 11/10/2021.
/*un popular categories data*/
class SectionUnPopularCategories extends StatelessWidget {
  List<Categories>? unpopularCategories;
  String dataKey;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  SectionUnPopularCategories(
      {Key? key, required this.unpopularCategories, required this.dataKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (unpopularCategories == null || unpopularCategories!.isEmpty) {
      return Container();
    }

    return Container();
  }
}
