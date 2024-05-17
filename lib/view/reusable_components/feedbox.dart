import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/device_size.dart';

class FeedBox extends StatelessWidget {
  final Post post;
  const FeedBox({super.key, required this.post});

  TextSpan createStyledTextSpan({
    required String self,
    required List<String> mentions,
  }) {
    // Define styles
    final TextStyle selfStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 11.5,
        fontFamily: CustomFont.poppins);
    final TextStyle mentionStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 11.5,
        fontFamily: CustomFont.poppins);
    final TextStyle normalStyle = TextStyle(
        color: Colors.black45, fontSize: 11.5, fontFamily: CustomFont.poppins);

    // Build the text span
    return TextSpan(
      children: [
        TextSpan(text: self, style: selfStyle),
        TextSpan(text: ' is with ', style: normalStyle),
        ...mentions.map((mention) => TextSpan(
              text: mention,
              style: mentionStyle,
              children: [TextSpan(text: '', style: normalStyle)],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://i.pinimg.com/564x/98/af/c9/98afc975433a4341a6fc0934d960feef.jpg"),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: RichText(
                  maxLines: 2,
                  // softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  text: createStyledTextSpan(
                      self: "Subhojeet Sahoo", mentions: ["Aradhana Roy"]),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            post.caption,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontFamily: CustomFont.poppins),
          ),
          const SizedBox(
            height: 8,
          ),
          (post.postList.isNotEmpty)
              ? Container(
                  height: displayHeight(context) * 0.45,
                  width: double.infinity,
                  // color: Colors.red.shade100,
                  child: StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    children: post.postList.map((postcontent) {
                      return StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            postcontent.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
