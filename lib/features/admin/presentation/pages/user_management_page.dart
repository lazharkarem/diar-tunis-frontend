import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/admin_navigation_wrapper.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/user_list_item.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminNavigationWrapper(
      title: 'User Management',
      currentIndex: 1,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Guests'),
                Tab(text: 'Hosts'),
                Tab(text: 'Admins'),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),

          // User list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserList('all'),
                _buildUserList('guest'),
                _buildUserList('host'),
                _buildUserList('admin'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(String userType) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 20, // Replace with actual data
      itemBuilder: (context, index) {
        return UserListItem(
          user: _getDummyUser(index, userType),
          onTap: () {
            _showUserDetailsDialog(context, index);
          },
          onEdit: () {
            _showEditUserDialog(context, index);
          },
          onDelete: () {
            _showDeleteConfirmation(context, index);
          },
        );
      },
    );
  }

  Map<String, dynamic> _getDummyUser(int index, String type) {
    return {
      'id': 'user_$index',
      'name': 'User ${index + 1}',
      'email': 'user${index + 1}@example.com',
      'userType': type == 'all' ? ['guest', 'host', 'admin'][index % 3] : type,
      'isVerified': index % 2 == 0,
      'joinDate': DateTime.now().subtract(Duration(days: index * 10)),
      'avatar': null,
    };
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Users'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Verified Only'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Active Only'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: const Text('Add user functionality would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User ${index + 1} Details'),
        content: const Text('User details would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User ${index + 1}'),
        content: const Text('Edit user functionality would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete User ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User ${index + 1} deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
