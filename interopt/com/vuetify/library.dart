@JS()
library library;

import "package:js/js.dart";
import "colors.dart" show Colors;
import '../vue.mod.dart' show ComponentOptions;
import '../vuetify.dart' show Vuetify;


// Module vuetify/lib
@JS("vuetify/lib.Vuetify")
external Vuetify get vuetify;

@JS("vuetify/lib.colors")
external Colors get colors;

@JS("vuetify/lib.directives")
external dynamic/*{
    ClickOutside: DirectiveOptions,
    Ripple: DirectiveOptions,
    Resize: DirectiveOptions,
    Scroll: DirectiveOptions,
    Touch: DirectiveOptions
  }*/
get directives;

@JS("vuetify/lib.VAlert")
external ComponentOptions get VAlert;

@JS("vuetify/lib.VApp")
external ComponentOptions get VApp;

@JS("vuetify/lib.VAutocomplete")
external ComponentOptions get VAutocomplete;

@JS("vuetify/lib.VAvatar")
external ComponentOptions get VAvatar;

@JS("vuetify/lib.VBadge")
external ComponentOptions get VBadge;

@JS("vuetify/lib.VBottomNav")
external ComponentOptions get VBottomNav;

@JS("vuetify/lib.VBottomSheet")
external ComponentOptions get VBottomSheet;

@JS("vuetify/lib.VBottomSheetTransition")
external ComponentOptions get VBottomSheetTransition;

@JS("vuetify/lib.VBreadcrumbs")
external ComponentOptions get VBreadcrumbs;

@JS("vuetify/lib.VBreadcrumbsDivider")
external ComponentOptions get VBreadcrumbsDivider;

@JS("vuetify/lib.VBreadcrumbsItem")
external ComponentOptions get VBreadcrumbsItem;

@JS("vuetify/lib.VBtn")
external ComponentOptions get VBtn;

@JS("vuetify/lib.VBtnToggle")
external ComponentOptions get VBtnToggle;

@JS("vuetify/lib.VCard")
external ComponentOptions get VCard;

@JS("vuetify/lib.VCardActions")
external ComponentOptions get VCardActions;

@JS("vuetify/lib.VCardMedia")
external ComponentOptions get VCardMedia;

@JS("vuetify/lib.VCardText")
external ComponentOptions get VCardText;

@JS("vuetify/lib.VCardTitle")
external ComponentOptions get VCardTitle;

@JS("vuetify/lib.VCarousel")
external ComponentOptions get VCarousel;

@JS("vuetify/lib.VCarouselItem")
external ComponentOptions get VCarouselItem;

@JS("vuetify/lib.VCarouselReverseTransition")
external ComponentOptions get VCarouselReverseTransition;

@JS("vuetify/lib.VCarouselTransition")
external ComponentOptions get VCarouselTransition;

@JS("vuetify/lib.VCheckbox")
external ComponentOptions get VCheckbox;

@JS("vuetify/lib.VChip")
external ComponentOptions get VChip;

@JS("vuetify/lib.VCombobox")
external ComponentOptions get VCombobox;

@JS("vuetify/lib.VContainer")
external ComponentOptions get VContainer;

@JS("vuetify/lib.VContent")
external ComponentOptions get VContent;

@JS("vuetify/lib.VCounter")
external ComponentOptions get VCounter;

@JS("vuetify/lib.VDataIterator")
external ComponentOptions get VDataIterator;

@JS("vuetify/lib.VDataTable")
external ComponentOptions get VDataTable;

@JS("vuetify/lib.VDatePicker")
external ComponentOptions get VDatePicker;

@JS("vuetify/lib.VDatePickerDateTable")
external ComponentOptions get VDatePickerDateTable;

@JS("vuetify/lib.VDatePickerHeader")
external ComponentOptions get VDatePickerHeader;

@JS("vuetify/lib.VDatePickerMonthTable")
external ComponentOptions get VDatePickerMonthTable;

@JS("vuetify/lib.VDatePickerTitle")
external ComponentOptions get VDatePickerTitle;

@JS("vuetify/lib.VDatePickerYears")
external ComponentOptions get VDatePickerYears;

@JS("vuetify/lib.VDialog")
external ComponentOptions get VDialog;

@JS("vuetify/lib.VDialogBottomTransition")
external ComponentOptions get VDialogBottomTransition;

