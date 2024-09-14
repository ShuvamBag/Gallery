import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery/widgets/searchbar.dart';
import '../models/image_model.dart';
import '../services/image_service.dart';
import 'full_screen_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<ImageModel> images = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _loadMoreImages();
      }
    });

    _searchController.addListener(() {
      if (searchQuery != _searchController.text) {
        setState(() {
          searchQuery = _searchController.text;
          images.clear();
          currentPage = 1;
          _loadImages();
        });
      }
    });
  }

  Future<void> _loadImages() async {
    setState(() => isLoading = true);
    List<ImageModel> fetchedImages =
        await ImageService.fetchImages(searchQuery, currentPage);
    setState(() {
      images.addAll(fetchedImages);
      isLoading = false;
    });
  }

  Future<void> _loadMoreImages() async {
    currentPage++;
    await _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tileWidth = 100;
    int crossAxisCount = (screenWidth / tileWidth).floor();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Image Gallery',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 24),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey, Colors.black87],
          ),
        ),
        child: Column(
          children: [
            Searchbar(controller: _searchController),
            Flexible(
              child: images.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 40.0),
                      child: StaggeredGridView.countBuilder(
                        controller: _scrollController,
                        crossAxisCount: crossAxisCount, // Total number of columns in the grid
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          var image = images[index];
                          return GestureDetector(
                            onTap: () => _openImageFullScreen(
                                context, image.largeImageUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl: image.previewUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2), // Makes items dynamic in height
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _openImageFullScreen(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }
}
