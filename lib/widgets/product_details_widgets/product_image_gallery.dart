import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageGallery({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const SizedBox.shrink(); // Resim yoksa hiçbir şey gösterme
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4.0), // Resimler arasında hafif boşluk
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.imageUrls[index],
                    width: MediaQuery.of(context).size.width -
                        32, // Ekran genişliğine göre ayarlama
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: MediaQuery.of(context).size.width - 32,
                      height: 250,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image,
                          size: 80, color: Colors.grey[600]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12), // Galeri ile göstergeler arası boşluk
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imageUrls.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blue[600] : Colors.grey[300],
          ),
        );
      }),
    );
  }
}
