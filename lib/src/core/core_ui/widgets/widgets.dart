// lib/src/core/core_ui/widgets/widgets.dart
// Barrel file para todos los widgets reutilizables de core_ui
// 
// REFACTORIZADO FASE 6:
// - Eliminadas duplicaciones y exports conflictivos
// - Organizado por categoría lógica
// - Mantiene la coherencia con la arquitectura V5

// ============================================================================
// FOUNDATION - Theme & Utils
// ============================================================================
export '../theme/app_colors.dart';
export '../theme/app_theme.dart';
export '../utils/form_validators.dart';

// ============================================================================
// EXTENSIONS & MIXINS
// ============================================================================
export '../extensions/build_context_extensions.dart';
export '../extensions/date_time_extensions.dart';
export '../extensions/string_extensions.dart';
export '../mixins/form_mixin.dart';
export '../mixins/snackbar_mixin.dart';

// ============================================================================
// LAYOUT & RESPONSIVE (Core Layout Widgets)
// ============================================================================
export 'responsive_layout.dart';
export 'adaptive_grid.dart';
export 'adaptive_spacing.dart';

// ============================================================================
// SCAFFOLDS (Page-level containers)
// ============================================================================
export 'scaffolds/strop_scaffold.dart';
export 'scaffolds/form_scaffold.dart';

// ============================================================================
// BUILDERS & STATE MANAGEMENT HELPERS
// ============================================================================
export 'builders/async_state_builder.dart';

// ============================================================================
// BANNERS (Informational overlays)
// ============================================================================
export 'banners/info_banner.dart';
export 'critical_banner.dart';
export 'banners/banner_info.dart';
export 'banners/action_confirmation_banner.dart';

// ============================================================================
// BADGES & STATUS INDICATORS
// ============================================================================
export 'badges/status_badge.dart';
export 'approval_badge.dart';
export 'role_badge.dart';

// ============================================================================
// BUTTONS
// ============================================================================
export 'buttons/app_button.dart';
export 'buttons/loading_button.dart';

// ============================================================================
// CARDS & CONTAINERS (Major content blocks)
// ============================================================================
export 'cards/app_card.dart';
export 'cards/reference_card.dart';
export 'cards/example_card.dart';
export 'section_card.dart';
export 'detail_card.dart';
export 'stats_card.dart' hide StatsCard;
export 'action_type_card.dart';
export 'selectable_card.dart';

// ============================================================================
// DIALOGS
// ============================================================================
export 'dialogs/confirm_dialog.dart';
export 'dialogs/dialog_actions.dart';
export 'loading_dialog.dart';

// ============================================================================
// FORMS (Form-related widgets)
// ============================================================================
export 'form_section.dart';
export 'forms/form_field_with_label.dart';
export 'forms/multi_image_picker.dart';
export 'forms/form_action_buttons.dart';
export 'forms/datetime_picker_field.dart';

// ============================================================================
// LISTS (List variants with built-in state management)
// ============================================================================
export 'lists/async_list_view.dart';
export 'lists/filterable_list_view.dart';
export 'lists/tabbed_list_view.dart';

// ============================================================================
// TILES & LIST ITEMS
// ============================================================================
export 'tiles/settings_tile.dart';
export 'tiles/info_list_tile.dart';
export 'info_row.dart';

// ============================================================================
// PHOTOS & MEDIA
// ============================================================================
export 'photos/photo_grid.dart';

// ============================================================================
// BASIC WIDGETS (Foundational, frequently used)
// ============================================================================
export 'app_error.dart';
export 'app_loading.dart';
export 'app_text_field.dart';
export 'avatar_with_initials.dart';
export 'empty_state.dart';
export 'filter_bottom_sheet.dart';
export 'user_selector_widget.dart';

// ============================================================================
// SPECIALIZED WIDGETS (Semantic/Domain-specific)
// ============================================================================
export 'headers/section_header.dart';
export 'timeline_event.dart';
export 'team_member_card.dart';
export 'team_list.dart';
export 'detail_header.dart';
export 'type_chip.dart';

