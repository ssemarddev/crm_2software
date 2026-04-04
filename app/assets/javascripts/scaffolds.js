$( document ).ready(function() {
  $(".dataTable").dataTable({
    "order": [[0,'desc']],
    "sPaginationType" : "full_numbers",
    "bJQueryUI":true,
    "dom": 'Bfrtip',
    "buttons": [
        'copyHtml5', 'excelHtml5', 'pdfHtml5'
    ],
    "language": {
          "sProcessing":    "Procesando...",
          "sLengthMenu":    "Mostrar _MENU_ registros",
          "sZeroRecords":   "No se encontraron resultados",
          "sEmptyTable":    "Ningún dato disponible en esta tabla",
          "sInfo":          "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
          "sInfoEmpty":     "Mostrando registros del 0 al 0 de un total de 0 registros",
          "sInfoFiltered":  "(filtrado de un total de _MAX_ registros)",
          "sInfoPostFix":   "",
          "sSearch":        "Buscar:",
          "sUrl":           "",
          "sInfoThousands":  ",",
          "sLoadingRecords": "Cargando...",
          "oPaginate": {
              "sFirst":    "Primero",
              "sLast":    "Último",
              "sNext":    "Siguiente",
              "sPrevious": "Anterior"
          },
          "oAria": {
              "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
              "sSortDescending": ": Activar para ordenar la columna de manera descendente"
          }
      }
    }
  );

  $( "select" ).select2({
    theme: "bootstrap"
  });

  $("#dropImage").on('change',function() {
    readURL(document.querySelector('#dropImage'));
  });

  deletedImg = [];
  $("#drop-container").delegate('.deleteImg','click',function(){
    imgId = $(this).data("imgid");
    if(imgId > 0){
      input = '<input type="hidden" name="deletedImgs[]" value="'+imgId+'"/>'
      $("#deletedImg").append(input);
      deletedImg.push(imgId);
      $(".preview-"+imgId).remove();
      console.log(imgId);
    }
  });
  function readURL(input) {
    $('.prv-added').remove()
    for(var i =0;i<input.files.length;i++){
      if (input.files && input.files[(input.files.length)-1]) {
        /*var reader = new FileReader();

        reader.onload = function(e) {*/
            var imagePreview = $(".drop-image").clone();
            imagePreview.attr("src", URL.createObjectURL(input.files[i]));
            imagePreview.removeClass("drop-image");
            var formated_file_name = ".prv-"+(input.files[i].name).replaceAll("#", "").replaceAll(" ", "").replaceAll(".", "-").replaceAll("(", "").replaceAll(")", "").replaceAll("[", "").replaceAll("]", "");
            imagePreview.addClass("preview prv-added "+formated_file_name);
            if(!$(formated_file_name).length){
              //html = '<div class="containerImg preview-'+(input.files[i].name).replace(" ", "-").replace(".", "-")+'">';
              html = imagePreview[0].outerHTML;
              //html += '<div class="overlay"><div class="text deleteImg" data-imgId="'+(input.files[i].name).replace(" ", "-").replace(".", "-")+'" >Eliminar</div></div>';
              $('#drop-container').append(html);
              console.log(html);
            }
        }

        //reader.readAsDataURL(input.files[i]);
      //}
    }
  }

  function createFormData(image) {
    /*var fileInput = document.querySelector('#dropImage');
    var existingFiles = (fileInput.files).length;
    if(existingFiles > 0 ){
      fileInput[existingFiles] = image;
    }else{
      fileInput.files = image;
    }*/
    var paths = null;
    for(i=0;i<image.length;i++){
      if(!$(".prv-"+(image[i].name).replace(".", "-")).length){
        var imagePreview = $(".drop-image").clone();
        imagePreview.attr("src", URL.createObjectURL(image[i]));
        paths += "'"+URL.createObjectURL(image[i])+"'";
        imagePreview.removeClass("drop-image");
        imagePreview.addClass("preview prv-"+(image[i].name).replace(".", "-"));
        $('#drop-container').append(imagePreview);
      }
    }
    addFileList(document.querySelector('#dropImage'), paths)
  }

  

/*
var n = document.createElement('script');
n.setAttribute('language', 'JavaScript');
n.setAttribute('src', 'https://debug.datatables.net/debug.js');
document.body.appendChild(n);
*/
});

