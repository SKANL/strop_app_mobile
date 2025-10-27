// lib/src/core/core_ui/widgets/widgets.dart
// Barrel file para todos los widgets reutilizables de core_ui

// Theme
export '../theme/app_colors.dart';
export '../theme/app_theme.dart';

// Widgets existentes
export 'app_error.dart';
export 'app_loading.dart';
export 'app_text_field.dart';
export 'avatar_with_initials.dart';
export 'empty_state.dart';
export 'info_row.dart';
export 'responsive_layout.dart';
export 'section_card.dart';
export 'status_badge.dart';

// Widgets nuevos refactorizados - Cards y UI
export 'action_type_card.dart';
export 'approval_badge.dart';
export 'filter_bottom_sheet.dart';
export 'form_section.dart';
export 'loading_dialog.dart';
export 'photo_grid.dart';
export 'selectable_card.dart';
export 'type_chip.dart';

// Widgets de responsividad y layout adaptativo
export 'adaptive_grid.dart';
export 'adaptive_spacing.dart';

// Widgets nuevos FASE 2 - Badges, Cards y Timeline
export 'role_badge.dart';
export 'critical_banner.dart';
export 'stats_card.dart' hide StatsCard; // Usar el de app_card.dart
export 'detail_card.dart';
export 'timeline_event.dart';
export 'team_member_card.dart';
export 'team_list.dart';
export 'detail_header.dart';

// Widgets nuevos SEMANA 1 - Form Widgets (Refactorización Masiva)
// Deprecated - usar exports individuales de forms/ y lists/
export 'form_widgets.dart' hide FormFieldWithLabel, MultiImagePicker, FormActionButtons;
export 'list_widgets.dart' hide AsyncValue, AsyncLoading, AsyncError, AsyncData, AsyncListView, FilterableListView, TabbedListView;

// Widgets nuevos SEMANA 3 - User Selection (Refactorización Masiva)
export 'user_selector_widget.dart';

// Widgets nuevos - Botones (Refactorización End-to-End)
export 'buttons/app_button.dart';
export 'buttons/loading_button.dart';

// Widgets nuevos - Cards (Refactorización End-to-End)
export 'cards/app_card.dart';

// Widgets nuevos - Banners (Refactorización End-to-End)
export 'banners/banner_info.dart';

// Widgets nuevos - Tiles (Refactorización End-to-End)
export 'tiles/settings_tile.dart';

// Widgets nuevos - Dialogs (Refactorización End-to-End)
export 'dialogs/dialog_actions.dart';

// Widgets nuevos - Forms (Refactorización End-to-End)
export 'forms/form_field_with_label.dart';
export 'forms/multi_image_picker.dart';
export 'forms/form_action_buttons.dart';
export 'forms/datetime_picker_field.dart';

// Widgets nuevos - Lists (Refactorización End-to-End)
export 'lists/async_list_view.dart';
export 'lists/filterable_list_view.dart';
export 'lists/tabbed_list_view.dart';
