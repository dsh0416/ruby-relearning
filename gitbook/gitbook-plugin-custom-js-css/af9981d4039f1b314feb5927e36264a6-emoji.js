window.onload = function () { // runs the script when the page is loading
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
};
