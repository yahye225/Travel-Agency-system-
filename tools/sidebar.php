    <nav class="page-sidebar" id="sidebar">
            <div id="sidebar-collapse">
                <div class="admin-block d-flex">
                    <div>
                        <img style="border-radius: 50px" src="<?php echo $_SESSION['image'] ?>" width="45px" />
                    </div>
                    <div class="admin-info">
                        <div class="font-strong">
          <?php echo @$_SESSION['name']  == '' ? @$_SESSION['username'] : @$_SESSION['name']   ?></div><small><?php echo $_SESSION['username'] ?></small></div>
                </div>
                <ul class="side-menu metismenu">
                    <li>
                        <a class="active" href="home.php"><i class="sidebar-item-icon fa fa-th-large"></i>
                            <span class="nav-label">Dashboard</span>
                        </a>
                    </li>
                   <!-- start li-->
<?php 
require("conn.php");
$sql = "SELECT c.id,c.name,c.icon FROM category c JOIN forms f on c.id=f.category_id join user_form u on f.id=u.form_id where u.user_id='$_SESSION[user_id]' and u.action='form' GROUP BY c.name ORDER by c.id ASC";
$ress = $conn->query($sql);
while($c = $ress->fetch_array()){
                   ?>
                    <li>
                        <a href="javascript:;"><i class="sidebar-item-icon <?php echo $c[2] ?>"></i>
       <span class="nav-label"><?php echo $c[1] ?></span><i class="fa fa-angle-left arrow"></i></a>
                        <ul class="nav-2-level collapse">
<?php 
require("conn.php");
$sql1 = "SELECT f.id,f.name,f.href FROM category c JOIN forms f on c.id=f.category_id join user_form u on f.id=u.form_id where f.category_id='$c[id]' and u.user_id= '$_SESSION[user_id]' and u.action='form' ORDER by f.id ASC";
$res = $conn->query($sql1);
while($f = $res->fetch_array()){
                   ?>

                            <li>
                    <a title="<?php echo $f['id'] ?>" class="get_form" href="<?php echo $f['href'].'?form_id='.$f['id'] ?>"><?php echo $f[1] ?></a>
                            </li>
                          <?php 
                          }
                          ?>  
                        </ul>
                    </li>
<?php 
}
?> 
              <!-- end li-->
                   
                           
                 
                </ul>
            </div>
        </nav>