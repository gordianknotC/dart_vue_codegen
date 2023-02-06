

import { DirectiveOptions, PluginFunction } from 'vue'
declare module 'vuetify/es5/directives' {
  const ClickOutside: DirectiveOptions
  const Ripple: DirectiveOptions
  const Resize: DirectiveOptions
  const Scroll: DirectiveOptions
  const Touch: DirectiveOptions

  export {
    ClickOutside,
    Ripple,
    Resize,
    Scroll,
    Touch
  }
}
