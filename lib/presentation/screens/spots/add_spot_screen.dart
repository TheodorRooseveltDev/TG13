import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/constants/app_constants.dart';
import 'package:big_boss_fishing/core/services/achievement_service.dart';
import 'package:big_boss_fishing/providers/spot_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/data/models/spot_model.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';

/// Add Spot Screen - Form for adding new fishing spots
class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _depthNotesController = TextEditingController();
  final _accessNotesController = TextEditingController();

  String? _photoPath;
  String _waterType = 'Lake';
  String _bestTime = 'Morning';
  int _rating = 3;
  List<String> _selectedFish = [];
  bool _isLoading = false;

  final List<String> _waterTypes = [
    'Lake',
    'River',
    'Ocean',
    'Pond',
    'Stream',
    'Reservoir',
  ];

  final List<String> _timeOptions = [
    'Dawn',
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  final List<String> _fishSpecies = [
    'Bass',
    'Trout',
    'Pike',
    'Catfish',
    'Salmon',
    'Walleye',
    'Perch',
    'Carp',
    'Snapper',
    'Tuna',
    'Cod',
    'Marlin',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _depthNotesController.dispose();
    _accessNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Add Fishing Spot',
          style: AppTextStyles.heading5.copyWith(
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 24),
            _buildNameField(),
            const SizedBox(height: 20),
            _buildWaterTypeDropdown(),
            const SizedBox(height: 20),
            _buildBestTimeDropdown(),
            const SizedBox(height: 20),
            _buildRatingSection(),
            const SizedBox(height: 24),
            _buildCommonFishSection(),
            const SizedBox(height: 24),
            _buildDepthNotesField(),
            const SizedBox(height: 20),
            _buildAccessNotesField(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderSecondary,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: _photoPath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_photoPath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPhotoPlaceholder();
                  },
                ),
              )
            : _buildPhotoPlaceholder(),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_rounded,
          size: 64,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 12),
        Text(
          'TAP TO ADD PHOTO',
          style: AppTextStyles.buttonSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Optional',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _pickPhoto() async {
    // Show native iOS action sheet to choose between camera and gallery
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Add Photo'),
        message: const Text('Choose how you want to add a photo of this spot'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickPhotoFromSource(ImageSource.camera);
            },
            child: const Text('Take Photo'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickPhotoFromSource(ImageSource.gallery);
            },
            child: const Text('Choose from Library'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> _pickPhotoFromSource(ImageSource source) async {
    final picker = ImagePicker();
    try {
      // image_picker will automatically trigger native iOS permission dialog
      // when Info.plist contains the required permission keys
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _photoPath = image.path;
        });
      }
    } on PlatformException catch (e) {
      if (!mounted) return;

      // Handle permission denied or other platform errors
      if (e.code == 'camera_access_denied' || e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog(source);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not access ${source == ImageSource.camera ? 'camera' : 'photo library'}',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not access ${source == ImageSource.camera ? 'camera' : 'photo library'}',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showPermissionDeniedDialog(ImageSource source) {
    final isCamera = source == ImageSource.camera;
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(isCamera ? 'Camera Access Denied' : 'Photos Access Denied'),
        content: Text(
          'To add photos, please allow access to your ${isCamera ? 'camera' : 'photo library'} in Settings.',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAppSettings() async {
    // Use app-settings URL scheme to open iOS Settings for this app
    final uri = Uri.parse('app-settings:');
    try {
      await launchUrl(uri);
    } catch (e) {
      // Fallback: just close the dialog, user can manually open Settings
      debugPrint('Could not open settings: $e');
    }
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPOT NAME *',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'e.g., Crystal Lake North Shore',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a spot name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWaterTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WATER TYPE *',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _waterType,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: _waterTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type, style: AppTextStyles.bodyMedium),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _waterType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBestTimeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BEST FISHING TIME',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _bestTime,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: _timeOptions.map((time) {
            return DropdownMenuItem(
              value: time,
              child: Text(time, style: AppTextStyles.bodyMedium),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _bestTime = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPOT RATING',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = starIndex;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  starIndex <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 40,
                  color: starIndex <= _rating ? AppColors.accentOrange : AppColors.textSecondary,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCommonFishSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMMON FISH SPECIES',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _fishSpecies.map((fish) {
            final isSelected = _selectedFish.contains(fish);
            return FilterChip(
              label: Text(fish),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFish.add(fish);
                  } else {
                    _selectedFish.remove(fish);
                  }
                });
              },
              labelStyle: AppTextStyles.buttonSmall.copyWith(
                color: isSelected ? AppColors.textLight : AppColors.textPrimary,
              ),
              backgroundColor: AppColors.cardBackground,
              selectedColor: AppColors.deepNavy,
              checkmarkColor: AppColors.textLight,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDepthNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DEPTH & STRUCTURE NOTES',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _depthNotesController,
          decoration: InputDecoration(
            hintText: 'e.g., 10-20ft deep, rocky bottom, weed beds near shore',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAccessNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCESS & DIRECTIONS',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _accessNotesController,
          decoration: InputDecoration(
            hintText: 'e.g., Public boat ramp on east side, parking available',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return BossButton(
      text: 'SAVE SPOT',
      icon: Icons.save_rounded,
      onPressed: _isLoading ? () {} : _saveSpot,
      isLoading: _isLoading,
    );
  }

  Future<void> _saveSpot() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final spot = SpotModel.create(
        name: _nameController.text.trim(),
        waterType: _waterType,
        bestTime: _bestTime,
        depthNotes: _depthNotesController.text.trim(),
        commonFish: _selectedFish,
        accessNotes: _accessNotesController.text.trim(),
        photoPath: _photoPath,
        rating: _rating,
      );

      final spotProvider = context.read<SpotProvider>();
      final appStateProvider = context.read<AppStateProvider>();

      await spotProvider.addSpot(spot);

      // Award XP for adding a spot
      await appStateProvider.addXP(AppConstants.xpAddSpot);

      // Check and trigger achievements
      if (mounted) {
        await AchievementService.checkSpotAchievements(context);
      }

      if (mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Spot discovered! +${AppConstants.xpAddSpot} XP',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving spot: $e',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
            backgroundColor: AppColors.error,
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
}
