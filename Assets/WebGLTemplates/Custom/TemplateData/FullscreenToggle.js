function FullscreenToggle (dom) {
  dom.addEventListener('click', function () {
    if (typeof SetFullscreen === 'function') {
      SetFullscreen(1);
    }
  });
}

FullscreenToggle(document.querySelector('.fullscreen'));
