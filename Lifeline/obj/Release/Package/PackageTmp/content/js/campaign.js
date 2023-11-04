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


function getcampaignpage() {

    GetCampaigns(1, 10, 1, '');
    $(document).on("change", '#volunteer', function (event) {
        GetCampaigns(1, 10, 1, '');
    });
    $(document).on('click', '#shwbtn', function () {
        GetCampaigns(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#StartDate').val("");
        $('#EndDate').val("");
        $('#Searchstr').val("");
        GetCampaigns(1, 10, 1, '');

    });
    $(document).on('click', '#srchbtn', function () {
        GetCampaigns(1, 10, 1, '');

    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetCampaigns(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetCampaigns(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {
        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        GetCampaigns(pageindex, pagesize, sortby, searchby);
        $('#Searchstr').focus();
        var $thisVal = $('#Searchstr').val();
        $('#Searchstr').val('').val($thisVal);

    });
}
//<td><button class='times-bg' onclick='DeleteEvent(" + item.MemberId + ")'><i class='fas fa-times'></i></button></td>
function GetCampaigns(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var searchby = $('#Searchstr').val();
    var mid = $("#MemberId").val();
    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "GetAdminCampaigns", "get", { mid: mid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                row += "<tr><td><img src='" + item.ImagePath + "' class='grimg'/></td><td>" + item.CampaignTitle + "</td><td>" + item.Datestring + "</td><td>" + item.Timestring + "</td><td>" + item.Location + "</td><td><button class='wrench-bg' onclick='Eventdetails(" + item.CampaignId + ")'><i class='fa fa-wrench'></i></button></td></tr>";
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

function Eventdetails(id) {
    window.location.href = "AddCampaign?id=" + id;
}

function DeleteEvent(Eid) {
    var ans = confirm("Are you sure you want to Delete this Event?");
    if (ans) {
        $.ajax({
            url: apiurl + "events/DeleteEvent?Eid=" + Eid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                getEvetpage();
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
