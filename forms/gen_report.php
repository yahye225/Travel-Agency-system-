<?php 
session_start();
require("../tools/function.php");
require("../tools/conn.php");
$sql = "select * from forms where id=$_GET[form_id]";
$ress= $conn->query($sql);
$f = $ress->fetch_array();
?>
<div class="row">

	<div  class="col-md-12">
                        <div class="ibox">
                          <div id="form-response">
                            
                          </div>
                            <div class="ibox-head">
                              
                                <div class="ibox-title"><?php echo $f['name'] ?></div>
                             
                            </div>
                            <div class="ibox-body">

<form class="form_data report" 
action="<?php echo $f['form_action'] ?>" method="post">
<div class="row">
  <input type="hidden" name="fname" value="<?php echo $_GET['form_name'] ?>">
  <input type="hidden" name="sp" value="<?php echo $f['sp_name'] ?>">
<?php 
require("../tools/conn.php");
$sql1 = "select * from form_input where form_id=$_GET[form_id]";
$res = $conn->query($sql1);
while($row = $res->fetch_array()){
  extract($row);
  if($type == "user_id"){
?>
<input type="hidden" name="<?php echo $name ?>" value="<?php echo $_SESSION['user_id'] ?>">

<?php 
  }elseif($type == "dropdown"){
?>
<div class="col-2">
<div class="form-group <?php echo $f['sp_name'] == 'rp_std_statments_sp' ? '' : 'form-print' ?>">
<label><?php echo $label ?></label>
<select class="form-control" name="<?php echo $name ?>">
  <option selected=" " value="%" >Chose One</option>
  <?php get_dropdown($action) ?>
</select>
</div>
</div>
<?php

}elseif($type == "search"){
?>
<div class="col-2">
<div class="form-group ?php echo $f['sp_name'] == 'rp_std_statments_sp' ? '' : 'form-print' ?>">
<label><?php echo $label ?></label>
<input class="form-control search" action="<?php echo $action ?>" type="<?php echo $type ?>" placeholder="<?php echo $placeholder ?>">
<ul style="list-style: none" class="hide ">
  
</ul>
<input type="hidden" name="<?php echo $name ?>">

<style>
  .hide{
    display: none;
  }
</style>
</div>
</div>
<?php 
}else{
?>
<div class="col-2">
<div class="form-group ?php echo $f['sp_name'] == 'rp_std_statments_sp' ? '' : 'form-print' ?>">
<label><?php echo $label ?></label>
<input class="form-control" name="<?php echo $name ?>" type="<?php echo $type ?>" placeholder="<?php echo $placeholder ?>">
</div>
</div>
<?php 
}
}
?>                              
  <div class="form-group">
    <button style="margin-top: 30px" class="btn btn-primary" type="submit"><?php echo $f['button'] ?></button>
  </div>
  </div>
    </form>
  <div>
                             	
                             </div>
                            </div>
                        </div>
                    </div>
</div>

<?php require("update_modal.php")?>