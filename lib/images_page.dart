import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' show decodeImage;

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  List<ImageInfo> images = [];
  double totalHeight = 0;

  final List<String> _imagePaths =
      List.generate(52, (index) => 'images/$index.png');

  @override
  void initState() {
    imageCache.maximumSize = 0;
    imageCache.maximumSizeBytes = 0;

    getImageInfos();

    super.initState();
  }

  @override
  void dispose() {
    imageCache.clear();
    imageCache.clearLiveImages();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        alignment: Alignment.center,
        constrained: false,
        child: images.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: totalHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: images
                          .map(
                            (img) => Image.asset(
                              img.assetPath,
                              width: img.width,
                              height: img.height,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('back'),
      ),
    );
  }

  getImageInfos() async {
    List<ImageInfo> imageInfos = [];
    for (var path in _imagePaths) {
      Size size = await getImageSize(path) ?? Size.zero;
      final info = ImageInfo(
        assetPath: path,
        width: size.width,
        height: size.height,
      );
      imageInfos.add(info);
    }

    if (!mounted) return;
    setState(() {
      images = imageInfos;
      totalHeight = imageInfos.fold(0, (sum, img) => sum + img.height);
    });
  }

  Future<Size?> getImageSize(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    final img = decodeImage(data.buffer.asUint8List());
    assert(img != null);
    if (img == null) return null;

    return Size(img.width.toDouble(), img.height.toDouble());
  }
}

class ImageInfo {
  final String assetPath;

  final double width;
  final double height;

  ImageInfo({
    required this.assetPath,
    required this.width,
    required this.height,
  });
}
