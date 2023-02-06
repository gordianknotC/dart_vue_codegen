import {notify} from "../../src/lib/utils/common"
import {unsafe_uuid} from "../../src/lib/utils/common";

const MOCHA_PNG = require('../../src/assets/mocha.png')

let _global = typeof window == undefined
   ? global
   : window
try {
   if (mocha == undefined) {
      require('../../src/lib/com/mocha.js')
   }
} catch (e) {
   require('../../src/lib/com/mocha.js')
}
try {
   if (chai == undefined) {
      require('../../src/lib/com/chai.js')
   }
} catch (e) {
   require('../../src/lib/com/chai.js')
}


const watchDOM_OnChanged = (function () {
   let MutationObserver       = window.MutationObserver || window.WebKitMutationObserver,
       eventListenerSupported = window.addEventListener;
   
   return function (obj, callback) {
      if (MutationObserver) {
         // define a new observer
         let obs = new MutationObserver(function (mutations, observer) {
            if (mutations[0].addedNodes.length || mutations[0].removedNodes.length)
               callback();
         });
         // have the observer observe foo for changes in children
         obs.observe(obj, {childList: true, subtree: true});
      }
      else if (eventListenerSupported) {
         obj.addEventListener('DOMNodeInserted', callback, false);
         obj.addEventListener('DOMNodeRemoved', callback, false);
      }
   };
})()



mocha.suite.suites = [] //reset in browser
mocha.setup('bdd')      // setup bdd test behavior
mocha.timeout(10000)

const assert = chai.assert;
const expect = chai.expect;
const wait = async (t, div = 1) => new Promise((resolve) => {
   setTimeout(() => {
      resolve(true)
   }, t / div)
})
const mochaAsync = (fn) => {
   return done => {
      fn.call().then(done, err => {
         done(err);
      });
   };
};
const trace = (fn) => {
   return () => {
      try {
         fn.call()
      } catch (e) {
         let err = e //new Error(e)
         // console.error(err)
         throw err
      }
   }
}

function hidePassedSuites(keepRoot = false) {
   let titles = document.querySelectorAll('li.suite')
   Array.from(titles).forEach((title, i) => {
      let tests = title.querySelectorAll('li.test')
      if (Array.from(tests).filter(x => x.classList.contains('pass')).length === tests.length) {
         if (keepRoot) {
            title.querySelectorAll('li.test').forEach(x => {
               if (x.classList.contains('pass')) x.style.display = 'none'
            })
         } else {
            title.style.display = 'none'
         }
      }
   })
}

const NOTIFY_TAG = unsafe_uuid()


class MochaTestRunner {

}


class MochaHelper {
   static restoreCurrentResult() {
      let elt = document.querySelector('section#prevTestReport')
      let section = document.createElement('section')
      let _section
      if (!elt) {
         _section = document.createElement('section')
         _section.setAttribute('id', 'prevTestReport')
         document.querySelector('#mocha-report').parentElement.appendChild(_section)
         elt = _section
      }
      if (elt.querySelector(`section[data-url=${window.location}]`)) {
         section = elt.querySelector(`section[data-url=${window.location}]`)
      } else {
         section.setAttribute('data-url', window.location)
      }
      elt.appendChild(section)
      section.innerHTML = document.querySelector('#mocha-report').innerHTML
   }
   
   static nextTest() {
      if (MH.urls.length > MH.currentFlag + 1) {
         MH.restoreCurrentResult()
         MH.currentFlag += 1
         window.location.replace(MH.urls[MH.currentFlag])
      }
   }
   
   static addTestUrls(urls) {
      if (Array.isArray(urls)) {
         MH.urls.concat(urls)
      } else {
         MH.urls.push(urls)
      }
   }
   
   static stats() {
      if (MH._stats != null) return MH._stats
      MH._stats = document.querySelector('#mocha-stats')
      if (MH._stats == null) throw new Error('borswer not ready, try again later.')
      return MH._stats
   }
   
   static init(m) {
      if (MH.origin_run) return
      MH.mocha_run = m.run.bind(m)
      m.run = MH.run
   }
   
   static cloneStats() {
      let stats = MH.stats()
      let copied_stats = stats.cloneNode()
      copied_stats.innerHTML = stats.innerHTML
      copied_stats.style.visibility = 'hidden'
      copied_stats.style.position = 'relative'
      stats.insertAdjacentElement('afterend', copied_stats)
   }
   
   static showGrepInfo() {
      let stats = MH.stats()
      let search = location.search
      let heading = stats.querySelector('h4')
      if (search && search.slice(0, '?grep'.length) === '?grep') {
         let elt = heading ? heading : document.createElement('h4')
         elt.innerText = `scope:${decodeURIComponent(search.split('=')[1])}`
         if (!heading)
            stats.prepend(elt)
      }
   }
   
   static addNewTest({url, type}) {
      if (MH.registeredTests.find(x => x.url === url)) return
      MH.registeredTests.push({
         url, type
      })
   }
   
   static onTest(test) {
   }
   
   static onTestEnd(test) {
   }
   
