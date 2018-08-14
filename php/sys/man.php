<?php include("head.php");?>

<div class="row">
    <div class="panel-group" id="accordion">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#three">系统负载</a></h3>
            </div>
            <div class="panel-collapse collapse in" id="three">
                <div class="panel-body">
                    <pre>
<?php system("uptime"); ?></pre>
                </div>
            </div>
        </div>

        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#one">硬盘使用</a></h3>
            </div>
            <div id="one" class="panel-collapse collapse in">
                <div class="panel-body">
                    <pre>
<?php system("df -Th"); ?></pre>
                </div>
            </div>
        </div>

        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#two">内存使用</a></h3>
            </div>
            <div class="panel-collapse collapse in" id="two">
                <div class="panel-body">
                    <pre>
<?php system("free -m"); ?></pre>
                </div>
            </div>
        </div>
    </div>
</div>

<?php include("foot.php");?>