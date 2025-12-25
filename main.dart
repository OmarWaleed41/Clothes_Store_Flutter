import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  String name;
  String image;
  double price;
  String category;
  
  Product(this.name, this.image, this.price, this.category);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [
    Product('T-Shirt', '👕', 25.99, 'Men'),
    Product('Jeans', '👖', 49.99, 'Men'),
    Product('Dress', '👗', 39.99, 'Women'),
    Product('Handbag', '👜', 29.99, 'Women'),
    Product('Sneakers', '👟', 59.99, 'Men'),
    Product('Scarf', '🧣', 19.99, 'Women'),
    Product('Jacket', '🧥', 79.99, 'Men'),
    Product('Sunglasses', '🕶️', 34.99, 'Women'),
  ];
  
  List<Product> cart = [];
  List<Product> favorites = [];
  String currentCategory = 'All';
  
  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
    
    // Show message
    final snackBar = SnackBar(
      content: Text('Added ${product.name} to cart'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  void removeFromCart(int index) {
    String name = cart[index].name;
    setState(() {
      cart.removeAt(index);
    });
    
    // Show message
    final snackBar = SnackBar(
      content: Text('Removed $name from cart'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  void toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(products[index])) {
        favorites.remove(products[index]);
      } else {
        favorites.add(products[index]);
      }
    });
  }
  
  double getTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }
  
  List<Product> getProducts() {
    if (currentCategory == 'All') return products;
    return products.where((p) => p.category == currentCategory).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    List<Product> displayProducts = getProducts();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothes Store'),
        actions: [
          // Favorites button
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritePage(favorites: favorites)),
              );
            },
          ),
          // Cart button
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart, removeFromCart: removeFromCart, getTotal: getTotal)),
              );
            },
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Category buttons
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // All button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentCategory = 'All';
                    });
                  },
                  child: Text('All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentCategory == 'All' ? Colors.blue : Colors.grey,
                  ),
                ),
                // Men button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentCategory = 'Men';
                    });
                  },
                  child: Text('Men'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentCategory == 'Men' ? Colors.blue : Colors.grey,
                  ),
                ),
                // Women button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentCategory = 'Women';
                    });
                  },
                  child: Text('Women'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentCategory == 'Women' ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Product list
          Expanded(
            child: ListView.builder(
              itemCount: displayProducts.length,
              itemBuilder: (context, index) {
                Product product = displayProducts[index];
                bool isFavorite = favorites.contains(product);
                
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(product.image)),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price} - ${product.category}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Favorite button
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            int productIndex = products.indexOf(product);
                            toggleFavorite(productIndex);
                          },
                        ),
                        // Add to cart button
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            addToCart(product);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Go to detail page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPage(product: product, addToCart: () => addToCart(product))),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Product Detail Page
class DetailPage extends StatelessWidget {
  final Product product;
  final VoidCallback addToCart;
  
  DetailPage({required this.product, required this.addToCart});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(product.image, style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text(product.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('\$${product.price}', style: TextStyle(fontSize: 25, color: Colors.blue)),
            SizedBox(height: 10),
            Text('Category: ${product.category}'),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Text('This is a ${product.name}. High quality product.'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addToCart();
                Navigator.pop(context);
              },
              child: Text('Add to Cart', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
            ),
          ],
        ),
      ),
    );
  }
}

// Cart Page
class CartPage extends StatelessWidget {
  final List<Product> cart;
  final Function(int) removeFromCart;
  final double Function() getTotal;
  
  CartPage({required this.cart, required this.removeFromCart, required this.getTotal});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(child: Text('Cart is empty'))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      Product item = cart[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(item.image)),
                        title: Text(item.name),
                        subtitle: Text('\$${item.price}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            removeFromCart(index);
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (cart.isNotEmpty) Container(
            padding: EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\$${getTotal().toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Favorite Page
class FavoritePage extends StatelessWidget {
  final List<Product> favorites;
  
  FavoritePage({required this.favorites});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                Product item = favorites[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(item.image)),
                  title: Text(item.name),
                  subtitle: Text('\$${item.price} - ${item.category}'),
                );
              },
            ),
    );
  }
}
