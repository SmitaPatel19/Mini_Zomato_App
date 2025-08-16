import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/menu_item.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../blocs/menu_mgmt_bloc/menu_mgmt_bloc.dart';
import '../blocs/menu_mgmt_bloc/menu_mgmt_event.dart';
import '../blocs/menu_mgmt_bloc/menu_mgmt_state.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantId = context.read<AuthRepository>().currentRestaurantId!;
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Management')),
      body: BlocBuilder<MenuMgmtBloc, MenuMgmtState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuLoaded) {
            final items = state.menuItems;
            if (items.isEmpty)
              return const Center(child: Text('No menu items yet'));
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    '₹${item.price} • ${item.isAvailable ? 'Available' : 'Unavailable'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showItemDialog(
                            context,
                            restaurantId,
                            isEdit: true,
                            item: item,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<MenuMgmtBloc>().add(
                            DeleteMenuItem(restaurantId, item.id),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is MenuError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final restaurantId = context
              .read<AuthRepository>()
              .currentRestaurantId!;
          _showItemDialog(context, restaurantId);
        },
      ),
    );
  }

  void _showItemDialog(
    BuildContext context,
    String restaurantId, {
    bool isEdit = false,
    MenuItem? item,
  }) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(
      text: item?.price.toString() ?? '',
    );
    bool availability = item?.isAvailable ?? true;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Item' : 'Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                title: const Text('Available'),
                value: availability,
                onChanged: (val) {
                  availability = val;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newItem = MenuItem(
                  id: isEdit ? item!.id : '',
                  restaurantId: restaurantId,
                  name: nameController.text.trim(),
                  price: double.parse(priceController.text),
                  isAvailable: availability,
                );
                if (isEdit) {
                  context.read<MenuMgmtBloc>().add(
                    UpdateMenuItem(restaurantId, newItem.id, newItem),
                  );
                } else {
                  context.read<MenuMgmtBloc>().add(
                    AddMenuItem(restaurantId, newItem),
                  );
                }
                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
