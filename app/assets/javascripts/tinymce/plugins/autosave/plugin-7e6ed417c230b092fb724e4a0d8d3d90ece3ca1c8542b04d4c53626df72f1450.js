!function(){"use strict";function t(t){for(var e=[],n=1;n<arguments.length;n++)e[n-1]=arguments[n];return function(){for(var n=[],r=0;r<arguments.length;r++)n[r]=arguments[r];var o=e.concat(n);return t.apply(null,o)}}var e=function(t){var n=t,r=function(){return n};return{get:r,set:function(t){n=t},clone:function(){return e(r())}}},n=tinymce.util.Tools.resolve("tinymce.PluginManager"),r=tinymce.util.Tools.resolve("tinymce.util.LocalStorage"),o=tinymce.util.Tools.resolve("tinymce.util.Tools"),a=function(t,e){var n=t||e,r=/^(\d+)([ms]?)$/.exec(""+n);return(r[2]?{s:1e3,m:6e4}[r[2]]:1)*parseInt(n,10)},i=function(t){var e=t.getParam("autosave_prefix","tinymce-autosave-{path}{query}{hash}-{id}-");return(e=(e=(e=e.replace(/\{path\}/g,document.location.pathname)).replace(/\{query\}/g,document.location.search)).replace(/\{hash\}/g,document.location.hash)).replace(/\{id\}/g,t.id)},u=function(t,e){var n=t.settings.forced_root_block;return""===(e=o.trim(void 0===e?t.getBody().innerHTML:e))||new RegExp("^<"+n+"[^>]*>((\xa0|&nbsp;|[ \t]|<br[^>]*>)+?|)</"+n+">|<br>$","i").test(e)},s=function(t){var e=parseInt(r.getItem(i(t)+"time"),10)||0;return!((new Date).getTime()-e>a(t.settings.autosave_retention,"20m")&&(c(t,!1),1))},c=function(t,e){var n=i(t);r.removeItem(n+"draft"),r.removeItem(n+"time"),!1!==e&&t.fire("RemoveDraft")},f=function(t){var e=i(t);!u(t)&&t.isDirty()&&(r.setItem(e+"draft",t.getContent({format:"raw",no_events:!0})),r.setItem(e+"time",(new Date).getTime().toString()),t.fire("StoreDraft"))},l=function(t){var e=i(t);s(t)&&(t.setContent(r.getItem(e+"draft"),{format:"raw"}),t.fire("RestoreDraft"))},m=function(t,e){var n=a(t.settings.autosave_interval,"30s");e.get()||(setInterval(function(){t.removed||f(t)},n),e.set(!0))},v=function(t){t.undoManager.transact(function(){l(t),c(t)}),t.focus()},d=tinymce.util.Tools.resolve("tinymce.EditorManager");d._beforeUnloadHandler=function(){var t;return o.each(d.get(),function(e){e.plugins.autosave&&e.plugins.autosave.storeDraft(),!t&&e.isDirty()&&e.getParam("autosave_ask_before_unload",!0)&&(t=e.translate("You have unsaved changes are you sure you want to navigate away?"))}),t};var g=function(t,e){return function(n){var r=n.control;r.disabled(!s(t)),t.on("StoreDraft RestoreDraft RemoveDraft",function(){r.disabled(!s(t))}),m(t,e)}};n.add("autosave",function(n){var r,o,a,i=e(!1);return window.onbeforeunload=d._beforeUnloadHandler,o=i,(r=n).addButton("restoredraft",{title:"Restore last draft",onclick:function(){v(r)},onPostRender:g(r,o)}),r.addMenuItem("restoredraft",{text:"Restore last draft",onclick:function(){v(r)},onPostRender:g(r,o),context:"file"}),n.on("init",function(){n.getParam("autosave_restore_when_empty",!1)&&n.dom.isEmpty(n.getBody())&&l(n)}),{hasDraft:t(s,a=n),storeDraft:t(f,a),restoreDraft:t(l,a),removeDraft:t(c,a),isEmpty:t(u,a)}})}();