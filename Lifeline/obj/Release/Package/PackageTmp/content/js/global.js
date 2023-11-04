//var apiurl = 'http://localhost:1223/api/';
var apiurl = Websiteapiurl;
//var apiurl = window.location.protocol + '//' + window.location.hostname + '/api/';
//var apiurl = location.protocol + '://' + location.hostname + '/api/';

//function readURL(input, previewctrl) {
//    if (input.files && input.files[0]) {
//        var reader = new FileReader();

//        reader.onload = function (e) {
//            if (previewctrl != null) {
//                $('#' + previewctrl).attr('src', e.target.result);
//            }
//            else {
//                $('#imgpreview').attr('src', e.target.result);
//            }
//        }

//        reader.readAsDataURL(input.files[0]); // convert to base64 string
//    }
//}

function readMultiURL(input, tgresultdiv) {
    var imgs = [];
    $(tgresultdiv).html('');
    $(input.files).each(function () {
        var reader = new FileReader();
        reader.onload = function (e) {
            $(tgresultdiv).append('<img src="' + e.target.result + '" class="p-2" width="100" height="100" />');
        }
        reader.readAsDataURL(this);
    });

}
function readMultidisplaydivimages(input, tgresultdiv) {
    $('.img').hide();
    var imgs = [];
    //  $(tgresultdiv).html('');
    $(input.files).each(function () {
        var reader = new FileReader();
        reader.onload = function (e) {
            $(tgresultdiv).append('<div class="col-md-2 col-xs-6 px-2"><div class="inputfile-preview" style="background-image: url(' + e.target.result + ')"></div></div>');
            //  $(tgresultdiv).append('<img src="' + e.target.result + '" class="col-md-2 col-xs-6 px-2" />');
        }
        reader.readAsDataURL(this);
    });
}

//function Getgroupsddl() {
//    $.get(apiurl + "getgroupsdropdown", { orgid: $("#orgid").val() }, function (response) {
//        $(response).each(function (i, data) {
//            //console.log(data);
//            $("#grpid").append($('<option/>', { value: data.grpid }).html(data.GroupName));
//        });
//    }, '', '', '', '', false, false);
//    var defvalue = $("#grpid").attr('bindval');
//    $("#grpid").val(defvalue);
//}

