import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/asset_provider.dart';
import '../widgets/asset_dialogs.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        backgroundColor: const Color(0xFF2A9D01),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search assets...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(icon: Icon(Icons.inventory), text: 'All'),
                  Tab(icon: Icon(Icons.check_circle), text: 'Active'),
                  Tab(icon: Icon(Icons.schedule), text: 'Upcoming'),
                  Tab(icon: Icon(Icons.warning), text: 'Expired'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer<AssetProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2A9D01),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildAssetList(provider.searchAssets(_searchQuery), 'All Assets'),
              _buildAssetList(provider.activeAssets.where((asset) => 
                _searchQuery.isEmpty || _matchesSearch(asset, _searchQuery)).toList(), 'Active Assets'),
              _buildAssetList(provider.upcomingAssets.where((asset) => 
                _searchQuery.isEmpty || _matchesSearch(asset, _searchQuery)).toList(), 'Upcoming Assets'),
              _buildAssetList(provider.expiredAssets.where((asset) => 
                _searchQuery.isEmpty || _matchesSearch(asset, _searchQuery)).toList(), 'Expired Assets'),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2A9D01),
        onPressed: _showAssetDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Asset', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  bool _matchesSearch(Asset asset, String query) {
    final lowercaseQuery = query.toLowerCase();
    return asset.type.toLowerCase().contains(lowercaseQuery) ||
           asset.assetId.toLowerCase().contains(lowercaseQuery) ||
           asset.detail.toLowerCase().contains(lowercaseQuery) ||
           asset.notes.toLowerCase().contains(lowercaseQuery);
  }

  Widget _buildAssetList(List<Asset> assets, String title) {
    if (assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'No assets found' : 'No ${title.toLowerCase()}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Try different search terms'
                  : 'Tap the + button to add your first asset',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(asset.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(asset.type),
                        color: _getTypeColor(asset.type),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset.assetId,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            asset.type,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(asset.status),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showAssetDialog(asset: asset);
                            break;
                          case 'delete':
                            _deleteAsset(asset.id, asset.assetId);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFF2A9D01)),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Asset Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    asset.detail,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),

                // Date Information
                Row(
                  children: [
                    Expanded(
                      child: _buildDateInfo('Start Date', asset.startDate, Icons.play_arrow),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateInfo('End Date', asset.endDate, Icons.stop),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Notes
                if (asset.notes.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          asset.notes,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateInfo(String label, String date, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = const Color(0xFF2A9D01).withOpacity(0.1);
        textColor = const Color(0xFF2A9D01);
        break;
      case 'expired':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      case 'upcoming':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'laptop':
        return Icons.laptop_mac;
      case 'desktop computer':
        return Icons.desktop_mac;
      case 'monitor':
        return Icons.monitor;
      case 'mobile phone':
        return Icons.phone_android;
      case 'tablet':
        return Icons.tablet_mac;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      case 'headset':
        return Icons.headset;
      case 'webcam':
        return Icons.videocam;
      case 'printer':
        return Icons.print;
      case 'access card':
        return Icons.badge;
      case 'vehicle':
        return Icons.directions_car;
      case 'software license':
        return Icons.apps;
      case 'hardware tool':
        return Icons.build;
      default:
        return Icons.inventory;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'laptop':
      case 'desktop computer':
        return Colors.blue;
      case 'monitor':
        return Colors.purple;
      case 'mobile phone':
      case 'tablet':
        return Colors.green;
      case 'keyboard':
      case 'mouse':
        return Colors.orange;
      case 'headset':
      case 'webcam':
        return Colors.red;
      case 'printer':
        return Colors.brown;
      case 'access card':
        return Colors.indigo;
      case 'vehicle':
        return Colors.teal;
      case 'software license':
        return Colors.cyan;
      case 'hardware tool':
        return Colors.amber;
      default:
        return const Color(0xFF2A9D01);
    }
  }

  void _showAssetDialog({Asset? asset}) {
    showDialog(
      context: context,
      builder: (context) => AssetFormDialog(
        asset: asset,
        onSave: (asset) {
          final assetProvider = Provider.of<AssetProvider>(context, listen: false);
          if (asset.id.isNotEmpty && assetProvider.getAssetById(asset.id) != null) {
            // Update existing asset
            assetProvider.updateAsset(asset.id, asset);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Asset updated successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          } else {
            // Add new asset
            assetProvider.addAsset(asset);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Asset added successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          }
        },
      ),
    );
  }

  void _deleteAsset(String assetId, String assetName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete asset "$assetName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AssetProvider>(context, listen: false).deleteAsset(assetId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Asset deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
