import 'package:flutter/material.dart';
import 'serverDataControl.dart';
import 'package:intl/intl.dart';

class AddEditProduct extends StatefulWidget {
  final int groupId;
  final Map<String, dynamic>? product;

  const AddEditProduct({super.key, required this.groupId, this.product});

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _purchaseDateController;
  late TextEditingController _manufactureDateController;
  late TextEditingController _expirationDateController;
  late TextEditingController _quantityController;
  String _quality = 'годен';
  String _availability = 'есть';
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры с пустой строкой, если значение null
    _nameController = TextEditingController(text: widget.product?['name'] ?? '');
    _purchaseDateController = TextEditingController(text: widget.product?['purchaseDate'] ?? '');
    _manufactureDateController = TextEditingController(text: widget.product?['manufactureDate'] ?? '');
    _expirationDateController = TextEditingController(text: widget.product?['expirationDate'] ?? '');
    _quantityController = TextEditingController(text: (widget.product?['quantity'] ?? '').toString());
    _quality = widget.product?['quality'] ?? 'годен';
    _availability = widget.product?['availability'] ?? 'есть';
  }

  // Метод для показа DatePicker
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? initialDate;
    if (controller.text.isNotEmpty) {
      try {
        initialDate = _dateFormat.parse(controller.text);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = _dateFormat.format(picked); // Форматируем дату как ГГГГ-ММ-ДД
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Добавить продукт' : 'Редактировать продукт'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Название продукта'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название продукта';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _purchaseDateController,
              decoration: InputDecoration(
                labelText: 'Дата покупки',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _purchaseDateController),
                ),
              ),
              readOnly: true, // Делаем поле только для чтения
              onTap: () => _selectDate(context, _purchaseDateController),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, выберите дату покупки';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _manufactureDateController,
              decoration: InputDecoration(
                labelText: 'Дата изготовления',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _manufactureDateController),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _manufactureDateController),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, выберите дату изготовления';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _expirationDateController,
              decoration: InputDecoration(
                labelText: 'Срок годности',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _expirationDateController),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _expirationDateController),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, выберите срок годности';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Количество'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите количество';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _quality,
              decoration: const InputDecoration(labelText: 'Качество'),
              items: ['годен', 'не годен'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _quality = newValue!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _availability,
              decoration: const InputDecoration(labelText: 'Наличие'),
              items: ['есть', 'кончился'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _availability = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'name': _nameController.text.trim(),
        'purchaseDate': _purchaseDateController.text.trim(),
        'manufactureDate': _manufactureDateController.text.trim(),
        'expirationDate': _expirationDateController.text.trim(),
        'quantity': int.tryParse(_quantityController.text.trim()) ?? 0,
        'quality': _quality,
        'availability': _availability,
        'status': '', // Добавляем пустой статус для нового продукта
      };

      try {
        if (widget.product != null && widget.product!['id'] != null) {
          // Обновляем существующий продукт
          await ServerDataControl.updateProduct(
            widget.groupId,
            widget.product!['id'],
            productData,
          );
        } else {
          // Создаем новый продукт
          await ServerDataControl.addProduct(widget.groupId, productData);
        }
        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при сохранении продукта')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purchaseDateController.dispose();
    _manufactureDateController.dispose();
    _expirationDateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
