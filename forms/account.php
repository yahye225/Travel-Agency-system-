<?php 
session_start();
?>
<div class="row">
	<div style="margin: auto;" class="col-md-8">
                        <div class="ibox">
                            <div class="ibox-head">
                                <div class="ibox-title">Add Account</div>
                             
                            </div>
                            <div class="ibox-body">
              <form class="form_data" action="tools/insert_anny.php" method="post">
                               <input type="hidden" name="sp" value="account_sp">
                                    <div class="form-group">
                                        <label>Account Name</label>
          <input class="form-control" name="a" type="text" placeholder="Enter Account Name">
                                    </div>
                                    <div class="form-group">
                                        <label>Date</label>
                                        <input class="form-control" type="date" placeholder="Enter Level Fee" name="b">
                                    </div>
                               
     <input type="hidden" value="<?php echo $_SESSION['user_id'] ?>" name="user_id">
                                    <div class="form-group">
                       <button class="btn btn-primary btn-block" type="submit">Save</button>
                                    </div>
                                </form>
                             <div>
                             	
                             </div>
                            </div>
                        </div>
                    </div>
</div>