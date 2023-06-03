import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/ui/components/place_holder.dart';
import 'package:sizer/sizer.dart';

import '../../models/url_model.dart';

class UrlListItem extends StatelessWidget {
  final UrlModel urlModel;
  final Function(UrlModel) onEdit;
  final VoidCallback onDelete;
  final int index;

  const UrlListItem({
    required this.urlModel,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onEdit(urlModel);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          color: Colors.white70,
          elevation: 10,
          child: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 33.w,
                        maxHeight: 33.h,
                      ),
                      child: Image.network(
                        urlModel.imageUrl,
                        fit: BoxFit.cover, // Crop and center the image
                        errorBuilder: (context, error, stackTrace) {
                          // Handle the NetworkImageLoadException here
                          print('Image load failed: $error');
                          // Return a placeholder widget or a fallback image
                          return PlaceholderWidget(); // Replace with your desired widget
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            urlModel.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            urlModel.note,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 5.0,
                right: 5.0,
                child: GestureDetector(
                  onTap: () {
                    onDelete();
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
