function renderEmoji() {
  twemoji.parse(document.body, { // parses the elements inside of #feed
    folder: 'svg', // sets it to render svgs
    ext: '.svg',
    callback: function (iconId, options) {
      switch (iconId) { // ignores the copyright, registered trademark, and trademark symbols
        case 'a9':      // © copyright
        case 'ae':      // ® registered trademark
        case '2122':    // ™ trademark
          return false;
      }
      return ''.concat(options.base, options.size, '/', iconId, options.ext); // actually renders the emoji
    }
  });
  console.log('emoji rendered.')
}

window.onload = function () {
  renderEmoji();
};

var started = false;

gitbook.page.hasChanged = (ctx) => {
  console.log('page has changed', ctx); // eslint-disable-line no-console
  gitbook.page.setState(ctx);
  

  if (!started) {
    // Notify that gitbook is ready
    started = true;
    gitbook.events.trigger('start', ctx.config.pluginsConfig);
  }

  gitbook.events.trigger('page.change');
  renderEmoji();
}
