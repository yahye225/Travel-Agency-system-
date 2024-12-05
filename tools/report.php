 <?php 
require("conn.php");
require("function.php");
$form_name = $_POST['fname'];
unset($_POST['fname']);
 $sql = gen_sql($_POST);
$ress = $conn->query($sql);
if($ress->num_rows == 0){
	?>

  <div style="width: 100%;background: orange;padding: 10px;color: red">Not Found</div>
	<?php 
	return false;
}
 ?>

 <div class="page-content fade-in-up">
                <div class="ibox" id="get_data">
                    <button class="btn btn-primary btn-lg generate_modal"><i class="fa fa-print"></i>Print</button>
                    <button class="btn btn-success btn-lg generate_modal"><i class="fa fa-download"></i>Export</button>
                    <div class="ibox-head">
                        <div class="ibox-title"></div>

                    </div>
                    <div class="ibox-body">
                        <center><?php echo  $form_name ?></center>
        <table class="table table-striped table-bordered table-hover" id="example-table" cellspacing="0" width="100%">
                          <?php 
            table_row($ress);

                          ?>

                            
                        </table>
                    </div>
                </div>
              
            </div>

<script type="text/javascript">
        $(function() {
            $('#example-table').DataTable({
                pageLength: 10,
                //"ajax": './assets/demo/data/table_data.json',
                /*"columns": [
                    { "data": "name" },
                    { "data": "office" },
                    { "data": "extn" },
                    { "data": "start_date" },
                    { "data": "salary" }
                ]*/
            });
        })
    </script>

    <style type="text/css">
        .hide{
            display: none;
        }
        @media print{
            .markscss{
                background: black;
                color: black;

            }
        }
    </style>

    <script type="text/javascript">
        $("tbody td.marks").each(function(){
           
            var tr = $(this).closest('tr');
            var min = parseFloat(tr.find('.min').text());
            if($(this).text() < min){
              //  alert(1);
                $(this).css('background','red');
                return true;
            }
        });

         $("tbody td.fail").each(function(){
           
           
            var val = $(this).text();
            if($.trim(val) == 'Fail'){
              //  alert(1);
                $(this).css('color','red');
                return true;
            }
        })

            $("tbody td.balance").each(function(){
           
           var tr = $(this).closest('tr');
            var val = parseFloat($(this).text());
            if(val > 0){
              //  alert(1);
               tr.find('.marks').addClass('markscss');
                tr.find('.marks').css('background','black');
                tr.find('.fail').css('background','black');
                tr.find('.fail').css('color','black');
                tr.find('.total').css('background','black');
                tr.find('.total').css('color','black');
                tr.find('.avg').css('background','black');
                tr.find('.avg').css('color','black');
               tr.find('.marks').css('color','black');
                return true;
            }
        })


    </script>
<?php require("reportmodal.php") ?>