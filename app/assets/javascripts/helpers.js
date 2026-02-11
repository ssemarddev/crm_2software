function copy_to_clipboard(text) {
  var copyText = text;

  document.addEventListener('copy', function(e) {
      e.clipboardData.setData('text/plain', copyText);
      e.preventDefault();
  }, true);

  document.execCommand('copy');
  alert('Link copiado ');
}