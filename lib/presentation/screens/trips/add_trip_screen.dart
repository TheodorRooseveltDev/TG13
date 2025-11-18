import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/trip_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/gear_provider.dart';
import '../../../data/models/trip_model.dart';
import '../../widgets/boss_button.dart';
import 'package:animate_do/animate_do.dart';

class AddTripScreen extends StatefulWidget {
  final TripModel? trip; // For editing

  const AddTripScreen({
    super.key,
    this.trip,
  });

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _targetSpeciesController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 6, minute: 0);
  String _waterType = 'Lake';
  List<String> _selectedGear = [];
  bool _isLoading = false;

  final List<String> _waterTypes = [
    'Lake',
    'River',
    'Ocean',
    'Pond',
    'Stream',
    'Reservoir',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _destinationController.text = widget.trip!.destination;
      _targetSpeciesController.text = widget.trip!.targetSpecies;
      _notesController.text = widget.trip!.notes;
      _selectedDate = DateTime(
        widget.trip!.dateTime.year,
        widget.trip!.dateTime.month,
        widget.trip!.dateTime.day,
      );
      _selectedTime = TimeOfDay(
        hour: widget.trip!.dateTime.hour,
        minute: widget.trip!.dateTime.minute,
      );
      _waterType = widget.trip!.waterType;
      _selectedGear = List<String>.from(widget.trip!.gearChecklist);
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _targetSpeciesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepNavy,
              onPrimary: AppColors.deepNavy,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepNavy,
              onPrimary: AppColors.deepNavy,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _showGearSelector() async {
    final gearProvider = Provider.of<GearProvider>(context, listen: false);
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Gear',
                          style: AppTextStyles.headline5,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),
                  
                  // Gear list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: gearProvider.gear.length,
                      itemBuilder: (context, index) {
                        final gear = gearProvider.gear[index];
                        final isSelected = _selectedGear.contains(gear.id);
                        
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                _selectedGear.add(gear.id);
                              } else {
                                _selectedGear.remove(gear.id);
                              }
                            });
                          },
                          title: Text(gear.name),
                          subtitle: Text('${gear.category} • ${gear.brand}'),
                          activeColor: AppColors.deepNavy,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);

      // Combine date and time
      final tripDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      if (widget.trip != null) {
        // Update existing trip
        final updatedTrip = widget.trip!.copyWith(
          destination: _destinationController.text.trim(),
          dateTime: tripDateTime,
          waterType: _waterType,
          gearChecklist: _selectedGear,
          targetSpecies: _targetSpeciesController.text.trim(),
          notes: _notesController.text.trim(),
        );
        await tripProvider.updateTrip(updatedTrip);
      } else {
        // Create new trip
        final newTrip = TripModel.create(
          destination: _destinationController.text.trim(),
          dateTime: tripDateTime,
          waterType: _waterType,
          gearChecklist: _selectedGear,
          targetSpecies: _targetSpeciesController.text.trim(),
          notes: _notesController.text.trim(),
        );
        await tripProvider.addTrip(newTrip);
        
        // Award XP for planning a trip (+20 XP)
        await appStateProvider.addXP(20);
      }

      if (mounted) {
        Navigator.pop(context);
        
        // Show success message
        if (widget.trip == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Trip planned! +20 XP',
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
                'Trip updated!',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving trip: $e',
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
    final bool isEditing = widget.trip != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Trip' : 'Plan Trip',
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
                isEditing ? 'Update your trip details' : 'Plan your next fishing adventure',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 24),

            // Destination field
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: _buildTextField(
                controller: _destinationController,
                label: 'Destination *',
                hint: 'e.g., Lake Michigan, Smith Creek',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Date and Time
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Expanded(child: _buildDateField()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTimeField()),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Water type dropdown
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: _buildDropdown(
                value: _waterType,
                label: 'Water Type *',
                icon: Icons.water,
                items: _waterTypes,
                onChanged: (value) {
                  setState(() {
                    _waterType = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Target species
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildTextField(
                controller: _targetSpeciesController,
                label: 'Target Species',
                hint: 'e.g., Bass, Trout, Pike',
                icon: Icons.phishing,
              ),
            ),
            const SizedBox(height: 16),

            // Gear checklist
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: _buildGearChecklistField(),
            ),
            const SizedBox(height: 16),

            // Notes field
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Weather forecast, meeting point, things to remember...',
                icon: Icons.note,
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: BossButton(
                text: isEditing ? 'Update Trip' : 'Plan Trip',
                onPressed: _isLoading ? () {} : () => _saveTrip(),
                icon: isEditing ? Icons.save : Icons.add_circle,
              ),
            ),
            const SizedBox(height: 16),

            // Cancel button
            FadeInUp(
              delay: const Duration(milliseconds: 800),
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
          'Date *',
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
                const Icon(Icons.calendar_today, color: AppColors.deepNavy, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time *',
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSecondary),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.deepNavy, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedTime.format(context),
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGearChecklistField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gear Checklist',
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showGearSelector,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSecondary),
            ),
            child: Row(
              children: [
                const Icon(Icons.checklist, color: AppColors.deepNavy),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedGear.isEmpty
                        ? 'Select gear to bring'
                        : '${_selectedGear.length} items selected',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _selectedGear.isEmpty
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