   static onTestPassed(test) {
      let passed = test.parent.tests.filter(t => t.state === 'passed').length
      let suites, topSuites
      if (passed === test.parent.tests.length) {
         topSuites = Array.from(document.querySelectorAll('#mocha-report > li.suite:not(.hide)'))
         suites = Array.from(document.querySelectorAll('#mocha-report li.suite:not(.hide)')).filter(el => !topSuites.includes(el))
         if (suites.length)
            suites[suites.length - 1].classList.add('hide')
      }
   }
   
   static onTestFailed(test) {
      notify(test.title, {
         tag: NOTIFY_TAG,
         body: String(test.err.stack),
         icon: MOCHA_PNG,
         start_url: "http://localhost:8080/tests/animB?grep=Animation%20Test%20by%20validating%20inputs%2Foutputs",
      }, true)
      let errors = document.querySelectorAll('li.test.fail > pre.error')
      errors[errors.length - 1].innerText = test.err.stack.split(/[\n ]at/)[0]
      console.error("Mocha Test:\n", test.err.stack)
   }
   
   static onTestsCompleted() {
   }
   
   static onReportChanged() {
      let passes = document.querySelectorAll('#mocha-report > li.suite li.pass:not(.hide)')
      passes.forEach(pass => {
         setTimeout(() => {
            pass.classList.add('hide')
         }, 600)
      })
   }
   
   static clearMocha() {
      MH._stats = null
      document.querySelectorAll('#mocha-report').forEach(li => li.remove()) // clear
      document.querySelectorAll('#mocha-stats').forEach(li => li.remove()) // clear
   }
   
   static run({time, hidePass} = {time: 300, hidePass: false}) {
      let instance
      let passes = []
      MH.clearMocha()
      setTimeout(() => {
         instance = MH.mocha_run()
         MH.showGrepInfo()
         MH.cloneStats()
         instance
            .on('test', MH.onTest)
            .on('test end', MH.onTestEnd)
            .on('pass', MH.onTestPassed)
            .on('fail', MH.onTestFailed)
            .on('end', MH.onTestsCompleted);
         watchDOM_OnChanged(document.querySelector('#mocha-report'), MH.onReportChanged)
      }, time)
   }
}

const MH = MochaHelper
MH.urls = []
MH.currentFlag = 0
MH.prevTestResults = []
MH.registeredTests = []
MH.init(mocha)

MH.addNewTest({
   url: 'http://localhost:8080/tests/animB?grep=Animation Test by validating inputs/outputs',
   type: 'sync',
})

MH.addNewTest({
   url: 'http://localhost:8080/tests/animB?grep=Animation Tests by Animating it',
   type: 'async'
})

MH.addNewTest({
   url: 'http://localhost:8080/tests/animB?grep=Animation Tests by Animating it',
   type: 'async'
})


if (!assert._deepEqual) {
   assert._deepEqual = assert.deepEqual
   assert.deepEqual = (a, b, c = '') => {
      assert._deepEqual(a, b, c + ' expect ' + str(a) + ' to be ' + str(b) + '\n')
   }
}

assert.theSame = (actual, expect, message) => {
   let command = typeof actual === 'string'
      ? assert.equal
      : Array.isArray(actual)
         ? assert.sameMembers
         : assert.deepEqual
   return command(actual, expect, message)
}

assert.almostTheSame = (actual, expect, div, message) => {
   return typeof actual === 'string'
      ? assert.equal(actual, expect, message)
      : Array.isArray(actual)
         ? (actual, expect, div, message) => {
            actual.forEach((x, i) => {
               assert.closeTo(x, expect[i], div, message)
            })
         }
         : assert.closeTo(actual, expect, div, message)
}

assert.within = (value, l, r, message) => {
   return expect(value).to.within(l, r, message)
}
const str = (obj) => {
   if (obj && obj.name) return obj.name
   if (Array.isArray(obj) || typeof obj !== 'object') return JSON.stringify(obj)
   return String(obj)
}
export {
   mocha, assert, expect, mochaAsync, wait, trace, str, hidePassedSuites, chai
}





type TNotifyOptions = {
   body: string, icon: string, onclick: Function, onclose: Function, ondenied: Function
}

const NOTIFY_TITLES = new Set()
let notify          = function (title: string, options: TNotifyOptions, blockReplicate: boolean = false) {
   if (!window.Notification) {
      return
   }
   switch (Notification.permission) {
      case 'default':
         Notification.requestPermission(function () {
            title && notify(title, options);
         });
         break
      case 'granted':
         if (!title) return undefined;
         let opt = options || {}
         if (NOTIFY_TITLES.has(title) && blockReplicate) {
         } else {
            NOTIFY_TITLES.add(title)
            let n     = new Notification(title, opt);
            n.onclick = function () {
               opt.onclick && opt.onclick(this);
               this.close();
            };
            n.onclose = function () {
               opt.onclose && opt.onclose(this);
            };
            return n;
         }
      
      case 'denied':
         (options && options.ondenied) && options.ondenied(this);
         break
   }
};

