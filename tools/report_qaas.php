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
<b>Student Name:<?php echo get_val("select get_name($_POST[_std_id])") ?></b> <br>
           <b>From:<?php echo $_POST['_from']?></b>  <br>  
           <b>To:<?php echo $_POST['_to']?></b>
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
        
    </script>

    <style type="text/css">
        .hide{
            display: none;
        }
    </style>
<?php require("reportmodal.php") ?>