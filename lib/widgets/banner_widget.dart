// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:shirt_avenue/services/banner_service.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner({super.key});

  @override
  _CustomBannerState createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  late Future<List<dynamic>> _banners;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    _banners = BannerService().fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _banners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No banners found.'));
        }

        return SizedBox(
          height: 150, // Altezza del banner ridotta
          child: PageView.builder(
            controller: _pageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final banner = snapshot.data![index];
              final imageUrl = 'http://10.11.11.135:1337' +
                  banner['attributes']['imgbanner']['data']['attributes']
                      ['formats']['small']['url'];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }

                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * 200,
                      width: Curves.easeInOut.transform(value) * 320,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // Aggiunta di padding orizzontale
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(30), // Bordi arrotondati
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
