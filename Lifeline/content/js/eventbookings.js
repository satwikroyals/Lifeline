﻿$(document).ready(function () {
    var pageurl = window.location.href.toLowerCase();
    if (pageurl.indexOf("eventbookings") != -1) {
        $("#eventbooktab-show").addClass('active');
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

function setvieweventbookings() {
    getEventBookings(1, 10, 1, '');
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val(); 
        getEventBookings(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        getEventBookings(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#EventId', function (event) {
        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        getEventBookings(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        getEventBookings(pageindex, pagesize, sortby, searchby);
        $('#Searchstr').focus();
        var $thisVal = $('#Searchstr').val();
        $('#Searchstr').val('').val($thisVal);

    });
}

function getEventBookings(pageindex, pagesize, sortby, searchby) {
    var from = $('#StartDate').val();
    var to = $('#EndDate').val();
    var searchby = $('#Searchstr').val();
    var orgid = $('#orgid').val();
    var eid = $('#EventId').val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "Events/GetAdminEventBookings", "get", { orgid: orgid, eid: 0, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                row += "<tr><td>" + item.BookingId + "</td><td><img src='" + item.EventImagePath + "' class='tblimgrw'/></td><td>" + item.Title + "</td><td>" + item.MemberName + "</td><td>" + item.MemberEmail + "</td><td>" + item.MemberMobile + "</td><td>" + item.TotalTickets + "</td><td>" + item.DisplayTotalTicketPrice + "</td><td>" + item.DisplayBookingDate + "</td><td><button class='wrench-bg' onclick='BookingDetails(" + item.BookingId + ")'><i class='fas fa-eye'></i></button></td></tr>";
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

function Locationdetails(id) {
    window.location.href = "AddLocation?id=" + id;
}
function BookingDetails(bid) {
    $('#myModal').modal('show');
    var row = '';
    var reccount = 0;
    gl.ajaxreqloader(apiurl + "Events/GetAdminEventBookingDetails", "get", { bid: bid }, function (response) {
        //$('#cookinginstructions').val(response[0].cookingInstruction);
        //$('#total').html(response[0].TotalBillDisplay);
        $('#BookingId').val(bid);
        if (response.length > 0) {
            $.each(response, function (i, item) {
                if (item.IsAdult == false)
                {
                    item.IsAdult = "No";
                }
                else {
                    item.IsAdult = "Yes";
                }
                row += "<tr><td>" + item.Name + "</td><td>" + item.Email + "</td><td>" + item.Mobile + "</td><td>" + item.IsAdult + "</td></tr>";
            });
            $("#itemtbldata").html(row);
            //$('.norec').addClass('hide');
            //$('.tblcontent,.filt').removeClass('hide');
        }
        else {
            if (String(searchby).length > 0) {
                //$('.norec').addClass('hide');
                //$('.tblcontent,.filt').removeClass('hide');
                $("#itemtbldata").html("<tr><td>No Data Found</td></td></tr>");
            }
            else {
                $('.norec').removeClass('hide');
                $('.tblcontent,.filt').addClass('hide');
            }
        }
    }, '', '', '', '', true, true, '.loader', '.tblcontent', 'text json', 'true');
}

function SendOrdertokitchen() {
    var oid = $('#orderId').val();
    var ans = "";
    if (status == 2) {
        ans = confirm("Are you sure you want to Send this order to kitchen?");
    }
    {
        gl.ajaxreqloader(websiteurl + "api/MerchantOrderAction", "get", { oid: oid, Status: 2 }, function (response) {
            setViewfoodorders();
        });
    }
}

function Deliver() {
    var oid = $('#orderId').val();
    var ans = "";
    {
        gl.ajaxreqloader(websiteurl + "api/MerchantOrderAction", "get", { oid: oid, Status: 3 }, function (response) {
            setViewfoodorders();
        });
    }
}

function DeleteLocation(lid) {
    var ans = confirm("Are you sure you want to Delete this Location?");
    if (ans) {
        $.ajax({
            url: apiurl + "DeleteLocation?lid=" + lid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                setViewLocations();
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
}

$(document).ready(function () {
    var pageurl = window.location.href.toLowerCase();
    if (pageurl.indexOf("viewlocations") != -1) {
        $("#tab-showlocation").addClass('active');
    }
    if (pageurl.indexOf("addlocation") != -1) {
        $("#tab-addlocation").addClass('active');
    }
});



