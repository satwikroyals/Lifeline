$(document).ready(function () {
    var pageurl = window.location.href.toLowerCase();
    if (pageurl.indexOf("viewvideos") != -1) {
        $("#tab-show").addClass('active');
    }
    if (pageurl.indexOf("addvideo") != -1) {
        $("#videotab-add").addClass('active');
    }
    $('.staticddl').each(function () {
        $(this).val($(this).attr('bindvalue'));
    });
});

function validate() {
    //isValid = true;
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

function getNetworkpage() {

    GetNetworks(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetNetworks(1, 10, 1, '');
    });
    $(document).on('click', '#shwall', function () {
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetNetworks(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#StartDate').val("");
        $('#EndDate').val("");
        $('#grpid').val(0);
        $('#Searchstr').val("");
        GetNetworks(1, 10, 1, '');
    });
    $(document).on('click', '#srchbtn', function () {
        GetNetworks(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetNetworks(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetNetworks(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetNetworks(pageindex, pagesize, sortby, searchby);
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
}

function GetNetworks(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var orgid = $("#orgid").val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "Videos/GetAdminVideoList", "get", { categoryid: 0, orgid: orgid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                const video = getId(item.VideoLink);
                var vid = 'https://www.youtube.com/embed/' + video;
                //console.log(videoId);
                row += "<tr><td><div><iframe src='" + vid + "' frameborder='0' allowfullscreen width='150' height='100'></iframe></div></td><td>" + item.Title + "</td><td>" + item.PublishOnDisplay + "</td><td>" + item.CreatedDateDisplay +
                  "</td><td><button class='wrench-bg' onclick='Networkdetails(" + item.VideoId + ")'><i class='fas fa-wrench'></i></button></td><td><button class='times-bg' onclick='DeleteVideo(" + item.VideoId + ")'><i class='fas fa-times'></i></button></td></tr>";
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

function Networkdetails(id) {
    window.location.href = "VideoDetails?id=" + id;
}

function DeleteVideo(vid) {
    var ans = confirm("Are you sure you want to Delete this Video?");
    if (ans) {
        $.ajax({
            url: apiurl + "Videos/DeleteVideo?vid=" + vid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                getNetworkpage();
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}
function SetTopVideos() {
    var netobj = {
        NetWorkId: $('[name ="NetWorkId"]').val(),
    };
    //var ans = confirm("Are you sure you want to Delete this Event?");
    //if (ans) {
    $.ajax({
        url: apiurl + "AddTopVideos",
        data: JSON.stringify(netobj),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //getEvetpage();
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
    //}
}


function GetTopNetworkVideos() {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var orgid = $('#orgid').val();
    var searchby = $('#Searchstr').val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "GetTopVideos", "get", null, function (response) {
        if (response.length > 0) {
            //reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                const videoId = getId(item.VideoLink);
                var vid = 'https://www.youtube.com/embed/' + videoId;
                //console.log(videoId);
                row += "<tr><td><div><iframe src='" + vid + "' frameborder='0' allowfullscreen width='150' height='100'></iframe></div></td><td>" + item.Title + "</td><td>" + item.DisplayPublish + "</td><td>" + item.CreatedDatestring +
                  "</td></tr>";
            });
            $("#toptbldata").html(row);
            //setPagging(reccount, pageindex, pagesize);
            $('.norec').addClass('hide');
            $('.tblcontent').removeClass('hide');
        }
        //else {
        //    if (String(searchby).length > 0) {
        //        $('.norec').addClass('hide');
        //        $('.tblcontent').removeClass('hide');
        //        $("#orgtbldata").html("<tr><td>No Data Found</td></td></tr>");
        //    }
        //    else {
        //        $('.norec').removeClass('hide');
        //        $('.tblcontent').addClass('hide');
        //    }
        //}
    }, '', '', '', '', true, true, '.loader', '.tblcontent', 'text json', 'true');
}

//function checkcount() {
//    var days = $('input[type="checkbox"]:checked').length;
//    //console.log(days);
//    if (days == 3) {
//        $('input[type="checkbox"]').not(':checked').prop('diabled', true);
//        alert('Not more then 10 videos.');
//    }
//}
function checkcount() {
    var noChecked = 0;
    $.each($('.boxes'), function () {
        if ($(this).is(':checked')) {
            noChecked++;
        }
    });
    if (noChecked >= 10) {
        alert('Sorry limited for only 10 videos.')
        $.each($('.boxes'), function () {
            if ($(this).not(':checked').length == 1) {
                $(this).attr('disabled', 'disabled');
            }
        });
    } else {
        $('.boxes').removeAttr('disabled');
    };
}


function getId(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
    const match = url.match(regExp);

    return (match && match[2].length === 11)
      ? match[2]
      : null;
}

//$(document).ready(function () {
//    function getId(url) {
//        const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
//        const match = url.match(regExp);

//        return (match && match[2].length === 11)
//          ? match[2]
//          : null;
//    }

//    //const videoId = getId('http://www.youtube.com/watch?v=zbYf5_S7oJo');
//    //const iframeMarkup = '<iframe width="560" height="315" src="//www.youtube.com/embed/'
//    //    + videoId + '" frameborder="0" allowfullscreen></iframe>';

//    //console.log('Video ID:', videoId)
//});

