import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/constants/app_constants.dart';
import 'package:big_boss_fishing/core/services/achievement_service.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/data/models/catch_model.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';

/// Add Catch Screen - Full form for logging a new catch
class AddCatchScreen extends StatefulWidget {
  const AddCatchScreen({super.key});

  @override
  State<AddCatchScreen> createState() => _AddCatchScreenState();
}

class _AddCatchScreenState extends State<AddCatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _speciesController = TextEditingController();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _locationController = TextEditingController();
  final _baitController = TextEditingController();
  final _techniqueController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSpecies = 'Bass';
  String _selectedWeather = 'Sunny';
  String _selectedBait = 'Worm';
  String _selectedTechnique = 'Casting';
  double _rating = 3.0;
  String? _photoPath;
  DateTime _selectedDateTime = DateTime.now();
  bool _isLoading = false;

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
    'Marlin',
    'Cod',
  ];

  final List<String> _weatherOptions = [
    'Sunny',
    'Partly Cloudy',
    'Cloudy',
    'Rainy',
    'Stormy',
    'Windy',
    'Foggy',
    'Snowy',
  ];

  final List<String> _baitOptions = [
    'Worm',
    'Minnow',
    'Artificial Lure',
    'Spinner',
    'Jig',
    'Fly',
    'Crank bait',
    'Spoon',
  ];

  final List<String> _techniqueOptions = [
    'Casting',
    'Trolling',
    'Fly Fishing',
    'Jigging',
    'Bottom Fishing',
    'Ice Fishing',
    'Surf Fishing',
  ];

  @override
  void dispose() {
    _speciesController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _locationController.dispose();
    _baitController.dispose();
    _techniqueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Show native iOS action sheet to choose between camera and gallery
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Add Photo'),
        message: const Text('Choose how you want to add a photo of your catch'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromSource(ImageSource.camera);
            },
            child: const Text('Take Photo'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromSource(ImageSource.gallery);
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

  Future<void> _pickImageFromSource(ImageSource source) async {
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
          'To add photos of your catches, please allow access to your ${isCamera ? 'camera' : 'photo library'} in Settings.',
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
              // Open app settings on iOS
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

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepNavy,
              onPrimary: AppColors.textLight,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.deepNavy,
                onPrimary: AppColors.textLight,
                surface: AppColors.cardBackground,
                onSurface: AppColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveCatch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final catchModel = CatchModel.create(
        species: _selectedSpecies,
        weight: double.parse(_weightController.text),
        length: double.parse(_lengthController.text),
        dateTime: _selectedDateTime,
        location: _locationController.text,
        weather: _selectedWeather,
        bait: _selectedBait,
        technique: _selectedTechnique,
        photoPath: _photoPath,
        notes: _notesController.text,
        rating: _rating.toInt(),
      );

      final catchProvider = context.read<CatchProvider>();
      await catchProvider.addCatch(catchModel);

      // Check and trigger achievements
      if (mounted) {
        await AchievementService.checkCatchAchievements(context, catchModel);
      }

      if (mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Catch logged! +${AppConstants.xpAddCatch} XP',
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
              'Error saving catch: $e',
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

  @override
  Widget build(BuildContext context) {
    final unitsSystem = context.read<AppStateProvider>().unitsSystem;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'LOG CATCH',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo section
              _buildPhotoSection(),

              const SizedBox(height: 24),

              // Species
              _buildSectionLabel('SPECIES'),
              _buildSpeciesDropdown(),

              const SizedBox(height: 24),

              // Weight and Length
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('WEIGHT'),
                        _buildTextField(
                          controller: _weightController,
                          hint: unitsSystem == 'imperial' ? 'lbs' : 'kg',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('LENGTH'),
                        _buildTextField(
                          controller: _lengthController,
                          hint: unitsSystem == 'imperial' ? 'inches' : 'cm',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Date & Time
              _buildSectionLabel('DATE & TIME'),
              _buildDateTimePicker(),

              const SizedBox(height: 24),

              // Location
              _buildSectionLabel('LOCATION'),
              _buildTextField(
                controller: _locationController,
                hint: 'Lake Michigan, Chicago, IL',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Weather
              _buildSectionLabel('WEATHER'),
              _buildWeatherSelector(),

              const SizedBox(height: 24),

              // Bait
              _buildSectionLabel('BAIT'),
              _buildBaitDropdown(),

              const SizedBox(height: 24),

              // Technique
              _buildSectionLabel('TECHNIQUE'),
              _buildTechniqueDropdown(),

              const SizedBox(height: 24),

              // Rating
              _buildSectionLabel('RATING'),
              _buildRatingBar(),

              const SizedBox(height: 24),

              // Notes
              _buildSectionLabel('NOTES'),
              _buildTextField(
                controller: _notesController,
                hint: 'Additional details about the catch...',
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              // Save button
              BossButton(
                text: 'LOG CATCH',
                onPressed: _saveCatch,
                isLoading: _isLoading,
                icon: Icons.check_rounded,
                width: double.infinity,
                height: 60,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(_photoPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add photo',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.deepNavy,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: AppColors.textLight,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add photo',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.inputHint,
        filled: true,
        fillColor: AppColors.cardBackground,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSpeciesDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecies,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cardBackground,
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
      items: _fishSpecies.map((species) {
        return DropdownMenuItem(
          value: species,
          child: Text(
            species,
            style: AppTextStyles.bodyMedium,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpecies = value!;
        });
      },
    );
  }

  Widget _buildDateTimePicker() {
    return GestureDetector(
      onTap: _selectDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSecondary),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: AppColors.deepNavy,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              '${_selectedDateTime.month}/${_selectedDateTime.day}/${_selectedDateTime.year} at ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.bodyMedium,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _weatherOptions.map((weather) {
        final isSelected = _selectedWeather == weather;
        return ChoiceChip(
          label: Text(weather),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedWeather = weather;
            });
          },
          selectedColor: AppColors.deepNavy,
          backgroundColor: AppColors.cardBackground,
          checkmarkColor: AppColors.textLight,
          surfaceTintColor: AppColors.deepNavy,
          shadowColor: Colors.transparent,
          labelStyle: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.textLight : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBaitDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBait,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSecondary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: _baitOptions.map((bait) {
        return DropdownMenuItem(
          value: bait,
          child: Text(bait, style: AppTextStyles.bodyMedium),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedBait = value!;
        });
      },
    );
  }

  Widget _buildTechniqueDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTechnique,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSecondary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: _techniqueOptions.map((technique) {
        return DropdownMenuItem(
          value: technique,
          child: Text(technique, style: AppTextStyles.bodyMedium),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTechnique = value!;
        });
      },
    );
  }

  Widget _buildRatingBar() {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 40,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star_rounded,
        color: AppColors.accentOrange,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
    );
  }
}
