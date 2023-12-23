import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  const ImageDialog(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Hero(
        tag: 'avatarTag',
        child: AvatarContainer(
          size: 200,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

class NetImage extends StatelessWidget {
  final String imageUrl;
  NetImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Center(
          child: Text(
            'Error loading image',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}

class AvatarContainer extends StatelessWidget {
  final double size;
  final String imageUrl;

  AvatarContainer({required this.size, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Color.fromARGB(
          255, 179, 123, 231), // Replace with your desired background color
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}