function Getmembersddl() {
    gl.ajaxreq(apiurl + "global/GetMembersddl", "get", {}, function (response) {
        $(response).each(function (i, data) {
            $("#MemberId").append($('<option/>', { value: data.MemberId }).html(data.FirstName+' '+LastName));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#MemberId").attr('bindval');
    $("#MemberId").val(defvalue);
}

function GetCountryddl() {
    gl.ajaxreq(apiurl + "GetDdlCountry", "get", {}, function (response) {
        $(response).each(function (i, data) {
            $("#CountryId").append($('<option/>', { value: data.CountryId }).html(data.Country));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#CountryId").attr('bindval');
    $("#CountryId").val(defvalue);
}

function GetStateddl() {
    var cid = $('#CountryId').val();
    $("#StateId").empty();
    $("#StateId").append("<option value='0'>State</option>");
    gl.ajaxreq(apiurl + "GetStateddl", "get", { cid: cid }, function (response) {
        $.each(response, function (index, row) {
            $("#StateId").append("<option value='" + row.StateId + "'>" + row.StateName + "</option>")
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#StateId").attr('bindval');
    $("#StateId").val(defvalue);
}

function GetRegionddl() {
    var sid = $('#StateId').val();
    $("#RegionId").empty();
    $("#RegionId").append("<option value='0'>Select Region</option>");
    gl.ajaxreq(apiurl + "GetRegionddl", "get", { sid: sid }, function (response) {
        $.each(response, function (index, row) {
            $("#RegionId").append("<option value='" + row.RegionId + "'>" + row.Region + "</option>")
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#RegionId").attr('bindval');
    $("#RegionId").val(defvalue);
}

function GetTownddl() {
    var rid = $('#RegionId').val();
    $("#TownId").empty();
    $("#TownId").append("<option value='0'>Select Town</option>");
    gl.ajaxreq(apiurl + "GetTownddl", "get", { rid: rid }, function (response) {
        $.each(response, function (index, row) {
            $("#TownId").append("<option value='" + row.TownId + "'>" + row.Town + "</option>")
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#TownId").attr('bindval');
    $("#TownId").val(defvalue);
}
function GetLocationddl() {
    var tid = $('#TownId').val();
    var mid = $('#MemberId').val();
    $("#LocationId").empty();
    $("#LocationId").append("<option value='0'>Select Location</option>");
    gl.ajaxreq(apiurl + "GetAdminDdlLocation", "get", { tid: tid, mid: mid }, function (response) {
        $.each(response, function (index, row) {
            $("#LocationId").append("<option value='" + row.LocationId + "'>" + row.Location + "</option>")
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#LocationId").attr('bindval');
    $("#LocationId").val(defvalue);
}

function GetCampaignsddl() {
    var mid = $("#MemberId").val();
    gl.ajaxreq(apiurl + "GetCampaignddl", "get", { mid: mid }, function (response) {
        $(response).each(function (i, data) {
            $("#CampaignId").append($('<option/>', { value: data.CampaignId }).html(data.CampaignTitle));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#CampaignId").attr('bindval');
    $("#CampaignId").val(defvalue);
}

//function Getgroupsddl() {
//    $.get(apiurl + "getgroupsdropdown", { orgid: $("#orgid").val() }, function (response) {
//        //$("#ParticipantId").append("<option value=0></option>");
//        $(response).each(function (i, data) {
//            //console.log(data);
//            $("#grpid").append($('<option/>', { value: data.grpid }).html(data.GroupName));
//        });
//    }, '', '', '', '', false, false);
//    var defvalue = $("#grpid").attr('bindval');
//    $("#grpid").val(defvalue);
//}

function GetCategoriesddl() {
    gl.ajaxreq(apiurl + "Videos/GetVideoCategoriesddl", "get", {}, function (response) {
        $(response).each(function (i, data) {
            $("#CategoryId").append($('<option/>', { value: data.CategoryId }).html(data.CategoryName));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#CategoryId").attr('bindval');
    $("#CategoryId").val(defvalue);
}

function GetSubjectddl() {
    gl.ajaxreq(apiurl + "global/GetSujectsddl", "get", { orgid: 0 }, function (response) {
        $(response).each(function (i, data) {
            $("#SubjectId").append($('<option/>', { value: data.SubjectId }).html(data.Subject));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#SubjectId").attr('bindval');
    $("#SubjectId").val(defvalue);
}

function GetChaptersddl() {
    var sid = $('#SubjectId').val();
    $("#ChapterId").empty();
    $("#ChapterId").append("<option value='0'>Chapter</option>");
    gl.ajaxreq(apiurl + "global/GetChaptersddl", "get", { sid: sid }, function (response) {
        $.each(response, function (index, row) {
            //console.log(row);
            $("#ChapterId").append("<option value='" + row.ChapterId + "'>" + row.ChapterName + "</option>")
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#ChapterId").attr('bindval');
    $("#ChapterId").val(defvalue);
}


function GetOrganizationddl() {
    gl.ajaxreq(apiurl + "Organisation/GetOrganisationList", "get", {}, function (response) {

        $(response).each(function (i, data) {
            $("#OrganisationId").append($('<option/>', { value: data.OrganisationId }).html(data.Organisation));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#OrganisationId").attr('bindval');
    $("#OrganisationId").val(defvalue);
}


function GetSearchTagddl() {
    gl.ajaxreq(apiurl + "getsearchtagddl", "get", {}, function (response) {

        $(response).each(function (i, data) {
            $("#searchtagids").append($('<option/>', { value: data.SearchTagIds }).html(data.SearchTag));
        });
    }, '', '', '', '', false, false);
    var defvalue = String($("#searchtagids").attr('bindval')).split(',');
    $("#searchtagids").val(defvalue);
}

function GetFrequencyddl() {
    gl.ajaxreq(apiurl + "GetFrequencyddl", "get", {}, function (response) {
        $(response).each(function (i, data) {
            $("#gamefrequency").append($('<option/>', { value: data.GameFrequencyId }).html(data.Frequency));
        });
    }, '', '', '', '', false, false);
    var defvalue = $("#gamefrequency").attr('bindvalue');
    $("#gamefrequency").val(defvalue);
}

$(function () {
    if (window.jQuery().datetimepicker) {
        $('.datetime').datetimepicker({
            format: 'DD-MMM-YYYY hh:mm a',
            widgetPositioning: {
                horizontal: 'right',
                vertical: 'bottom',
                setDate: new Date()
            },
            // sideBySide: true,
            icons: {
                time: 'fa fa-clock',
                date: 'fa fa-calendar',
                up: 'fa fa-chevron-up',
                down: 'fa fa-chevron-down',
                previous: 'fa fa-chevron-left',
                next: 'fa fa-chevron-right',
                today: 'fa fa-check',
                clear: 'fa fa-trash',
                close: 'fa fa-times'
            }
        });

        $('.date').datetimepicker({
            format: 'DD-MMM-YYYY',
            widgetPositioning: {
                horizontal: 'right',
                vertical: 'bottom',
                setDate: new Date()
            },
            // sideBySide: true,
            icons: {
                date: 'fa fa-calendar',
                up: 'fa fa-chevron-up',
                down: 'fa fa-chevron-down',
                previous: 'fa fa-chevron-left',
                next: 'fa fa-chevron-right',
                today: 'fa fa-check',
                clear: 'fa fa-trash',
                close: 'fa fa-times'
            }
        });
    }
});

// Check html5 support
function IsHtml5Compatible() {
    var test_canvas = document.createElement("canvas");
    return test_canvas.getContext ? true : false;

}

function ExportToexcel(elementid, pagetitle) {
    $('#' + elementid + ' .tbldata  .hiddenprint').remove();
    var fname = pagetitle + '.xls';
    var tab_text = "<table border='1px'>";
    var textRange; var j = 0;
    var tab = document.getElementById('dataTable');
    //  tab = tab.getElementById('dataTable')[0];
    //alert(tab.rows.length);
    for (j = 0 ; j < tab.rows.length ; j++) {

        tab_text = tab_text + "<tr>" + tab.rows[j].innerHTML + "</tr>";
    }
    tab_text = tab_text + "</table>";

    tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
    tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
    tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params
    //tab_text = tab_text.replace('class="hiddenprint"', 'style=display:none');
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
    {
        dumiframexls.document.open("txt/html", "replace");
        dumiframexls.document.write(tab_text);
        dumiframexls.document.close();
        dumiframexls.focus();
        sa = dumiframexls.document.execCommand("SaveAs", true, fname);
    }
    else {
        var data_type = 'data:application/vnd.ms-excel';
        var table_div = tab_text;
        var table_html = table_div.replace(/ /g, '%20');

        var link = document.getElementById('dumlnkxls');
        link.download = fname;
        link.href = data_type + ', ' + table_html;
        link.click();
    }

}

function setnavigationurl(url) {

    if (IsHtml5Compatible) {
        history.pushState("", "Protech", url);
    }
    else {
        window.location.replace(url);
    }
}

function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

function myFunction() {
    var d = new Date();
    var n = d.toLocaleString([], { hour: '2-digit', minute: '2-digit' });
    document.getElementById("time").innerHTML = n;
}

// Read a page's GET URL variables and return them as an associative array.


var gl = {
    ajaxreq: function (serviceurl, reqtype, data, OnSuccess, resctrl, msg, sucmsg, errmsg, isasync, isheader) {
        try {
            $.ajax({
                url: serviceurl,
                type: reqtype,
                headers: isheader ? { 'Authorization': 'Bearer ' + sessionStorage.getItem('accessToken') } : '',
                data: reqtype.toLowerCase() == 'post' ? JSON.stringify(data) : data,
                contentType: "application/json; charset=utf-8",
                dataType: 'text json',
                async: isasync,
                beforeSend: function () {
                    // ajaxprocessindicator(resctrl, msg, 1, 'suc');
                },
                complete: function () {
                    // ajaxprocessindicator(resctrl, sucmsg, 0, 'suc');
                },
                success: OnSuccess,
                error: function (jqXHR, exception) {
                    if (jqXHR.status === 0) {
                        msg = 'Not connect.\n Verify Network.';
                    } else if (jqXHR.status == 404) {
                        msg = 'Requested page not found. [404]';
                    } else if (jqXHR.status == 500) {
                        msg = 'Internal Server Error [500].';
                    } else if (exception === 'parsererror') {
                        msg = 'Requested JSON parse failed.';
                    } else if (exception === 'timeout') {
                        msg = 'Time out error.';
                    } else if (exception === 'abort') {
                        msg = 'Ajax request aborted.';
                    } else {
                        msg = 'Uncaught Error.\n' + jqXHR.responseText;
                    }
                    console.log(msg);
                }
            });
        }
        catch (err) {
            console.log(err.message);// ajaxprocessindicator(resctrl, errmsgprefix + errmsg, 0, 'err');
        }
    },
    ajaxreqloader: function (serviceurl, reqtype, data, OnSuccess, resctrl, msg, sucmsg, errmsg, isasync, isheader, pageloaderdiv, pagecontentdiv, datatype, isloader) {
        try {
            var pageLoader = pageloaderdiv == undefined ? '.loader' : pageloaderdiv;
            var pageContent = pagecontentdiv == undefined ? '.tblcontent' : pagecontentdiv;
            $.ajax({
                url: serviceurl,
                type: reqtype,
                //headers:  //isheader ? { 'Authorization': 'Bearer ' + sessionStorage.getItem('accessToken') } : '',
                data: reqtype.toLowerCase() == 'post' ? JSON.stringify(data) : data,
                contentType: "application/json; charset=utf-8",
                dataType: datatype == undefined ? 'text json' : datatype,
                async: isasync,
                beforeSend: function () {
                    if (isloader) {
                        $(pageLoader).removeClass('hide');
                        $(pageContent).hide();
                    }
                },
                complete: function () {
                    if (isloader) {
                        $(pageLoader).addClass('hide');
                        $(pageContent).show();
                    }
                },
                success: OnSuccess,
                error: function (jqXHR, exception) {
                    $(pageLoader).addClass('hide');
                    if (jqXHR.status === 0) {
                        msg = 'Not connect.\n Verify Network.';
                    } else if (jqXHR.status == 404) {
                        msg = 'Requested page not found. [404]';
                    } else if (jqXHR.status == 500) {
                        msg = 'Internal Server Error [500].';
                    } else if (exception === 'parsererror') {
                        msg = 'Requested JSON parse failed.';
                    } else if (exception === 'timeout') {
                        msg = 'Time out error.';
                    } else if (exception === 'abort') {
                        msg = 'Ajax request aborted.';
                    } else {
                        msg = 'Uncaught Error.\n' + jqXHR.responseText;
                    }
                    console.log(msg);
                }
            });
        }
        catch (err) { console.log(err.message); }
    },

    ajaxpartialreq: function (serviceurl, reqtype, data, OnSuccess, isasync, isheader) {
        try {
            $.ajax({
                url: serviceurl,
                type: reqtype,
                headers: isheader ? { 'Authorization': 'Bearer ' + sessionStorage.getItem('accessToken') } : '',
                data: reqtype.toLowerCase() == 'post' ? JSON.stringify(data) : data,
                contentType: "application/json; charset=utf-8",
                dataType: 'html',
                async: isasync,
                beforeSend: function () {
                    // ajaxprocessindicator(resctrl, msg, 1, 'suc');
                },
                complete: function () {
                    // ajaxprocessindicator(resctrl, sucmsg, 0, 'suc');
                },
                success: OnSuccess,
                error: function (jqXHR, exception) {
                    if (jqXHR.status === 0) {
                        msg = 'Not connect.\n Verify Network.';
                    } else if (jqXHR.status == 404) {
                        msg = 'Requested page not found. [404]';
                    } else if (jqXHR.status == 500) {
                        msg = 'Internal Server Error [500].';
                    } else if (exception === 'parsererror') {
                        msg = 'Requested JSON parse failed.';
                    } else if (exception === 'timeout') {
                        msg = 'Time out error.';
                    } else if (exception === 'abort') {
                        msg = 'Ajax request aborted.';
                    } else {
                        msg = 'Uncaught Error.\n' + jqXHR.responseText;
                    }
                    console.log(msg);
                }
            });
        }
        catch (err) {
            console.log(err.message);// ajaxprocessindicator(resctrl, errmsgprefix + errmsg, 0, 'err');
        }
    },

}


function GetPageLengthArray(reccount) {
    if (reccount <= 100) {
        return [10, 25, 50, 100, -1];
    }
    if (reccount <= 500) {
        return [10, 25, 50, 100, 200, 300, 400, 500, -1];
    }
    else {
        return [10, 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, -1];
    }
}
// to set custome pagging  -- reccount:TotalRecord Cound
function setPagging(reccount, pageindex, pagesize) {
    var fromDisplayNumber = 1;
    var toDisplayNumber = 1;
    var numoffpages = 1;
    if ((parseInt(reccount) % parseInt(pagesize)) == 0) {   // number of pages divides with pagesize: ex reccount 5 ,pagesize 2 then num of pages 5/2=2 + 1=3 ;if reccount 4 then 4%2==0 so 4/2=2
        numoffpages = parseInt(reccount / (parseInt(pagesize) == -1 ? parseInt(reccount) : parseInt(pagesize)));
    }
    else {
        numoffpages = parseInt(parseInt(reccount) / parseInt(pagesize)) + 1;
    }

    if (parseInt(numoffpages) < 5) {      // 5-4 --> page index links displayed
        fromDisplayNumber = 1;
        toDisplayNumber = numoffpages;
    }
    else {
        if (parseInt(pageindex) >= parseInt(numoffpages) - 3) {
            fromDisplayNumber = parseInt(numoffpages) - 3;
            toDisplayNumber = numoffpages;
        }
        else {
            fromDisplayNumber = (parseInt(pageindex) > 1) ? (parseInt(pageindex) - 1) : parseInt(pageindex);
            toDisplayNumber = (parseInt(pageindex) > 1) ? (parseInt(pageindex) + 2) : 4;
        }
    }
    // load page size dropdown
    $('#ddlpagesize').empty();
    var pagesizes = GetPageLengthArray(reccount);
    // alert(pagesizes);
    $(pagesizes).each(function () {
        $('#ddlpagesize').append('<option value=' + this + ' ' + (parseInt(this) == parseInt(pagesize) ? 'selected' : '') + '>' + (parseInt(this) == -1 ? 'All' : this) + '</option>');
    });

    loadPagination(numoffpages, pageindex, fromDisplayNumber, toDisplayNumber);
    $('#totalrec').html(reccount);
    $('#showpageinfo').html('Displaying Page ' + pageindex + ' of ' + numoffpages);
}

// to load pagination bar
function loadPagination(numOfPages, pageindex, fromDisplayNumber, toDisplayNumber) {
    // load pagenation ul.
    //console.log(fromDisplayNumber);
    //console.log(toDisplayNumber);
    //console.log(numOfPages);
    //console.log(pageindex);
    $('.pagination').html('');
    $('.pagination').append('<li class=' + (parseInt(numOfPages) == 1 || parseInt(pageindex) == 1 ? 'avoid-clicks' : '') + '><a class="d-paging" href="javascript:;" _id="1"><i class="fa fa-angle-double-left" aria-hidden="true"></i></a></li>');
    $('.pagination').append('<li class=' + (parseInt(numOfPages) == 1 || parseInt(pageindex) == 1 ? 'avoid-clicks' : '') + '><a class="d-paging" href="javascript:;" _id=' + (parseInt(pageindex) - 1) + '><i class="fa fa-angle-left" aria-hidden="true"></i></a></li>');
    for (var i = fromDisplayNumber; i <= toDisplayNumber; i++) {
        if (i == pageindex) {
            $('.pagination').append('<li class="active"><a href="#" _id=' + i + '>' + i + '</a></li>');

        }
        else {
            $('.pagination').append('<li><a class="d-paging" href="#" _id=' + i + '>' + i + '</a></li>');
        }
    }
    $('.pagination').append('<li class=' + (parseInt(numOfPages) == 1 || parseInt(pageindex) == parseInt(numOfPages) ? 'avoid-clicks' : '') + '><a class="d-paging" href="#" _id=' + (parseInt(pageindex) + 1) + '><i class="fa fa-angle-right" aria-hidden="true"></i></a></li>');
    $('.pagination').append('<li class=' + (parseInt(numOfPages) == 1 || parseInt(pageindex) == parseInt(numOfPages) ? 'avoid-clicks' : '') + '><a class="d-paging" href="#" _id=' + parseInt(numOfPages) + '><i class="fa fa-angle-double-right" aria-hidden="true"></i></a></li>');

}



function formValidate() {

    var error = []
    $('.isvalidate').each(function () {
        var type = $(this).prop('type');
        // alert(type);
        if (type == 'text' || type == 'textarea' || type == 'password' || type == 'hidden') {
            var value = $(this).val();

            if (value.trim() == '' || value == undefined) {
                error.push($(this).attr('errormsg'));
            }
            else {
                var isemail = $(this).hasClass('email');
                if (isemail) {
                    if (!validateEmail(value)) {
                        error.push('Enter Correct Email.');
                    }
                }
            }
        }
        if (type == 'select-one') {
            var value = $(this).val();
            var defult = $(this).attr('default');

            if (value == defult) {
                error.push($(this).attr('errormsg'));
            }
        }
        if (type == 'file') {
            var file = $(this).val();

            if (file == '') {


                error.push('please select File');
            }
            else {
                var acceptfiles = $(this).attr('fileformates').split(',');
                var fextension = file.split('.')[1];
                if (acceptfiles.indexOf(fextension) == -1) {
                    error.push('incorrect file formate');
                }
            }
        }
    });

    return error;
}
//preview image
function readURL(input, tgresult) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $(tgresult).attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}
function validateEmail(sEmail) {
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if (filter.test(sEmail)) {
        return true;
    }

    else {
        return false;

    }

}

function cycleImages() {
    var $active = $('#cycler .active');
    var $next = ($active.next().length > 0) ? $active.next() : $('#cycler img:first');
    $next.css('z-index', 2);//move the next image up the pile
    $active.fadeOut(1500, function () {//fade out the top image
        $active.css('z-index', 1).show().removeClass('active');//reset the z-index and unhide the image
        $next.css('z-index', 3).addClass('active');//make the next image the top one
    });
}

$(document).ready(function () {
    // run every 7s
    setInterval('cycleImages()', 5000);
})

$(document).ready(function () {
    $("#Searchstr").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#tbldata tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

//$(document).ready(function () {
//    $.uploadPreview({
//        input_field: "#image-upload",   // Default: .image-upload
//        preview_box: "#image-preview",  // Default: .image-preview
//        label_field: "#image-label",    // Default: .image-label
//        label_default: "Choose File",   // Default: Choose File
//        label_selected: "Change File",  // Default: Change File
//        no_label: false                 // Default: false
//    });
//});

//$(document).ready(function () {
//    $.uploadPreview({
//        input_field: "#backimage-upload",   // Default: .image-upload
//        preview_box: "#backimage-preview",  // Default: .image-preview
//        label_field: "#image-label",    // Default: .image-label
//        label_default: "Choose File",   // Default: Choose File
//        label_selected: "Change File",  // Default: Change File
//        no_label: false                 // Default: false
//    });
//});

//$(document).ready(function () {
//    $.uploadPreview({
//        input_field: "#bannerimage-upload",   // Default: .image-upload
//        preview_box: "#bannerimage-preview",  // Default: .image-preview
//        label_field: "#image-label",    // Default: .image-label
//        label_default: "Choose File",   // Default: Choose File
//        label_selected: "Change File",  // Default: Change File
//        no_label: false                 // Default: false
//    });
//});

//$(document).ready(function () {
//    $.uploadPreview({
//        input_field: "#menuimage-upload",   // Default: .image-upload
//        preview_box: "#menuimage-preview",  // Default: .image-preview
//        label_field: "#image-label",    // Default: .image-label
//        label_default: "Choose File",   // Default: Choose File
//        label_selected: "Change File",  // Default: Change File
//        no_label: false                 // Default: false
//    });
//});


//$(document).ready(function () {
//    $.uploadPreview({
//        input_field: "#image-upload",   // Default: .image-upload
//        preview_box: "#image-preview",  // Default: .image-preview
//        label_field: "#image-label",    // Default: .image-label
//        label_default: "Choose File",   // Default: Choose File
//        label_selected: "Change File",  // Default: Change File
//        no_label: false                 // Default: false
//    });
//});

$(document).ready(function () {
    $('.inputfile-preview').each(function () {
        $.uploadPreview({
            input_field: $(this).find("input"),   // Default: .image-upload
            preview_box: $(this),  // Default: .image-preview
            label_field: $(this).find("label"),    // Default: .image-label
            label_default: "Choose File",   // Default: Choose File
            label_selected: "Change File",  // Default: Change File
            no_label: false                 // Default: false
        });
    });

});

function fileuploadimgpreview(inputfile, prvbox) {
    $.uploadPreview({
        input_field: inputfile,            // Default: .image-upload
        preview_box: prvbox,             // Default: .image-preview
        label_field: $(prvbox).children('label'),    // Default: .image-label
        label_default: "",   // Default: Choose File
        label_selected: "",  // Default: Change File
        no_label: false                 // Default: false
    }
    );

    $(prvbox).children('label').css("background-color", "transparent");
    var ccoutputimg = $(inputfile).attr('data-ccoutput');
    if (".background-image" != null) {
        $("#labelimg").hide();
    }

    if (ccoutputimg != undefined) {

        ccoutputprivewimage(inputfile, '.' + ccoutputimg);
    }
}
