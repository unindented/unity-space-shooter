function UnityProgress (dom) {
  this.progress = 0;
  this.message = '';
  this.dom = dom;

  var container = dom.parentNode;
  var loading = container.querySelector(".loading");
  var loadingBar = loading.querySelector('.loading-bar');
  var loadingBarInner = loading.querySelector('.loading-bar-inner');

  this.SetProgress = function (progress) {
    if (progress > this.progress) {
      this.progress = progress;
      this.Update();
    }
  };

  this.SetMessage = function (message) {
    if (message !== this.message) {
      this.message = message;
      this.Update();
    }
  };

  this.Clear = function () {
    container.classList.add('is-finished');
  };

  this.Update = function () {
    loadingBarInner.style.width = Math.round(this.progress * 100) + '%';
  };

  this.Update();
}
