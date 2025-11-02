// lib/src/core/core_ui/widgets/widgets.dart
// Barrel file para todos los widgets reutilizables de core_ui
// 
// OPTIMIZADO - Arquitectura Clean + DDD
// - Estructura por carpetas semánticas
// - Eliminación de duplicaciones
// - Organización coherente y escalable

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
// LAYOUT & RESPONSIVE
// ============================================================================
export 'layouts/responsive_layout.dart';
export 'layouts/adaptive_grid.dart';
export 'layouts/adaptive_spacing.dart';

// ============================================================================
// SCAFFOLDS (Page-level containers)
// ============================================================================
export 'scaffolds/strop_scaffold.dart';
export 'scaffolds/form_scaffold.dart';

// ============================================================================
// BUILDERS & STATE MANAGEMENT
// ============================================================================
export 'builders/async_state_builder.dart';

// ============================================================================
// STATES (Loading, Error, Empty)
// ============================================================================
export 'states/app_error.dart';
export 'states/app_loading.dart';
export 'states/empty_state.dart';
export 'states/loading_placeholder.dart';

// ============================================================================
// BANNERS (Informational overlays)
// ============================================================================
export 'banners/info_banner.dart';
export 'banners/critical_banner.dart';
export 'banners/banner_info.dart';
export 'banners/action_confirmation_banner.dart';

// ============================================================================
// BADGES & CHIPS
// ============================================================================
export 'badges/status_badge.dart';
export 'badges/approval_badge.dart';
export 'badges/role_badge.dart';
export 'badges/type_chip.dart';

// ============================================================================
// BUTTONS
// ============================================================================
export 'buttons/app_button.dart';
export 'buttons/loading_button.dart';

// ============================================================================
// CARDS & CONTAINERS
// ============================================================================
export 'cards/app_card.dart';
export 'cards/reference_card.dart';
export 'cards/example_card.dart';
export 'cards/section_card.dart';
export 'cards/action_type_card.dart';
export 'cards/team_member_card.dart';

// ============================================================================
// DIALOGS & OVERLAYS
// ============================================================================
export 'dialogs/confirm_dialog.dart';
export 'dialogs/dialog_actions.dart';
export 'overlays/loading_dialog.dart';
export 'overlays/filter_bottom_sheet.dart';

// ============================================================================
// FORMS
// ============================================================================
export 'forms/form_section.dart';
export 'forms/form_field_with_label.dart';
export 'forms/multi_image_picker.dart';
export 'forms/form_action_buttons.dart';
export 'forms/datetime_picker_field.dart';

// ============================================================================
// INPUTS (Form inputs & selectors)
// ============================================================================
export 'inputs/app_text_field.dart';
export 'inputs/user_selector_widget.dart';

// ============================================================================
// LISTS (List widgets with state management)
// ============================================================================
export 'lists/async_list_view.dart';
export 'lists/filterable_list_view.dart';
export 'lists/tabbed_list_view.dart';
export 'lists/team_list.dart';

// ============================================================================
// TILES & LIST ITEMS
// ============================================================================
export 'tiles/settings_tile.dart';
export 'tiles/info_list_tile.dart';

// ============================================================================
// DISPLAYS (Information display widgets)
// ============================================================================
export 'displays/info_row.dart';

// ============================================================================
// PHOTOS & MEDIA
// ============================================================================
export 'photos/photo_grid.dart';

// ============================================================================
// HEADERS
// ============================================================================
export 'headers/section_header.dart';
export 'headers/detail_header.dart';

// ============================================================================
// TIMELINE
// ============================================================================
export 'timeline/timeline_event.dart';

// ============================================================================
// AVATARS
// ============================================================================
export 'avatars/avatar_with_initials.dart';

