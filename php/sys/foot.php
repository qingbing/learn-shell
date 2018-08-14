
</div>

<div class="navbar navbar-default navbar-fixed-bottom">
    <div class="container">
        <div class="navbar-header">
            <button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#footer">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
        </div>
        <div class="collapse navbar-collapse" id="footer">
            <span class="navbar-text">This is a simple system to manage linux system!</span>

            <ul class="nav navbar-nav navbar-right">
                <li>
                    <button type="button" class="btn btn-warning navbar-btn" id="reboot">Reboot</button>
                </li>
                <li style="padding-left:15px;">
                    <button type="button" class="btn btn-danger navbar-btn" id="shutdown">Shutdown</button>
                </li>
            </ul>
        </div>
    </div>
</div>

<div class="modal fade" id="tipModal" role="dialog">
    <div class="modal-dialog modal-sm" role="document" aria-hidden="true">
        <div class="modal-content">
            <div class="modal-header">
                <div class="close" data-dismiss="modal">&times;</div>
                <h3 class="modal-title" id="tipModalTitle"></h3>
            </div>
            <div class="modal-body">
                <p id="tipModalContent"></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-warning" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="bs/js/bootstrap.js"></script>
<script type="text/javascript">
    (function ($) {
        $('#reboot').on('click', function (e) {
            if (window.confirm("Are you sure you want to reboot the system!")) {
                $('#tipModalTitle').text('System is rebooting, please try again later!');
                $('#tipModalContent').text('Rebooting...');
                $('#tipModal').modal('show');
                $.post('ajax.php?type=reboot', {}, function (rs) {
                    if (0 === rs.code) {
                        alert("Reboot success.");
                        $('#tipModal').modal('hide');
                    } else {
                        $('#tipModalContent').text('Rebooting fail.');
                    }
                }, 'json');
            }
        });
        $('#shutdown').on('click', function (e) {
            if (window.confirm("Are you sure you want to shutdown the system!")) {
                $('#tipModalTitle').text('System is shutdown, please open the machine first!');
                $('#tipModalContent').text('shutdown...');
                $('#tipModal').modal('show');
                $.post('ajax.php?type=shutdown', {}, function () {
                    if (0 === rs.code) {
                        alert("Shutdown success.");
                        $('#tipModal').modal('hide');
                    } else {
                        $('#tipModalContent').text('Shutdown fail.');
                    }
                }, 'json');
            }
        });
    })(jQuery);
</script>
</body>
</html>