
function SetdocumentPage() {

    SetViewDocumentGrid(1, 10, 1, '');
    $(document).on('click', '#shwallbtn', function () {
        $('#StartDate').val("");
        $('#EndDate').val("");
        $('#Searchstr').val("");
        SetViewDocumentGrid(1, 10, 1, '');

    });
    $(document).on('click', '#srchbtn', function () {
        SetViewDocumentGrid(1, 10, 1, '');

    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        SetViewDocumentGrid(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        SetViewDocumentGrid(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        SetViewDocumentGrid(pageindex, pagesize, sortby, searchby);
        $('#Searchstr').focus();
        var $thisVal = $('#Searchstr').val();
        $('#Searchstr').val('').val($thisVal);

    });
}
//<td><button class='times-bg' onclick='DeleteEvent(" + item.MemberId + ")'><i class='fas fa-times'></i></button></td>
function SetViewDocumentGrid(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var searchby = $('#Searchstr').val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "GetAdminResourceDocuments", "get", { pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                row += "<tr><td>" + item.DocTitle + "</td><td>" + item.CreatedDateString + "</td><td><button class='wrench-bg' onclick='quizdetails(" + item.ResourceId + ")'><i class='fa fa-wrench'></i></button></td><td><button class='times-bg' onclick='DeleteDocument(" + item.ResourceId + ")'><i class='fa fa-trash-o'></i></button></td></tr>";
            });
            $("#tbldata").html(row);
            $('#norec').addClass('hide');
            $('#tblgrid').removeClass('hide');
            setPagging(reccount, pageindex, pagesize);
        }
        else {
            $('#norec').removeClass('hide');
            $('#tblgrid').addClass('hide');
        }
    }, '', '', '', '', true, true, '.loader', '.tblcontent', 'text json', 'true');
}

function quizdetails(id) {
    window.location.href = "AddResourceDoc?id=" + id;
}


function DeleteDocument(sid) {
    var ans = confirm("Are you sure you want to Delete this Document?");
    if (ans) {
        $.ajax({
            url: apiurl + "DeleteDocument?did=" + sid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                SetdocumentPage();
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}