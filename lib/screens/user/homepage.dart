import "package:carousel_slider/carousel_slider.dart";
import 'package:coba/model/data_wisata.dart';
import 'package:coba/screens/user/category_page.dart';
import 'package:coba/screens/user/explore_page.dart';
import 'package:coba/screens/user/login_screen.dart';
import 'package:coba/screens/user/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../../services/firestore_service.dart';
import 'detail_page.dart';
import 'package:coba/screens/user/area_list_page.dart';
import 'package:coba/screens/user/notification_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController tabviewController;
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
    _pages = [
      HomeContent(tabviewController: tabviewController),
      const JelajahPage(),
      const WishlistPage(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    tabviewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    // Dapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 65 + bottomPadding, // Sesuaikan dengan padding bottom device
      margin: EdgeInsets.fromLTRB(
        screenWidth * 0.05, // 5% dari lebar layar
        0,
        screenWidth * 0.05, // 5% dari lebar layar
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Beranda'),
            _buildNavItem(1, Icons.explore_rounded, 'Jelajah'),
            _buildNavItem(2, Icons.bookmark_rounded, 'Wishlist'),
            _buildNavItem(3, Icons.person_rounded, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.red : Colors.grey[400],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}


class HomeContent extends StatefulWidget {
  final TabController tabviewController;

  const HomeContent({
    super.key,
    required this.tabviewController,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = '';

  // Fungsi pencarian
  Stream<List<DataWisata>> _getFilteredWisata() {
    return _firestoreService.getList<DataWisata>(
      collectionPath: 'data_wisata',
      fromMap: (doc) => DataWisata.fromDocument(doc),
    ).map((wisataList) {
      return wisataList.where((wisata) {
        final nameLower = wisata.nama.toLowerCase();
        final areaLower = wisata.area.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        return nameLower.contains(searchLower) || 
               areaLower.contains(searchLower);
      }).toList();
    });
  }

  // Update SearchBar dengan fungsi pencarian
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari wisata...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
  


  @override
  void initState() {
    super.initState();
  }

  int _currentCarouselIndex = 0;
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': 'assets/images/pusat_kota.png',
      'title': 'Kota Yogyakarta',
      'description': 'Jelajahi keindahan kota budaya'
    },
    {
      'image': 'assets/images/gunung_kidul.png',
      'title': 'Gunung Kidul',
      'description': 'Nikmati pesona alam pegunungan'
    },
    {
      'image': 'assets/images/kaliurang.png',
      'title': 'Kaliurang',
      'description': 'Sejuknya udara pegunungan Merapi'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/header_bg.webp'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button and Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                                              StreamBuilder<int>(
                          stream: _firestoreService.getTotalNotifications(),
                          builder: (context, snapshot) {
                            final totalNotifications = snapshot.data ?? 0;
                            
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.mark_email_unread),
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NotificationPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  if (totalNotifications > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$totalNotifications',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        )


                      ],
                    ),
                  ),

                  // Explore Text
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      'Explorea',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value; // Gunakan _searchQuery yang sudah ada
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari wisata...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Main Content Container
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildCarouselSection(),
                        _buildCategoryGrid(),
                        _buildTabView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildCarouselSection() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Area Populer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AreaListPage(), // Ganti dari LoginScreen ke AreaListPage
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_circle_right_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      CarouselSlider(
        options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          autoPlay: false, // Changed to false to remove auto-refresh
          aspectRatio: 16 / 9,
          enableInfiniteScroll: true,
          viewportFraction: 0.8,
          onPageChanged: (index, reason) {
            setState(() {
              _currentCarouselIndex = index;
            });
          },
        ),
        items: _carouselItems.map((item) => _buildCarouselItem(item)).toList(),
      ),
      _buildCarouselIndicators(),
    ],
  );

  
  
}

