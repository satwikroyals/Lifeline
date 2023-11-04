$(document).ready(function () {
    var pageurl = window.location.href.toLowerCase();
    if (pageurl.indexOf("subjects") != -1) {
        $("#tab-show").addClass('active');
    }
    if (pageurl.indexOf("addsubject") != -1) {
        $("#subjecttab-add").addClass('active');
    }
    if (pageurl.indexOf("chapters") != -1) {
        $("#chapters").addClass('active');
    }
    if (pageurl.indexOf("addchapter") != -1) {
        $("#addchapters").addClass('active');
    }
    $('.staticddl').each(function () {
        $(this).val($(this).attr('bindvalue'));
    });
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

function getsubjectpage() {

    GetSubjects(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetSubjects(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#StartDate').val("");
        $('#EndDate').val("");
        $('#Searchstr').val("");
        GetSubjects(1, 10, 1, '');
    });
    $(document).on('click', '#srchbtn', function () {
        GetSubjects(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetSubjects(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetSubjects(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetSubjects(pageindex, pagesize, sortby, searchby);
        $('#Searchstr').focus();
        var $thisVal = $('#Searchstr').val();
        $('#Searchstr').val('').val($thisVal);

    });
    $(document).on("change", '#SortBy', function (event) {
        var pagesize = $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = $('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var region = $("#ddlsearchregion").val();
        var zone = $("#ddlsearchzone").val();
        var division = $("#ddlsearchdevision").val();
        var depo = $("#ddlsearchdepot").val();
        var service = $("#ddlsearchservice").val();
        var date = $("#historydate").val();

        var data = { DepotId: depo, ZoneId: zone, RegionId: region, ServiceDetailsId: service, PageSize: pagesize, PageIndex: pageindex, Searchstr: searchby, SortBy: sortby, Date: decodeURIComponent(date) }
        // setArrivalDeparturePunctualityGrid(data);
        SetCustomGrid(reportsWebsiteUrl + "_ArrivalDepartureReportData", data, 'none', showrepotgridid, 'TSRTC');
        $('#ddlPageSize').val(pagesize);
        $('#SortBy').html($('#dummysortby').html());
        $('#SortBy').val(sortby);
        var url = reportsWebsiteUrl + 'ArrivalDepaturePunctualityReport?rpss=' + pageindex + '|' + pagesize + '|' + sortby + '|' + zone + '|' + region + '|' + division + '|' + depo + '|' + searchby + '|' + decodeURIComponent(date) + '|' + service
        setnavigationurl(url);
    });
    $(document).on('click', '#excel', function (e) {

        var pagesize = -1;
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var CustomerId = $('#ddlCustomerID').val();
        var StationLocation = $('#ddlLocation option:selected').text();
        var row = '';
        var reccount = 0;
        var isloader = String(searchby).length == 0 ? true : false
        gl.ajaxreqloader(websiteurlapi + "GetemsStoreSignalStatus", "post", { PageIndex: pageindex, PageSize: pagesize, SortBy: sortby, Searchstr: searchby, CustomerId: CustomerId, StationLocation: StationLocation }, function (response) {
            if (response.length > 0) {
                reccount = response[0].TotalRecords;
                $.each(response, function (i, item) {
                    row += "<tr><td>" + item.EStatus + "</td><td>" + item.ESignal + "</td><td>" + item.StationId + "</td><td>" + item.StationName + "</td><td>" + item.StationLocation + "</td><td>" + item.STxnTime + "</td><td>" + item.RTxnDate + "</td><td>" + item.RTxnTime + "</td><td>" + item.XTxnDate + "</td><td>" + item.XTxnTime + "</td><td>" + item.YTxnDate + "</td><td>" + item.YTxnTime + "</td></tr>";
                    // row += "<tr><td><img src=" + item.StatusImage + " style='width:75px;'></td><td><img src=" + item.SignalImage + " style='width:30px;'></td><td>" + item.StationId + "</td><td>" + item.StationName + "</td><td>" + item.StationLocation + "</td><td>" + item.STxnTime + "</td><td>" + item.RTxnDate + "</td><td>" + item.RTxnTime + "</td><td>" + item.XTxnDate + "</td><td>" + item.XTxnTime + "</td><td>" + item.YTxnDate + "</td><td>" + item.YTxnTime + "</td></tr>";
                });
                $("#tbldata").html(row);

                setPagging(reccount, pageindex, pagesize);
                $('#no-data').addClass('hide');
                $('#table-data').removeClass('hide');
            }

        }, '', '', '', '', false, true, '.pageloader', '.history', 'text json', isloader);
        ExportToexcel('printgrid', 'Store Signal Data');
    });
    $(document).on('click', '#pdf', function (e) {
        var pagesize = -1;
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var CustomerId = $('#ddlCustomerID').val();
        var StationLocation = $('#ddlLocation option:selected').text();
        var row = '';
        var reccount = 0;
        var isloader = String(searchby).length == 0 ? true : false
        gl.ajaxreqloader(websiteurlapi + "GetemsStoreSignalStatus", "post", { PageIndex: pageindex, PageSize: pagesize, SortBy: sortby, Searchstr: searchby, CustomerId: CustomerId, StationLocation: StationLocation }, function (response) {
            if (response.length > 0) {
                reccount = response[0].TotalRecords;
                $.each(response, function (i, item) {
                    row += "<tr><td><img src=" + item.StatusImage + " style='width:75px;'></td><td><img src=" + item.SignalImage + " style='width:30px;'></td><td>" + item.StationId + "</td><td>" + item.StationName + "</td><td>" + item.StationLocation + "</td><td>" + item.STxnTime + "</td><td>" + item.RTxnDate + "</td><td>" + item.RTxnTime + "</td><td>" + item.XTxnDate + "</td><td>" + item.XTxnTime + "</td><td>" + item.YTxnDate + "</td><td>" + item.YTxnTime + "</td></tr>";
                });
                $("#tbldata").html(row);

                setPagging(reccount, pageindex, pagesize);
                $('#no-data').addClass('hide');
                $('#table-data').removeClass('hide');
            }

        }, '', '', '', '', false, true, '.pageloader', '.history', 'text json', isloader);
        PrintHtmlTable('printgrid', 'Store Signal Data');
    });
}

function GetSubjects(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var from = $('#StartDate').val();
    var to = $('#EndDate').val();
    var searchby = $('#Searchstr').val();
    var orgid = $('#orgid').val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "Workshop/GetAdminSubjectList", "get", { orgid: orgid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                if (item.Status == 0) {
                    item.Status = "<span class='reddot'></span>";
                }
                else {
                    item.Status = "<span class='greendot'></span>";
                }
                row += "<tr><td>" + item.Status + "</td><td>" + item.Subject + "</td><td>" + item.Title + "</td><td><a href=" + item.YoutubeLink + " target='blank'>" + item.YoutubeLink + "</a></td><td>" + item.CreatedDateDisplay + "</td><td><button class='wrench-bg' onclick='Subjectdetails(" + item.SubjectId + ")'><i class='fas fa-wrench'></i></button></td><td><button class='times-bg' onclick='DeleteSubject(" + item.SubjectId + ")'><i class='fas fa-times'></i></button></td></tr>";
            });
            $("#tbldata").html(row);
            setPagging(reccount, pageindex, pagesize);
            $('.norec').addClass('hide');
            $('.tblcontent,.filt').removeClass('hide');
        }
        else {
            if (String(searchby).length > 0) {
                $('.norec').addClass('hide');
                $('.tblcontent,.filt').removeClass('hide');
                $("#tbldata").html("<tr><td>No Data Found</td></td></tr>");
            }
            else {
                $('.norec').removeClass('hide');
                $('.tblcontent,.filt').addClass('hide');
            }
        }
    }, '', '', '', '', true, true, '.loader', '.tblcontent', 'text json', 'true');
}

function Subjectdetails(id) {
    window.location.href = "AddSubject?id=" + id;
}

function DeleteSubject(sid) {
    var ans = confirm("Are you sure you want to Delete this Subject?");
    if (ans) {
        $.ajax({
            url: apiurl + "workshop/DeleteSubject?sid=" + sid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                getsubjectpage();
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}

function AddSubject() {
    var res = validate();
    if (res == false) {
        return false;
    } else {
        var empObj = {
            SubjectId: $('#SubjectId').val(),
            OrganisationId: $('#OrganisationId').val(),
            Subject: $('#Subject').val(),
            Title: $('#Title').val(),
            Description: $('#Description').val(),
            YoutubeLink: $('#YoutubeLink').val(),
            Status: $('input:checked[name=Status]').val()
        };
        $.ajax({
            url: apiurl + "workshop/AddSubject",
            data: JSON.stringify(empObj),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                //alert(result.StatusCode);
                $("input:text").val("");
                $("#OrganisationId").val(0);
                window.location.href = "Subjects";
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}

function AddChapter() {
    if ($('#ChapterName').val() == "") {
        alert("Enter ChapterName");
        return;
    }
    if ($('#ChapterTitle').val() == "") {
        alert("Enter Title.");
        return;
    } else {
        var empObj = {
            SubjectId: $('#SubjectId').val(),
            ChapterId: $('#ChapterId').val(),
            ChapterName: $('#ChapterName').val(),
            Title: $('#ChapterTitle').val(),
            Description: $('#ChapterDescription').val(),
            YoutubeLink: $('#ChapterYoutubeLink').val(),
            Status:1
        };
        $.ajax({
            url: apiurl + "workshop/AddSubjectChapter",
            data: JSON.stringify(empObj),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                $('#ChapterId').val(0);
                $("input:text").val("");
                $("#ChapterDescription").val("");
                alert("Added Successfully");
               // window.location.href = "Subjects";
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}

function getsubjectchapterpage() {

    GetSubjectChapters(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetSubjectChapters(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#StartDate').val("");
        $('#EndDate').val("");
        $('#Searchstr').val("");
        GetSubjectChapters(1, 10, 1, '');
    });
    $(document).on('click', '#srchbtn', function () {
        GetSubjectChapters(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetSubjectChapters(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetSubjectChapters(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetSubjectChapters(pageindex, pagesize, sortby, searchby);
        $('#Searchstr').focus();
        var $thisVal = $('#Searchstr').val();
        $('#Searchstr').val('').val($thisVal);

    });
    $(document).on("change", '#SortBy', function (event) {
        var pagesize = $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = $('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var region = $("#ddlsearchregion").val();
        var zone = $("#ddlsearchzone").val();
        var division = $("#ddlsearchdevision").val();
        var depo = $("#ddlsearchdepot").val();
        var service = $("#ddlsearchservice").val();
        var date = $("#historydate").val();

        var data = { DepotId: depo, ZoneId: zone, RegionId: region, ServiceDetailsId: service, PageSize: pagesize, PageIndex: pageindex, Searchstr: searchby, SortBy: sortby, Date: decodeURIComponent(date) }
        // setArrivalDeparturePunctualityGrid(data);
        SetCustomGrid(reportsWebsiteUrl + "_ArrivalDepartureReportData", data, 'none', showrepotgridid, 'TSRTC');
        $('#ddlPageSize').val(pagesize);
        $('#SortBy').html($('#dummysortby').html());
        $('#SortBy').val(sortby);
        var url = reportsWebsiteUrl + 'ArrivalDepaturePunctualityReport?rpss=' + pageindex + '|' + pagesize + '|' + sortby + '|' + zone + '|' + region + '|' + division + '|' + depo + '|' + searchby + '|' + decodeURIComponent(date) + '|' + service
        setnavigationurl(url);
    });
    $(document).on('click', '#excel', function (e) {

        var pagesize = -1;
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var CustomerId = $('#ddlCustomerID').val();
        var StationLocation = $('#ddlLocation option:selected').text();
        var row = '';
        var reccount = 0;
        var isloader = String(searchby).length == 0 ? true : false
        gl.ajaxreqloader(websiteurlapi + "GetemsStoreSignalStatus", "post", { PageIndex: pageindex, PageSize: pagesize, SortBy: sortby, Searchstr: searchby, CustomerId: CustomerId, StationLocation: StationLocation }, function (response) {
            if (response.length > 0) {
                reccount = response[0].TotalRecords;
                $.each(response, function (i, item) {
                    row += "<tr><td>" + item.EStatus + "</td><td>" + item.ESignal + "</td><td>" + item.StationId + "</td><td>" + item.StationName + "</td><td>" + item.StationLocation + "</td><td>" + item.STxnTime + "</td><td>" + item.RTxnDate + "</td><td>" + item.RTxnTime + "</td><td>" + item.XTxnDate + "</td><td>" + item.XTxnTime + "</td><td>" + item.YTxnDate + "</td><td>" + item.YTxnTime + "</td></tr>";
                    // row += "<tr><td><img src=" + item.StatusImage + " style='width:75px;'></td><td><img src=" + item.SignalImage + " style='width:30px;'></td><td>" + item.StationId + "</td><td>" + item.StationName + "</td><td>" + item.StationLocation + "</td><td>" + item.STxnTime + "</td><td>" + item.RTxnDate + "</td><td>" + item.RTxnTime + "</td><td>" + item.XTxnDate + "</td><td>" + item.XTxnTime + "</td><td>" + item.YTxnDate + "</td><td>" + item.YTxnTime + "</td></tr>";
                });
                $("#tbldata").html(row);

                setPagging(reccount, pageindex, pagesize);
                $('#no-data').addClass('hide');
                $('#table-data').removeClass('hide');
            }

        }, '', '', '', '', false, true, '.pageloader', '.history', 'text json', isloader);
        ExportToexcel('printgrid', 'Store Signal Data');
    });
    $(document).on('click', '#pdf', function (e) {
        var pagesize = -1;
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var CustomerId = $('#ddlCustomerID').val();
        var StationLocation = $('#ddlLocation option:selected').text();
        var row = '';
        var reccount = 0;
        var isloader = String(searchby).length == 0 ? true : false
        gl.ajaxreqloader(websiteurlapi + "GetemsStoreSignalStatus", "post", { PageIndex: pageindex, PageSize: pagesize, SortBy: sortby, Searchstr: searchby, CustomerId: CustomerId, StationLocation: StationLocation }, function (response) {
            if (response.length > 0) {
                reccount = response[0].TotalRecords;
                $.each(response, function (i, item) {
                    row += "<tr><td><img src=" + item.StatusImage + " style='width:75px;'></td><td><img src=" + item.SignalImage + " style='width:30px;'></td><td>" + item.StationId + "</td><td>" + item.StationName + "</td><td>" + item.StationLocation + "</td><td>" + item.STxnTime + "</td><td>" + item.RTxnDate + "</td><td>" + item.RTxnTime + "</td><td>" + item.XTxnDate + "</td><td>" + item.XTxnTime + "</td><td>" + item.YTxnDate + "</td><td>" + item.YTxnTime + "</td></tr>";
                });
                $("#tbldata").html(row);

                setPagging(reccount, pageindex, pagesize);
                $('#no-data').addClass('hide');
                $('#table-data').removeClass('hide');
            }

        }, '', '', '', '', false, true, '.pageloader', '.history', 'text json', isloader);
        PrintHtmlTable('printgrid', 'Store Signal Data');
    });
}

function GetSubjectChapters(pageindex, pagesize, sortby, searchby) {
    var sid = $('#SubjectId').val();
    var row = '';
    var reccount = 0;
    gl.ajaxreqloader(apiurl + "workshop/GetAdminChaptersListbysubjectid", "get", { sid: sid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: "", ToDate: "" }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                //console.log(item);
                row += "<tr><td>" + item.ChapterName + "</td><td>" + item.Title + "</td><td><a href=" + item.YoutubeLink + " target='blank'>" + item.YoutubeLink + "</a></td><td><button class='wrench-bg' onclick='ChapterDetails(" + item.ChapterId + ")'><i class='fas fa-wrench'></i></button></td><td><button class='times-bg' onclick='deletechapter(" + item.ChapterId + ")'><i class='fas fa-times'></i></button></td><td><button class='times-bg' onclick='Questions(" + item.ChapterId + ")'><i>Questions</i></button></td></tr>";
            });
            $("#chaptertbldata").html(row);
            setPagging(reccount, pageindex, pagesize);
            $('.norec').addClass('hide');
            $('.tblcontent,.filt').removeClass('hide');
        }
        else {
            if (String(searchby).length > 0) {
                $('.norec').addClass('hide');
                $('.tblcontent,.filt').removeClass('hide');
                $("#chaptertbldata").html("<tr><td>No Data Found</td></td></tr>");
            }
            else {
                $('.norec').removeClass('hide');
                $('.tblcontent,.filt').addClass('hide');
            }
        }
    }, '', '', '', '', true, true, 'text json', 'true');
}

function ChapterDetails(id) {
    window.location.href = "AddChapter?id=" + id;
}
function Questions(id) {
    window.location.href = "ChapterQuestions?id=" + id;
}

function ChapterById() {
    var cid = $("#ChapterId").val();
    $.ajax({
        url: apiurl + "workshop/GetChapterDetails?cid=" + cid,
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            $('#SubjectId').val(result.SubjectId);
            //$('#ChapterId').val(result.ChapterId);
            $('#ChapterName').val(result.ChapterName);
            $('#ChapterTitle').val(result.Title);
            $('#ChapterDescription').val(result.Description);
            $('#ChapterYoutubeLink').val(result.YoutubeLink);
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
    return false;
}
function Clear() {
    $('#ChapterId').val(0);
    $("input:text").val("");
    $("#ChapterDescription").val("");
}

function deletechapter(cid) {
    var ans = confirm("Are you sure you want to Delete this Chapter?");
    if (ans) {
        $.ajax({
            url: apiurl + "workshop/DeleteChapter?cid=" + cid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                GetSubjectChapters();
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}

