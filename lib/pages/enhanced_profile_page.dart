import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/employee.dart';
import '../providers/theme_provider.dart';

class EnhancedProfilePage extends StatefulWidget {
  final Employee employee;

  const EnhancedProfilePage({super.key, required this.employee});

  @override
  State<EnhancedProfilePage> createState() => _EnhancedProfilePageState();
}

class _EnhancedProfilePageState extends State<EnhancedProfilePage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _fabScaleAnimation;
  
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    );
    _cardSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutBack,
      ),
    );
    _fabScaleAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );

    _scrollController.addListener(_onScroll);
    
    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _toggleTheme() {
    HapticFeedback.mediumImpact();
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  void _changeAccentColor(Color color) {
    HapticFeedback.lightImpact();
    Provider.of<ThemeProvider>(context, listen: false).setAccentColor(color);
  }

  void _copyToClipboard(String text) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: text));
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        duration: const Duration(seconds: 2),
        backgroundColor: themeProvider.accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Theme(
          data: themeProvider.themeData,
          child: Scaffold(
            backgroundColor: themeProvider.backgroundColor,
            body: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildEnhancedSliverAppBar(themeProvider),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      AnimatedBuilder(
                        animation: _cardSlideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _cardSlideAnimation.value),
                            child: FadeTransition(
                              opacity: _cardAnimationController,
                              child: _buildModernQuickInfoCard(context, themeProvider),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _cardSlideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _cardSlideAnimation.value + 20),
                            child: FadeTransition(
                              opacity: _cardAnimationController,
                              child: _buildModernTabSection(context, themeProvider),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100), // Space for FAB
                    ]),
                  ),
                ),
              ],
            ),
            floatingActionButton: _buildCustomizationFAB(themeProvider),
          ),
        );
      },
    );
  }

  Widget _buildCustomizationFAB(ThemeProvider themeProvider) {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton(
        heroTag: "profile_theme_fab", // Unique hero tag
        onPressed: _showCustomizationMenu,
        backgroundColor: themeProvider.accentColor,
        child: const Icon(Icons.palette, color: Colors.white),
      ),
    );
  }

  void _showCustomizationMenu() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return _buildCustomizationSheet(themeProvider);
        },
      ),
    );
  }

  Widget _buildCustomizationSheet(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Customize Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.textColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Color(0xFF2A9D01),
              Colors.blue,
              Colors.purple,
              Colors.orange,
              Colors.red,
              Colors.teal,
            ].map((color) => GestureDetector(
              onTap: () => _changeAccentColor(color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeProvider.accentColor == color ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEnhancedSliverAppBar(ThemeProvider themeProvider) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: themeProvider.accentColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: [
        AnimatedBuilder(
          animation: _headerAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(_headerAnimation),
              child: IconButton(
                onPressed: _toggleTheme,
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _isScrolled ? widget.employee.fullName : '',
            key: ValueKey(_isScrolled),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        background: Stack(
          children: [
            // Animated gradient background
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeProvider.accentColor,
                        themeProvider.accentColor.withOpacity(0.8),
                        themeProvider.accentColor.withBlue((themeProvider.accentColor.blue + 30).clamp(0, 255)),
                      ],
                      stops: [
                        0.0,
                        0.5 + (_headerAnimation.value * 0.3),
                        1.0,
                      ],
                    ),
                  ),
                );
              },
            ),
            // Main content
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Floating profile picture with enhanced shadows
                  AnimatedBuilder(
                    animation: _headerAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -20 * _headerAnimation.value),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: themeProvider.accentColor.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: themeProvider.accentColor.withOpacity(0.1),
                              backgroundImage: widget.employee.profileImagePath != null 
                                  ? AssetImage(widget.employee.profileImagePath!) 
                                  : null,
                              child: widget.employee.profileImagePath == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: themeProvider.accentColor.withOpacity(0.7),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Name with animation
                  AnimatedBuilder(
                    animation: _headerAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _headerAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(_headerAnimation),
                          child: Text(
                            widget.employee.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Status badge with animation
                  AnimatedBuilder(
                    animation: _headerAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _headerAnimation,
                            curve: const Interval(0.5, 1.0),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: widget.employee.employeeStatus == 'Active' 
                                ? Colors.green.withOpacity(0.9)
                                : Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.employee.employeeStatus == 'Active' 
                                    ? Icons.check_circle 
                                    : Icons.cancel,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.employee.employeeStatus,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernQuickInfoCard(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeProvider.isDarkMode 
              ? [themeProvider.cardColor, themeProvider.cardColor.withOpacity(0.8)]
              : [Colors.white, Colors.grey[50]!],
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: themeProvider.accentColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: themeProvider.accentColor.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildModernQuickInfoItem(
                        icon: Icons.badge,
                        label: 'Employee ID',
                        value: widget.employee.employeeId,
                        color: Colors.blue,
                        textColor: themeProvider.textColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: themeProvider.accentColor.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _buildModernQuickInfoItem(
                        icon: Icons.work,
                        label: 'Department',
                        value: widget.employee.department,
                        color: Colors.orange,
                        textColor: themeProvider.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: themeProvider.accentColor.withOpacity(0.2),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildModernQuickInfoItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: widget.employee.emailAddress,
                        color: Colors.purple,
                        textColor: themeProvider.textColor,
                        onTap: () => _copyToClipboard(widget.employee.emailAddress),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: themeProvider.accentColor.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _buildModernQuickInfoItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: widget.employee.cellPhoneNumber,
                        color: Colors.green,
                        textColor: themeProvider.textColor,
                        onTap: () => _copyToClipboard(widget.employee.cellPhoneNumber),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernQuickInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon, 
                  color: color, 
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTabSection(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: themeProvider.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: themeProvider.accentColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TabBar(
                labelColor: themeProvider.accentColor,
                unselectedLabelColor: themeProvider.textColor.withOpacity(0.6),
                indicatorColor: themeProvider.accentColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Personal'),
                  Tab(text: 'Work'),
                  Tab(text: 'Contact'),
                  Tab(text: 'Other'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: TabBarView(
                children: [
                  _buildPersonalTab(context, themeProvider),
                  _buildWorkTab(context, themeProvider),
                  _buildContactTab(context, themeProvider),
                  _buildOtherTab(context, themeProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalTab(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: _buildModernInfoCard([
        _buildModernDetailRow(Icons.person, 'Full Name', widget.employee.fullName, themeProvider.textColor),
        _buildModernDetailRow(Icons.transgender, 'Gender', widget.employee.gender, themeProvider.textColor),
        _buildModernDetailRow(Icons.favorite, 'Marital Status', widget.employee.maritalStatus, themeProvider.textColor),
        _buildModernDetailRow(Icons.location_on, 'Birth Place', widget.employee.birthPlace, themeProvider.textColor),
        _buildModernDetailRow(Icons.cake, 'Birth Date', DateFormat('MMM dd, yyyy').format(widget.employee.birthDate), themeProvider.textColor),
      ], themeProvider.cardColor),
    );
  }

  Widget _buildWorkTab(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: _buildModernInfoCard([
        _buildModernDetailRow(Icons.badge, 'Employee ID', widget.employee.employeeId, themeProvider.textColor),
        _buildModernDetailRow(Icons.check_circle, 'Status', widget.employee.employeeStatus, themeProvider.textColor),
        _buildModernDetailRow(Icons.date_range, 'Hire Date', DateFormat('MMM dd, yyyy').format(widget.employee.hireDate), themeProvider.textColor),
        if (widget.employee.terminationDate != null)
          _buildModernDetailRow(Icons.event_busy, 'Termination Date', DateFormat('MMM dd, yyyy').format(widget.employee.terminationDate!), themeProvider.textColor),
        _buildModernDetailRow(Icons.business, 'Company', widget.employee.company, themeProvider.textColor),
        _buildModernDetailRow(Icons.group, 'Department', widget.employee.department, themeProvider.textColor),
        _buildModernDetailRow(Icons.work, 'Job Title', widget.employee.jobTitle, themeProvider.textColor),
        _buildModernDetailRow(Icons.schedule, 'Employee Type', widget.employee.employeeType, themeProvider.textColor),
      ], themeProvider.cardColor),
    );
  }

  Widget _buildContactTab(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: _buildModernInfoCard([
        _buildModernDetailRow(Icons.home, 'Home Address', widget.employee.homeAddress, themeProvider.textColor),
        _buildModernDetailRow(Icons.phone_in_talk, 'Home Phone', widget.employee.homePhoneNumber, themeProvider.textColor),
        _buildModernDetailRow(Icons.smartphone, 'Cell Phone', widget.employee.cellPhoneNumber, themeProvider.textColor),
        _buildModernDetailRow(Icons.email, 'Email Address', widget.employee.emailAddress, themeProvider.textColor),
      ], themeProvider.cardColor),
    );
  }

  Widget _buildOtherTab(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildModernInfoCard([
            _buildModernDetailRow(Icons.account_balance, 'Bank Name', widget.employee.bankName, themeProvider.textColor),
            _buildModernDetailRow(Icons.credit_card, 'Account No', widget.employee.accountNo, themeProvider.textColor),
            _buildModernDetailRow(Icons.person_outline, 'User Name', widget.employee.userName, themeProvider.textColor),
            _buildModernDetailRow(Icons.update, 'Last Updated', DateFormat('MMM dd, yyyy - HH:mm').format(widget.employee.lastUpdated), themeProvider.textColor),
          ], themeProvider.cardColor),
          const SizedBox(height: 16),
          _buildModernDocumentsCard(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildModernInfoCard(List<Widget> children, Color cardColor) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: themeProvider.accentColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: themeProvider.isDarkMode 
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: children),
        );
      },
    );
  }

  Widget _buildModernDetailRow(IconData icon, String label, String value, Color textColor) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: themeProvider.accentColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernDocumentsCard(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.accentColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.description, color: themeProvider.accentColor),
              ),
              const SizedBox(width: 12),
              Text(
                'Supported Documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.employee.supportedDocuments
                .map((document) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeProvider.accentColor.withOpacity(0.1),
                            themeProvider.accentColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: themeProvider.accentColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 16,
                            color: themeProvider.accentColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            document,
                            style: TextStyle(
                              color: themeProvider.accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
