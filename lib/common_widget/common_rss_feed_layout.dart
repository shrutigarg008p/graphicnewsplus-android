// import 'package:flutter/cupertino.dart';

// class CommonRssFeedLayout extends StatelessWidget {
//   const CommonRssFeedLayout({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SizedBox(
//         height: response!.dATA!.topStory!.length > 4
//             ? 600
//             : response!.dATA!.topStory!.length > 2
//                 ? 400
//                 : 200,
//         child: GridView.builder(
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           itemCount: response!.dATA!.topStory!.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: response!.dATA!.topStory!.length > 4
//                 ? 3
//                 : response!.dATA!.topStory!.length > 2
//                     ? 2
//                     : 1,
//             childAspectRatio: 1.0,
//           ),
//           itemBuilder: (context, index) => GestureDetector(
//             onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => TopStoriesDetails(
//                           id: response!.dATA!.topStory![index].id,
//                         ))),
//             child: Container(
//               width: 220.0,
//               height: 230.0,
//               child: Card(
//                 elevation: 2.0,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       child: AspectRatio(
//                           aspectRatio: 220 / 125,
//                           child: UiUtil.setImageNetwork(
//                               response!.dATA!.topStory![index].contentImage,
//                               null,
//                               null)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, top: 3.0),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 6.0,
//                             ),
//                             Text(
//                               response!.dATA!.topStory![index].slug!,
//                               style: FontUtil.style(
//                                 10,
//                                 SizeWeight.Regular,
//                                 context,
//                                 WidgetColors.primaryColor,
//                               ),
//                               maxLines: 1,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             SizedBox(
//                               height: 6.0,
//                             ),
//                             Text(
//                               response!.dATA!.topStory![index].title!,
//                               style: FontUtil.style(
//                                   10, SizeWeight.SemiBold, context),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                               softWrap: true,
//                             ),
//                             SizedBox(
//                               height: 6.0,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 0.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     HomeCalanderIcon.home_calender,
//                                     color: Colors.grey,
//                                     size: 10.0,
//                                   ),
//                                   SizedBox(
//                                     width: 5.0,
//                                   ),
//                                   Expanded(
//                                       child: Text(
//                                     response!.dATA!.topStory![index].createdAt!,
//                                     style: FontUtil.style(
//                                         10,
//                                         SizeWeight.Regular,
//                                         context,
//                                         Colors.grey,
//                                         1.6),
//                                   ))
//                                 ],
//                               ),
//                             )
//                           ]),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
