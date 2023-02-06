@JS()
library alacarte.es5.components;

import "package:js/js.dart";

// Module vuetify/es5/components/*
@JS("vuetify/es5/components/*.VuetifyComponent")
external dynamic
    /*{
        // FIX: The & VueConstructor is a lie.
        // This might not be a valid component.
        // But registering arbitrary objects as components is the status quo.
        default: ComponentOrPack & VueConstructor
        [key: string]: ComponentOrPack & VueConstructor
    }*/
    get VuetifyComponent; /* WARNING: export assignment not yet supported. */

// End module vuetify/es5/components/*
