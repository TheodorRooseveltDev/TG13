# Color Scheme Cleanup Plan

## Problem
Too much bright aqua (AppColors.bossAqua / AppColors.accentAqua) used everywhere. Should be primarily dark navy with bright blue only for subtle accents/shadows.

## Color Philosophy
- **Dark Navy (AppColors.deepNavy)**: Primary UI color for 95% of elements
- **Bright Aqua (AppColors.bossAqua/accentAqua)**: ONLY for shadows, glows, or very subtle background accents

## Files to Update

### Priority 1 - Add/Edit Screens (User is seeing these)
1. **add_trip_screen.dart** ✅ UPDATING NOW
   - Date/time picker themes → deepNavy
   - All form field icons → deepNavy  
   - All focused borders → deepNavy
   - Checkbox active color → deepNavy

2. **add_catch_screen.dart**
   - Form field focused borders → deepNavy
   - Dropdown selected color → deepNavy

3. **add_spot_screen.dart**
   - Dropdown selected color → deepNavy

### Priority 2 - Detail Screens
4. **trip_detail_screen.dart**
   - All icons → deepNavy
   - Upcoming trip indicators → deepNavy
   - Badges → deepNavy

5. **gear_detail_screen.dart**
   - All icons → deepNavy
   - Badges → deepNavy
   - Condition indicators → deepNavy

6. **catch_detail_screen.dart**
   - All icons → deepNavy

7. **spot_detail_screen.dart**
   - All icons → deepNavy
   - Star ratings → deepNavy

### Priority 3 - List Screens
8. **trips_screen.dart** ✅ ALREADY DONE
9. **gear_screen.dart** ✅ ALREADY DONE  
10. **catch_log_screen.dart**
    - FAB background → deepNavy
    - Filter chips → deepNavy
    - Checkboxes → deepNavy

11. **spots_screen.dart**
    - FAB background → deepNavy
    - Filter chips → deepNavy

### Priority 4 - Core Widgets
12. **app_bottom_nav.dart**
    - Active tab color → deepNavy
    - Active text color → deepNavy

13. **boss_button.dart**
    - Border/loader colors → deepNavy

14. **xp_bar.dart**
    - Can KEEP bright aqua for glow effect ✓

### Priority 5 - Special Dialogs (Can keep some bright aqua for celebration effect)
15. **achievement_unlock_dialog.dart** - Keep some bright aqua for excitement
16. **level_up_dialog.dart** - Keep some bright aqua for celebration

### Priority 6 - Other Screens
17. **stats_screen.dart** ✅ FILTER DONE, need stat cards
18. **settings_screen.dart** - Toggle switches
19. **home_screen.dart** - Card icons
20. **splash_screen.dart** - Can keep for brand identity

## Implementation Strategy
Start with add_trip_screen.dart since user is actively looking at it.
