import 'package:flutter/material.dart';
import 'serverDataControl.dart';
import 'addEditProduct.dart';
import 'productTemplateList.dart'; // Добавляем импорт нового экрана

class ProductList extends StatefulWidget {
  final int groupId;
  final String groupName;

  const ProductList({super.key, required this.groupId, required this.groupName});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final products = await ServerDataControl.getProducts(widget.groupId);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product['name'] ?? 'Без названия'),
            subtitle: Text('Годен до: ${product['expirationDate'] ?? 'Не указано'} '),
            trailing: Text(product['status'] ?? ''),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditProduct(
                    groupId: widget.groupId,
                    product: product,
                  ),
                ),
              );
              if (result != null) {
                _fetchProducts();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Изменяем нажатие кнопки для открытия списка шаблонов
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductTemplateList(groupId: widget.groupId),
            ),
          );
          if (result != null) {
            _fetchProducts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
