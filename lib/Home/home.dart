import 'package:category/Model/model.dart';
import 'package:category/Service/service.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ApiResponse> futureApiResponse;
  String? selectedCategoryId;
  String? selectedCategoryTitle;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    futureApiResponse = ApiService().fetchProducts();
  }

  void _selectCategory(String categoryId, String categoryTitle) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedCategoryTitle = categoryTitle;
      currentPage = 1;
      futureApiResponse = ApiService().fetchProducts(categoryId: categoryId);
    });
  }

  void _loadMoreProducts() {
    setState(() {
      currentPage++;
      futureApiResponse = ApiService()
          .fetchProducts(categoryId: selectedCategoryId, page: currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 227, 185, 199),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://i.pinimg.com/736x/b2/36/fd/b236fd0e61a8440f8a9152a25acd25c1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            FutureBuilder<ApiResponse>(
              future: futureApiResponse,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.products == null) {
                  return const Center(child: Text('No data available'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.products.isEmpty) {
                  return const Center(
                      child: Text('No products available for this category'));
                } else {
                  final categories = snapshot.data!.categories ?? [];
                  final products = snapshot.data!.products ?? [];

                  return Column(
                    children: [
                      if (selectedCategoryTitle != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedCategoryTitle!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 150,
                        width: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () =>
                                  _selectCategory(category.id, category.title),
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 246, 172, 198),
                                  border: Border.all(
                                    color: category.isSelected
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(category.imageUrl,
                                          width: 50, height: 50),
                                      Text(category.title),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: products.isEmpty
                            ? const Center(child: Text('No products available'))
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return Card(
                                    color: const Color.fromARGB(
                                        255, 246, 172, 198),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.network(product.imageUrl,
                                            height: 100, fit: BoxFit.cover),
                                        Text(product.title),
                                        Text('\$${product.price}'),
                                        if (product.discountPrice > 0)
                                          Text('\$${product.discountPrice}',
                                              style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                        Text(
                                          product.status
                                              ? 'Available'
                                              : 'Unavailable',
                                          style: TextStyle(
                                              color: product.status
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {},
                                            child: Text('Add to Cart')),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      ElevatedButton(
                        onPressed: _loadMoreProducts,
                        child: const Text('Load More'),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
