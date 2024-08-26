import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPage extends StatefulWidget {
  final String? url;
  final String? pdfPath;

  const PdfPage({Key? key, this.url, this.pdfPath}) : super(key: key);

  @override
  _PdfPage createState() => _PdfPage();
}

class _PdfPage extends State<PdfPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  PdfViewerController? _pdfViewerController;
  double zoomValue = 0;
  OverlayEntry? _overlayEntry;

  // final GlobalKey  _pdfViewerKey = GlobalKey();
  // final PdfViewerController _pdfViewerController = PdfViewerController();
  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController?.clearSelection();
          },
          // color: Colors.white,
          // elevation: 10,
          child: Text('Copy', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: WidgetColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('PDF Viewer',
            style: FontUtil.style(
                17, SizeWeight.SemiBold, context, WidgetColors.primaryColor)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.zoom_out,
              color: WidgetColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                if (zoomValue == 4)
                  zoomValue = 2;
                else
                  zoomValue = 0;
                _pdfViewerController!.zoomLevel = zoomValue;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.zoom_in,
              color: WidgetColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                if (zoomValue == 0)
                  zoomValue = 2;
                else if (zoomValue == 2) zoomValue = 4;
                _pdfViewerController!.zoomLevel = zoomValue;
              });
            },
          ),
          // IconButton(
          //     icon: const Icon(
          //       Icons.book,
          //       color: WidgetColors.greyColor,
          //       semanticLabel: 'Bookmark',
          //     ),
          //     onPressed: _pdfBookMark),
          // IconButton(
          //   icon: const Icon(
          //     Icons.bookmark,
          //     color: WidgetColors.primaryColor,
          //     semanticLabel: 'Bookmark',
          //   ),
          //   onPressed: () {
          //     _pdfViewerKey.currentState?.openBookmarkView();
          //   },
          // ),
        ],
      ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget.pdfPath != null
            ? SfPdfViewer.file(new File(widget.pdfPath!),
                // ? SfPdfViewer.file(
                //     new File(
                //         'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
                key: _pdfViewerKey,
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                scrollDirection: PdfScrollDirection.horizontal,
                // searchTextHighlightColor: Colors.red,
                otherSearchTextHighlightColor: Colors.red,
                controller: _pdfViewerController,
                canShowPaginationDialog: false,
                pageLayoutMode: PdfPageLayoutMode.single)
            : SfPdfViewer.network(
                //'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                '${widget.url}',
                key: _pdfViewerKey,
                enableDoubleTapZooming: false,
                enableTextSelection: true,

                scrollDirection: PdfScrollDirection.horizontal,
                // searchTextHighlightColor: Colors.red,

                otherSearchTextHighlightColor: Colors.red,
                controller: _pdfViewerController,
                canShowPaginationDialog: false,
                pageLayoutMode: PdfPageLayoutMode.single,
                onTextSelectionChanged:
                    (PdfTextSelectionChangedDetails details) {
                  if (details.selectedText == null && _overlayEntry != null) {
                    _overlayEntry!.remove();
                    _overlayEntry = null;
                  } else if (details.selectedText != null &&
                      _overlayEntry == null) {
                    _showContextMenu(context, details);
                  }
                },
              ),
      ),
    );
  }

  void _pdfBookMark() {
    print("_pdfBookMark");
    //Loads an existing PDF document
    PdfDocument document =
        PdfDocument(inputBytes: File(widget.pdfPath!).readAsBytesSync());

    if (document.bookmarks.count > 0) {
      for (int i = 0; i < document.bookmarks.count; i++) {
        if (document.bookmarks.contains(document.bookmarks[i])) {
          print("contains");
          document.bookmarks.remove(document.bookmarks[i].title);

//Saves the document
          File(widget.pdfPath!).writeAsBytes(document.saveSync());

//Disposes the document
          document.dispose();
          // (context as Element).markNeedsBuild();
        } else {
          print("does not contains");
          //Creates a document bookmark
          PdfBookmark bookmark = document.bookmarks.add('Page 1');

//Sets the destination page and location
          bookmark.destination =
              PdfDestination(document.pages[0], Offset(20, 20));

//Sets the bookmark color
          bookmark.color = PdfColor(255, 0, 0);

//Sets the text style
          bookmark.textStyle = [PdfTextStyle.bold];
          //Saves the document
          File(widget.pdfPath!).writeAsBytes(document.saveSync());

//Disposes the document
          document.dispose();
          // (context as Element).markNeedsBuild();
        }
      }
    } else {
      //Creates a document bookmark
      PdfBookmark bookmark = document.bookmarks.add('Page 1');

//Sets the destination page and location
      bookmark.destination = PdfDestination(document.pages[0], Offset(20, 20));

//Sets the bookmark color
      bookmark.color = PdfColor(255, 0, 0);

//Sets the text style
      bookmark.textStyle = [PdfTextStyle.bold];
      //Saves the document
      File(widget.pdfPath!).writeAsBytes(document.saveSync());

//Disposes the document
      document.dispose();
      // (context as Element).markNeedsBuild();
    }

//     //Loads an existing PDF document
//     PdfDocument document =
//         PdfDocument(inputBytes: File(widget.pdfPath!).readAsBytesSync());

// //Gets all the bookmarks
//     //Add bookmarks to the document.
//     document.bookmarks.clear();
//     PdfBookmark bookmark = document.bookmarks.add('Page 1')
//       ..destination = PdfDestination(document.pages.add(), Offset(20, 20));
// //check whether the specified bookmark present in the collection
//     bool contains = document.bookmarks.contains(bookmark);
//     if (contains == true) {
//       print("contains is true");
//       PdfBookmarkBase bookmarks = document.bookmarks;
// //Remove specified bookmark.
//       // bookmarks.remove('Page 1');
//     } else {
//       print("contains is false");
//       bookmark = document.bookmarks.add('Page 1');
//     }

//     print(document.bookmarks.count);
// //Save the document.
//     List<int> bytes = document.save();

// // //Removes bookmark by index
// //     bookmark.removeAt(1);

// // //Removes bookmark by bookmark name
// //     bookmark.remove('Page 1');

// // //Saves the document
// //     File('output.pdf').writeAsBytes(document.save());

// // //Disposes the document
// //     document.dispose();

// // //Creates a document bookmark
// //     PdfBookmark bookmark = document.bookmarks.add('Page 1');

// // //Sets the destination page and location
// //     bookmark.destination = PdfDestination(document.pages[0], Offset(20, 20));

// // //Sets the bookmark color
// //     bookmark.color = PdfColor(255, 0, 0);

// // //Sets the text style
// //     bookmark.textStyle = [PdfTextStyle.bold];

// // //Saves the document
// //     File(widget.pdfPath!).writeAsBytes(document.save());

// //Disposes the document
//     document.dispose();
  }
}
