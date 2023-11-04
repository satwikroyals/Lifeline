$(document).ready(function () {
    var pageurl = window.location.href.toLowerCase();
    if (pageurl.indexOf("workshopresult") != -1) {
        $("#workshopresult-show").addClass('active');
    }
});

function validate() {
    var error = [];
    error = formValidate();
    if (error.length == 0) {
        $('#error').addClass('hide');
        $('#error').removeClass('show');
        return true;
    }
    else {
        $('#error').addClass('show');
        $('#error').removeClass('hide');
        var valerror = "<ul>";
        $(error).each(function (i, e) {
            valerror += "<li>" + e + "</li>";
        });
        valerror += "</ul>";
        document.getElementById("error").innerHTML = valerror;
        $('#error').focus();
        return false;
    }
}

function setviewchapterresults() {
    getchapterresults(1, 10, 1, '');

    $('#ChapterId').on('change', function () {
        getchapterresults(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val(); 
        getchapterresults(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        getchapterresults(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#EventId', function (event) {
        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        getchapterresults(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        getchapterresults(pageindex, pagesize, sortby, searchby);
        $('#Searchstr').focus();
        var $thisVal = $('#Searchstr').val();
        $('#Searchstr').val('').val($thisVal);

    });
}

function getchapterresults(pageindex, pagesize, sortby, searchby) {
    var searchby = $('#Searchstr').val();
    var sid = $('#SubjectId').val();
    var cid = $('#ChapterId').val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "Workshop/GetChapterResult", "get", { sid: sid, cid: cid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                row += "<tr><td>" + item.ChapterName + "</td><td>" + item.FirstName + "</td><td>" + item.LastName + "</td><td>" + item.Mobile + "</td><td>" + item.Email + "</td><td><button class='wrench-bg' onclick='Results(" + item.AnsweredId + ")'><i class='fas fa-eye'></i></button></td></tr>";
            });
            $("#tbldata").html(row);
            setPagging(reccount, pageindex, pagesize);
            $('.norec').addClass('hide');
            $('.tblcontent,.filt').removeClass('hide');
        }
        else {
            if (String(searchby).length > 0) {
                $('.norec').addClass('hide');
                $('.tblcontent').removeClass('hide');
                $("#tbldata").html("<tr><td>No Data Found</td></td></tr>");
            }
            else {
                $('.norec').removeClass('hide');
                $('.tblcontent').addClass('hide');
            }
        }
    }, '', '', '', '', true, true, '.loader', '.tblcontent', 'text json', 'true');
}

function Results(aId) {
    $('#myModal').modal('show');
    var row = '';
    var reccount = 0;
    gl.ajaxreqloader(apiurl + "Workshop/GetChapterResultByResultId", "get", { aId: aId }, function (response) {
        if (response.length > 0) {
            $.each(response, function (i, item) {
                if (item.Answer == null)
                {
                    item.Answer = item.Comment;
                }
                row += "<tr><td>" + item.QuestionNum + "</td><td>" + item.Question + "</td><td>" + item.Answer + "</td></tr>";
            });
            $("#tblresultdata").html(row);
            //$('.norec').addClass('hide');
            //$('.tblcontent,.filt').removeClass('hide');
        }
        else {
            if (String(searchby).length > 0) {
                //$('.norec').addClass('hide');
                //$('.tblcontent,.filt').removeClass('hide');
                $("#tblresultdata").html("<tr><td>No Data Found</td></td></tr>");
            }
            else {
                $('.norec').removeClass('hide');
                $('.tblcontent,.filt').addClass('hide');
            }
        }
    }, '', '', '', '', true, true, '.loader', '.tblcontent', 'text json', 'true');
}







