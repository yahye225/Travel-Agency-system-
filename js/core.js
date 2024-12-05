$("body").delegate(".get_form","click",function(e){
	e.preventDefault();
	var url = $(this).attr('href');
   var fname = $(this).text();
   var data = "form_name="+fname;
	$.get(url,data,function(ress){
		$('.form_place').html(ress);
	})
});

$("body").delegate(".form_data","submit",function(e){
	e.preventDefault();
var page = $(this).attr('action');
var frm = $(this);
  $.ajax({
  	url: page,
  	data: new FormData(this),
  	type: "POST",
  	contentType: false,
  	processData: false,
  	success: function(response){
      //alert(response);
if(frm.hasClass('report')){
  frm.next().html(response);
}else if(frm.hasClass('update')){
    $('.update_res').html(`<button style="width:100%" class="btn btn-success btn-block">${response}</button>`);
}else{
var res = response.split("|");

  frm.next().html(`<button class="btn btn-${$.trim(res[0])} btn-block">${res[1]}</button>`);

if($.trim(res[0]) == "success"){
    frm.trigger("reset");
}
}
    
  	}
  })

});

$("body").delegate(".search","keyup",function(){
  var text = $(this).val();
  var action = $(this).attr('action');
var data = "text="+text+"&action="+action;
var ul = $(this).next();
var width = $(this).width();
ul.css('width',width);

ul.removeClass('hide');
if(text == ""){
  ul.addClass('hide');
}



  $.post("tools/search.php",data,function(ress){
      ul.html(ress);
  })
})





$("body").delegate(".list-group-item","click",function(){
  var sellected = $(this).text();
  var id = $(this).attr('id');
  $(this).parent().prev().val(sellected);
  $(this).parent().next().val(id);
  $(this).parent().addClass('hide');
})

$("body").delegate(".del_data","click",function(){
  var table = $(this).attr('table');
  var col = $(this).attr('column');
  var val = $(this).attr('value');
  var user_id = $(this).attr('user_id');
var row = $(this).closest('tr');
  var data ="sp=delete_sp&table="+table+"&col="+col+"&val="+val+"&user_id="+user_id;

  //alert(data);
   if(confirm("Ma hubtaa inaad tirayso Xogtaan")){
    $.post("tools/insert_anny.php",data,function(res){
   alert(res);
   row.remove();
    })
   }
});

$("body").delegate(".edit_data","click",function(){
   var table = $(this).attr('table');
  var col = $(this).attr('column');
  var val = $(this).attr('value');
  var user_id = $(this).attr('user_id');
  var action = $(this).attr('action');

  var data ="table="+table+"&col="+col+"&val="+val+"&user_id="+user_id+"&action="+action;

  $.post("tools/update_form.php",data,function(res){
   $(".update_body").html(res);
   $("#update_modal").modal("show");
  })
})
$("body").delegate(".update_field","change",function(){

  $(this).parent().parent().next().find('.update-btn').removeClass('hide');

})
$("body").delegate(".update_field","keyup",function(){

$(this).parent().parent().next().find('.update-btn').removeClass('hide');
})

$("body").delegate(".update-btn","click",function(){

$(this).text("Updated Success");
$(this).fadeOut(3000);
})

$("body").delegate(".undo","click",function(){
  var tr = $(this).closest("tr");
  var sp = tr.find('.sp').text();
  var id = tr.find('.id').text();
  var backup = tr.find('.data').text();
  var col = tr.find('.col').text();
  var table = tr.find('.table').text();

  var data = "sp="+sp+"&id="+id+"&backup="+backup+"&col="+col+
  "&table="+table;
  //alert(data);
  $.post("tools/insert_anny.php",data,function(ress){
  //  alert(ress);
    $("#form-response").html(`<button style="width:100%" class="btn btn-success btn-block">${ress}</button>`);
  })
});

$("body").delegate(".save_permission","change",function(){
  var type = 'delete';
//alert(1);
  if($(this).is(":checked")){
    type = 'insert';

  }

var form_id = $(this).attr("form_id");
var user_id = $(this).attr("user_id");
var granted = $(this).attr("granted");
var action = $(this).attr("action");
var data = "sp=permission_sp&form_id="+form_id+"&user_id="+user_id+"&granted="+granted+"&action="+action+"&type="+type;
$.post("tools/insert_anny.php",data,function(ress){
  //alert(ress);
  $("#form-response").html(`<button style="width:100%" class="btn btn-success btn-block">${ress}</button>`);
})
});

$("body").delegate(".check_all","change",function(){
  //alert(1);
  if($(this).is(":checked")){
  
    $(this).next().find('.save_permission').each(function(){
        if($(this).is(":checked")){
        $(this).attr("checked",false);
      }else{
         $(this).attr("checked",true);
      }
      $(this).trigger("change");
    })
  }else{
 
     $(this).next().find('.save_permission').each(function(){
        if($(this).is(":checked")){
        $(this).attr("checked",false);
      }else{
         $(this).attr("checked",true);
      }
      $(this).trigger("change");
    })
  }
})



$("body").delegate(".marks-entry","click",function(){
  var kan  = $(this);
  var tr = $(this).closest("tr");
  var sp = tr.find('.sp').text();
  var std_id = tr.find('.std_id').text();
  var marks = tr.find('.marks').text();
  var exam = tr.find('.exam').text();
  var course = tr.find('.course').text();
   var year = tr.find('.year').text();
  var date = tr.find('.date').text();
  var user = tr.find('.user').text();
  var max = $.trim(tr.find('.max').text());


  var data = "sp="+sp+"&std_id="+std_id+"&marks="+marks+"&exam="+exam+
  "&course="+course+"&year="+year+"&date="+date+"&user="+user;
  //alert(data);
  $.post("tools/insert_anny.php",data,function(ress){
 var response = ress.split("|");
tr.find('.marks-entry').removeClass('fa-save');
tr.find('.marks-entry').addClass('fa-check');
    $("#form-response").html(`<button  style="width:100%" class="btn btn-${response[0]} btn-block">${response[1]}</button>`);
  })
});