@JS("vuetify/lib.VDialogTransition")
external ComponentOptions get VDialogTransition;

@JS("vuetify/lib.VDivider")
external ComponentOptions get VDivider;

@JS("vuetify/lib.VEditDialog")
external ComponentOptions get VEditDialog;

@JS("vuetify/lib.VExpandTransition")
external ComponentOptions get VExpandTransition;

@JS("vuetify/lib.VExpansionPanel")
external ComponentOptions get VExpansionPanel;

@JS("vuetify/lib.VExpansionPanelContent")
external ComponentOptions get VExpansionPanelContent;

@JS("vuetify/lib.VFabTransition")
external ComponentOptions get VFabTransition;

@JS("vuetify/lib.VFadeTransition")
external ComponentOptions get VFadeTransition;

@JS("vuetify/lib.VFlex")
external ComponentOptions get VFlex;

@JS("vuetify/lib.VFooter")
external ComponentOptions get VFooter;

@JS("vuetify/lib.VForm")
external ComponentOptions get VForm;

@JS("vuetify/lib.VHover")
external ComponentOptions get VHover;

@JS("vuetify/lib.VIcon")
external ComponentOptions get VIcon;

@JS("vuetify/lib.VImg")
external ComponentOptions get VImg;

@JS("vuetify/lib.VInput")
external ComponentOptions get VInput;

@JS("vuetify/lib.VItem")
external ComponentOptions get VItem;

@JS("vuetify/lib.VItemGroup")
external ComponentOptions get VItemGroup;

@JS("vuetify/lib.VJumbotron")
external ComponentOptions get VJumbotron;

@JS("vuetify/lib.VLabel")
external ComponentOptions get VLabel;

@JS("vuetify/lib.VLayout")
external ComponentOptions get VLayout;

@JS("vuetify/lib.VList")
external ComponentOptions get VList;

@JS("vuetify/lib.VListGroup")
external ComponentOptions get VListGroup;

@JS("vuetify/lib.VListTile")
external ComponentOptions get VListTile;

@JS("vuetify/lib.VListTileAction")
external ComponentOptions get VListTileAction;

@JS("vuetify/lib.VListTileActionText")
external ComponentOptions get VListTileActionText;

@JS("vuetify/lib.VListTileAvatar")
external ComponentOptions get VListTileAvatar;

@JS("vuetify/lib.VListTileContent")
external ComponentOptions get VListTileContent;

@JS("vuetify/lib.VListTileSubTitle")
external ComponentOptions get VListTileSubTitle;

@JS("vuetify/lib.VListTileTitle")
external ComponentOptions get VListTileTitle;

@JS("vuetify/lib.VMenu")
external ComponentOptions get VMenu;

@JS("vuetify/lib.VMenuTransition")
external ComponentOptions get VMenuTransition;

@JS("vuetify/lib.VMessages")
external ComponentOptions get VMessages;

@JS("vuetify/lib.VNavigationDrawer")
external ComponentOptions get VNavigationDrawer;

@JS("vuetify/lib.VOverflowBtn")
external ComponentOptions get VOverflowBtn;

@JS("vuetify/lib.VPagination")
external ComponentOptions get VPagination;

@JS("vuetify/lib.VParallax")
external ComponentOptions get VParallax;

@JS("vuetify/lib.VPicker")
external ComponentOptions get VPicker;

@JS("vuetify/lib.VProgressCircular")
external ComponentOptions get VProgressCircular;

@JS("vuetify/lib.VProgressLinear")
external ComponentOptions get VProgressLinear;

@JS("vuetify/lib.VRadio")
external ComponentOptions get VRadio;

@JS("vuetify/lib.VRadioGroup")
external ComponentOptions get VRadioGroup;

@JS("vuetify/lib.VRangeSlider")
external ComponentOptions get VRangeSlider;

@JS("vuetify/lib.VRating")
external ComponentOptions get VRating;

@JS("vuetify/lib.VResponsive")
external ComponentOptions get VResponsive;

@JS("vuetify/lib.VRowExpandTransition")
external ComponentOptions get VRowExpandTransition;

@JS("vuetify/lib.VScaleTransition")
external ComponentOptions get VScaleTransition;

@JS("vuetify/lib.VScrollXReverseTransition")
external ComponentOptions get VScrollXReverseTransition;

