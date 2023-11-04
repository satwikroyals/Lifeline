$(document).ready(function () {
    var pageurl = window.location.href.toLowerCase();
    if (pageurl.indexOf("workshopenquiries") != -1) {
        $("#enquirytab-show").addClass('active');
    }
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

function getenquirypage() {

    GetWorkshopEnquiries(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetWorkshopEnquiries(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#StartDate').val("");
        $('#EndDate').val("");
        $('#Searchstr').val("");
        GetWorkshopEnquiries(1, 10, 1, '');
    });
    $(document).on('click', '#srchbtn', function () {
        GetWorkshopEnquiries(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetWorkshopEnquiries(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetWorkshopEnquiries(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetWorkshopEnquiries(pageindex, pagesize, sortby, searchby);
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

function GetWorkshopEnquiries(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var from = $('#StartDate').val();
    var to = $('#EndDate').val();
    var searchby = $('#Searchstr').val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "Workshop/GetAdminWorkshopEnquiries", "get", { pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                row += "<tr><td>" + item.Title + "</td><td>" + item.ChapterName + "</td><td>" + item.MemberName + "</td><td>" + item.MemberEmail + "</td><td>" + item.MemberMobile + "</td><td>" + item.Message + "</td><td>" + item.EnquiryDateDisplay + "</td></tr>";
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

function Eventdetails(id) {
    window.location.href = "AddProduct?id=" + id;
}

function DeleteEvent(Eid) {
    var ans = confirm("Are you sure you want to Delete this Product?");
    if (ans) {
        $.ajax({
            url: apiurl + "products/DeleteProduct?pid=" + Eid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                getProductpage();
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}

function EventDetails(eid) {
    $.ajax({
        url: apiurl + "GetEventById?eid=" + eid,
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            $('#Title').val(result.Title);
            $('#ContactPerson').val(result.ContactPerson);
            $('#ContactPhone').val(result.ContactPhone);
            $('#ContactEmail').val(result.ContactEmail);
            $('#StartDate').val(result.StartDateString);
            $('#EndDate').val(result.EndDateString);
            $('#Description').val(result.Description);
            $('#IsBookingNeeded').val(result.IsBookingNeeded);
            //$('#Image').val(result.Image);
            $('#tempimg').attr('src', result.EventImagePath);
            $('#hidbinary').val(result.Image);
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
    return false;
}
