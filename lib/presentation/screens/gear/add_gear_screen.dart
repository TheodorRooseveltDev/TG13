import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/services/achievement_service.dart';
import '../../../providers/gear_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../../../data/models/gear_model.dart';
import '../../widgets/boss_button.dart';
import 'package:animate_do/animate_do.dart';

class AddGearScreen extends StatefulWidget {
  final GearModel? gear; // For editing

  const AddGearScreen({
    super.key,
    this.gear,
  });

  @override
  State<AddGearScreen> createState() => _AddGearScreenState();
}

class _AddGearScreenState extends State<AddGearScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _notesController = TextEditingController();
  final _priceController = TextEditingController();

  String _category = 'Rod';
  String _condition = 'Good';
  DateTime? _purchaseDate;
  bool _isLoading = false;

  final List<String> _categories = [
    'Rod',
    'Reel',
    'Lure',
    'Line',
    'Tackle',
    'Other',
  ];

  final List<String> _conditions = [
    'Poor',
    'Fair',
    'Good',
    'Excellent',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.gear != null) {
      _nameController.text = widget.gear!.name;
      _brandController.text = widget.gear!.brand;
      _notesController.text = widget.gear!.notes;
      _category = widget.gear!.category;
      _condition = widget.gear!.condition;
      _purchaseDate = widget.gear!.purchaseDate;
      if (widget.gear!.price != null) {
        _priceController.text = widget.gear!.price!.toStringAsFixed(2);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepNavy,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  Future<void> _saveGear() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final gearProvider = Provider.of<GearProvider>(context, listen: false);
      final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);

      final price = _priceController.text.isEmpty
          ? null
          : double.tryParse(_priceController.text);

      if (widget.gear != null) {
        // Update existing gear
        final updatedGear = widget.gear!.copyWith(
          name: _nameController.text.trim(),
          brand: _brandController.text.trim(),
          category: _category,
          condition: _condition,
          notes: _notesController.text.trim(),
          purchaseDate: _purchaseDate,
          price: price,
        );
        await gearProvider.updateGear(updatedGear);
      } else {
        // Create new gear
        final newGear = GearModel.create(
          name: _nameController.text.trim(),
          brand: _brandController.text.trim(),
          category: _category,
          condition: _condition,
          notes: _notesController.text.trim(),
          purchaseDate: _purchaseDate,
          price: price,
        );
        await gearProvider.addGear(newGear);
        
        // Award XP for adding gear (+5 XP)
        await appStateProvider.addXP(5);
        
        // Check and trigger achievements
        if (mounted) {
          await AchievementService.checkGearAchievements(context);
        }
        
        // Pop back to gear screen
        if (mounted) {
          Navigator.pop(context);
          
          // Show success message
          if (widget.gear == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gear added! +5 XP',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gear updated!',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving gear: $e',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.gear != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Gear' : 'Add Gear',
          style: AppTextStyles.headline2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Intro text
            FadeInDown(
              child: Text(
                isEditing ? 'Update your gear details' : 'Add new gear to your tackle box',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: _buildTextField(
                controller: _nameController,
                label: 'Gear Name *',
                hint: 'e.g., Shimano Baitcaster',
                icon: Icons.label,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Category dropdown
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildDropdown(
                value: _category,
                label: 'Category *',
                icon: Icons.category,
                items: _categories,
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Brand field
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: _buildTextField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g., Shimano, Penn, Rapala',
                icon: Icons.business,
              ),
            ),
            const SizedBox(height: 16),

            // Condition dropdown
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildDropdown(
                value: _condition,
                label: 'Condition *',
                icon: Icons.star,
                items: _conditions,
                onChanged: (value) {
                  setState(() {
                    _condition = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Purchase date
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: _buildDateField(),
            ),
            const SizedBox(height: 16),

            // Price field
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildTextField(
                controller: _priceController,
                label: 'Price',
                hint: 'e.g., 199.99',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Please enter a valid price';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Notes field
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: _buildTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Additional details, specs, maintenance notes...',
                icon: Icons.note,
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: BossButton(
                text: isEditing ? 'Update Gear' : 'Add Gear',
                onPressed: _isLoading ? () {} : () => _saveGear(),
                icon: isEditing ? Icons.save : Icons.add_circle,
              ),
            ),
            const SizedBox(height: 16),

            // Cancel button
            FadeInUp(
              delay: const Duration(milliseconds: 900),
              child: BossOutlineButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.deepNavy),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderSecondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.deepNavy, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.deepNavy),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderSecondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.deepNavy, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase Date',
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSecondary),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.deepNavy),
                const SizedBox(width: 12),
                Text(
                  _purchaseDate != null
                      ? '${_purchaseDate!.month}/${_purchaseDate!.day}/${_purchaseDate!.year}'
                      : 'Select purchase date',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _purchaseDate != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