Widget _buildCarouselItem(Map<String, dynamic> item) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item['image'],
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item['description'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCarouselIndicators() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: _carouselItems.asMap().entries.map((entry) {
      return Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(
            _currentCarouselIndex == entry.key ? 0.9 : 0.4,
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildCategoryGrid() {
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.landscape, 'label': 'Alam', 'id': 'alam'},
      {'icon': Icons.shopping_bag, 'label': 'Shopping', 'id': 'shopping'},
      {'icon': Icons.restaurant, 'label': 'Kuliner', 'id': 'kuliner'},
      {'icon': Icons.museum, 'label': 'Budaya', 'id': 'budaya'},
      {'icon': Icons.beach_access, 'label': 'Pantai', 'id': 'pantai'},
      {'icon': Icons.park, 'label': 'Taman', 'id': 'taman'},
      {'icon': Icons.sports_esports, 'label': 'Hiburan', 'id': 'hiburan'},
      {'icon': Icons.event, 'label': 'Event', 'id': 'event'},
    ];

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        category: categories[index]['id'],
                        categoryName: categories[index]['label'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        categories[index]['icon'],
                        size: 30,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        categories[index]['label'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildTabView() {
    return Column(
      children: [
        TabBar(
          controller: widget.tabviewController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Populer"),
            Tab(text: "Rating"),
            Tab(text: "Baru"),
          ],
        ),
        SizedBox(
          height: 300,
          child: TabBarView(
              controller: widget.tabviewController,
              children: [
                StreamBuilder<List<DataWisata>>(
                  stream: _getFilteredWisata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
        
                    final wisataList = snapshot.data ?? [];
        
                    if (wisataList.isEmpty) {
                      return const Center(
                      child: Text('Tidak ada wisata yang ditemukan'),
                    );
                  }

                  return ListView.builder(
                    itemCount: wisataList.length,
                    itemBuilder: (context, index) => _buildDestinationCard(wisataList[index]),
                  );
                },
              ),
              StreamBuilder<List<DataWisata>>(
                stream: _firestoreService.getWisataByRating(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                  }

                  final wisataList = snapshot.data ?? [];

                    if (wisataList.isEmpty) {
                    return const Center(
                    child: Text('Belum ada data wisata'),
                    );
                   }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: wisataList.length,
                      itemBuilder: (context, index) {
                    final wisata = wisataList[index];
                    return _buildDestinationCard(wisata);
                      },
                  );
                },
              ),

              StreamBuilder<List<DataWisata>>(
                  stream: _firestoreService.getWisataTerbaru(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                  final wisataList = snapshot.data ?? [];

                     if (wisataList.isEmpty) {
                      return Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(Icons.update, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                        Text(
                          'Belum ada wisata baru\ndalam 7 hari terakhir',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                        ),
                          ],
                        ),
                      );
                    }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: wisataList.length,
                    itemBuilder: (context, index) {
                  return _buildDestinationCard(wisataList[index]);
                  },
                 );
                },
              ),

            ],
          ),

        ),
      ],
    );
  }

  Widget _buildDestinationList() {
    return StreamBuilder<List<DataWisata>>(
      stream: _firestoreService.getList<DataWisata>(
        collectionPath: 'data_wisata',
        fromMap: (doc) => DataWisata.fromDocument(doc),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final wisataList = snapshot.data ?? [];
        
        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: wisataList.length,
          itemBuilder: (context, index) {
            final wisata = wisataList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Handle destination tap
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          wisata.gambarUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      wisata.nama,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis, // Menambahkan ini
                                      maxLines: 1, // Menambahkan ini
                                    ),
                                  ),
                                  const SizedBox(width: 8), // Spacing antara nama dan rating
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          wisata.rating.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      wisata.area,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,  // Tambahkan ini
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

    Widget _buildDestinationCard(DataWisata wisata) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(wisata: wisata),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'wisata-${wisata.id}',
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      wisata.gambarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              wisata.nama,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  wisata.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wisata.deskripsi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class TabContent extends StatefulWidget {
  final Widget child;
  final String keyValue;

  const TabContent({
    required this.child,
    required this.keyValue,
    Key? key,
  }) : super(key: key);

  @override
  State<TabContent> createState() => _TabContentState();
}
class _TabContentState extends State<TabContent> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}