@JS("vuetify/lib.VScrollXTransition")
external ComponentOptions get VScrollXTransition;

@JS("vuetify/lib.VScrollYReverseTransition")
external ComponentOptions get VScrollYReverseTransition;

@JS("vuetify/lib.VScrollYTransition")
external ComponentOptions get VScrollYTransition;

@JS("vuetify/lib.VSelect")
external ComponentOptions get VSelect;

@JS("vuetify/lib.VSlideXReverseTransition")
external ComponentOptions get VSlideXReverseTransition;

@JS("vuetify/lib.VSlideXTransition")
external ComponentOptions get VSlideXTransition;

@JS("vuetify/lib.VSlideYReverseTransition")
external ComponentOptions get VSlideYReverseTransition;

@JS("vuetify/lib.VSlideYTransition")
external ComponentOptions get VSlideYTransition;

@JS("vuetify/lib.VSlider")
external ComponentOptions get VSlider;

@JS("vuetify/lib.VSnackbar")
external ComponentOptions get VSnackbar;

@JS("vuetify/lib.VSpacer")
external ComponentOptions get VSpacer;

@JS("vuetify/lib.VSpeedDial")
external ComponentOptions get VSpeedDial;

@JS("vuetify/lib.VStepper")
external ComponentOptions get VStepper;

@JS("vuetify/lib.VStepperContent")
external ComponentOptions get VStepperContent;

@JS("vuetify/lib.VStepperHeader")
external ComponentOptions get VStepperHeader;

@JS("vuetify/lib.VStepperItems")
external ComponentOptions get VStepperItems;

@JS("vuetify/lib.VStepperStep")
external ComponentOptions get VStepperStep;

@JS("vuetify/lib.VSubheader")
external ComponentOptions get VSubheader;

@JS("vuetify/lib.VSwitch")
external ComponentOptions get VSwitch;

@JS("vuetify/lib.VSystemBar")
external ComponentOptions get VSystemBar;

@JS("vuetify/lib.VTab")
external ComponentOptions get VTab;

@JS("vuetify/lib.VTabItem")
external ComponentOptions get VTabItem;

@JS("vuetify/lib.VTabReverseTransition")
external ComponentOptions get VTabReverseTransition;

@JS("vuetify/lib.VTabTransition")
external ComponentOptions get VTabTransition;

@JS("vuetify/lib.VTableOverflow")
external ComponentOptions get VTableOverflow;

@JS("vuetify/lib.VTabs")
external ComponentOptions get VTabs;

@JS("vuetify/lib.VTabsItems")
external ComponentOptions get VTabsItems;

@JS("vuetify/lib.VTabsSlider")
external ComponentOptions get VTabsSlider;

@JS("vuetify/lib.VTextField")
external ComponentOptions get VTextField;

@JS("vuetify/lib.VTextarea")
external ComponentOptions get VTextarea;

@JS("vuetify/lib.VTimePicker")
external ComponentOptions get VTimePicker;

@JS("vuetify/lib.VTimePickerClock")
external ComponentOptions get VTimePickerClock;

@JS("vuetify/lib.VTimePickerTitle")
external ComponentOptions get VTimePickerTitle;

@JS("vuetify/lib.VTimeline")
external ComponentOptions get VTimeline;

@JS("vuetify/lib.VTimelineItem")
external ComponentOptions get VTimelineItem;

@JS("vuetify/lib.VToolbar")
external ComponentOptions get VToolbar;

@JS("vuetify/lib.VToolbarItems")
external ComponentOptions get VToolbarItems;

@JS("vuetify/lib.VToolbarSideIcon")
external ComponentOptions get VToolbarSideIcon;

@JS("vuetify/lib.VToolbarTitle")
external ComponentOptions get VToolbarTitle;

@JS("vuetify/lib.VTooltip")
external ComponentOptions get VTooltip;

@JS("vuetify/lib.VTreeview")
external ComponentOptions get VTreeview;

@JS("vuetify/lib.VTreeviewNode")
external ComponentOptions get VTreeviewNode;

@JS("vuetify/lib.VWindow")
external ComponentOptions get VWindow;

@JS("vuetify/lib.VWindowItem")
external ComponentOptions get VWindowItem; /* WARNING: export assignment not yet supported. */


// End module vuetify/lib
