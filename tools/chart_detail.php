<?php 
require("conn.php");
require("function.php");
extract($_GET);
 $sql = "call chart_detail_sp('$action','$user_id')";
$ress = $conn->query($sql);
if(@$ress->num_rows == 0){
	?>

  <div style="width: 100%;background: orange;padding: 10px;color: red">Not Found</div>
	<?php 
	return false;
}
 ?>

 <div class="page-content fade-in-up">
                <div class="ibox" id="get_data">
                    
                    <div class="ibox-head">
                        <div class="ibox-title"></div>

                    </div>
                    <div class="ibox-body">
                        <center><?php //echo  $form_name ?></center>
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
    </style>
<?php require("reportmodal.php") ?>