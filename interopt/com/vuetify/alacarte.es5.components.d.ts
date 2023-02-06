import {ComponentOrPack} from 'vuetify';
import {VueConstructor} from 'vue';


declare module 'vuetify/es5/components/*' {
    const VuetifyComponent: {
        // FIX: The & VueConstructor is a lie.
        // This might not be a valid component.
        // But registering arbitrary objects as components is the status quo.
        default: ComponentOrPack & VueConstructor
        [key: string]: ComponentOrPack & VueConstructor
    };

    export = VuetifyComponent
}