$("body").delegate(".marks","blur",function(){
   
   if($(this).text() == ""){
    return false;
   }

    var tr = $(this).closest("tr");
     var marks = parseFloat($(this).text());
     var max = parseFloat(tr.find('.max').text());
     
   
  if(marks > max){
     alert("marks kama badnan karo "+max);
  tr.find('.marks-entry').prop("disabled",true);
  return false;
}else{
  tr.find('.marks-entry').prop("disabled",false);
  tr.find(".marks-entry").trigger("click");
}
})
var labels = '';
var select = '';
$("body").delegate(".generate_modal","click",function(){
   var labels = $('.report').find('.form-print').find('label').text();

  if($('.report').find('.form-print').find('select')){
   select = $('.report').find('select').find(':selected').text();
  }
  $(".report-header").html(labels +': '+select);
    //$(".report-header").html($('.report').find('select').find(':selected').text());
    var table = $("#get_data").html();

    $(".report-body").html(table);
    $(".modal-content").find("#example-table").find('.ignore').css("display","none");
       $(".modal-content").find(".dataTables_filter").css("display","none");

        $(".modal-content").find(".dataTables_info").css("display","none");
       $(".modal-content").find(".dataTables_paginate").css("display","none");
       $(".modal-content").find(".generate_modal").remove();
     $("#report_modal").modal("show");

})

function printDiv(div) {

  var divToPrint=document.getElementById(div);

  var newWin=window.open('','Print-Window');

  newWin.document.open();

  newWin.document.write('<html><head><link rel="stylesheet" href="assets/vendors/bootstrap/dist/css/bootstrap.min.css"   type="text/css" /></head><body onload="window.print()">'+divToPrint.innerHTML+'</body></html>');

  newWin.document.close();


}

$("body").delegate(".print-report","click",function(e){
  //alert(1);
      printDiv("printable-area");
    });


function exportTableToCSV($table, filename) {
                var $headers = $table.find('tr:has(th:not(.hide))')
                    ,$rows = $table.find('tr:has(td:not(.hide))')

                    // Temporary delimiter characters unlikely to be typed by keyboard
                    // This is to avoid accidentally splitting the actual contents
                    ,tmpColDelim = String.fromCharCode(11) // vertical tab character
                    ,tmpRowDelim = String.fromCharCode(0) // null character

                    // actual delimiter characters for CSV format
                    ,colDelim = '","'
                    ,rowDelim = '"\r\n"';

                    // Grab text from table into CSV formatted string
                    var csv = '"';
                    csv += formatRows($headers.map(grabRow));
                    csv += rowDelim;
                    csv += formatRows($rows.map(grabRow)) + '"';

                    // Data URI
                    var csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);

                // For IE (tested 10+)
                if (window.navigator.msSaveOrOpenBlob) {
                    var blob = new Blob([decodeURIComponent(encodeURI(csv))], {
                        type: "text/csv;charset=utf-8;"
                    });
                    navigator.msSaveBlob(blob, filename);
                } else {
                    $(this)
                        .attr({
                            'download': filename
                            ,'href': csvData
                            //,'target' : '_blank' //if you want it to open in a new window
                    });
                }

                //------------------------------------------------------------
                // Helper Functions 
                //------------------------------------------------------------
                // Format the output so it has the appropriate delimiters
                function formatRows(rows){
                    return rows.get().join(tmpRowDelim)
                        .split(tmpRowDelim).join(rowDelim)
                        .split(tmpColDelim).join(colDelim);
                }
                // Grab and format a row from the table
                function grabRow(i,row){
                     
                    var $row = $(row);
                    //for some reason $cols = $row.find('td') || $row.find('th') won't work...
                    var $cols = $row.find('td'); 
                    if(!$cols.length) $cols = $row.find('th');  

                    return $cols.map(grabCol)
                                .get().join(tmpColDelim);
                }
                // Grab and format a column from the table 
                function grabCol(j,col){
                    var $col = $(col),
                        $text = $col.text();

                    return $text.replace('"', '""'); // escape double quotes

                }
            }
$("body").delegate(".exportCSV ","click",function(event){
                // var outputFile = 'export'
                var outputFile = window.prompt("Write it a name") || 'export';
                outputFile = outputFile.replace('.csv','') + '.csv'
                 
                // CSV
                exportTableToCSV.apply(this, [$('#example-table'), outputFile]);
                
                // IF CSV, don't do event.preventDefault() or return false
                // We actually need this to be a typical hyperlink
            });

$("body").delegate(".chart_detail","click",function(e){
  e.preventDefault();
  var url = $(this).attr('href');
  $.post(url,function(ress){
    $(".report-body").html(ress);
      $("#report_modal").modal("show");
  })
})


$("body").delegate(".confirm","keyup",function(e){
  e.preventDefault();
  $('.msgeror').text('');
  $(".mybutton").attr('disabled',false);
  var pass = $('.newpass').val();
  var conf = $(this).val();

  if(conf != pass){
    $(this).after(`<p class="msgeror text-danger">Paasword Not Matched</p>`);
    $(".mybutton").attr('disabled',true);
    return false;
  }
})