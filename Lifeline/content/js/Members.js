
$(document).on('click', '#addbtn', function () {
    AddMember();
});

function validate() {
    var error = [];
    error = formValidate();
    //var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/
    //if ($('#fname').val().trim() == "") {
    //    error.push("Please enter FirstName.");
    //    isValid = false;
    //}
    //if ($('#lname').val().trim() == "") {
    //    error.push("Please enter LastName.");
    //    isValid = false;
    //}
    //if ($('#password').val().trim() == "") {
    //    error.push("Please enter your Password.");
    //    isValid = false;
    //}
    //else if ($('#ConfirmPassword').val().trim() == "") {
    //    error.push("Please enter Confirm Password.");
    //    isValid = false;
    //}
    //else if ($('#password').val() != $('#ConfirmPassword').val()) {
    //    error.push("Password did not match: Please try again...")
    //    isValid = false;
    //}
    //if ($('#mobile').val().trim() == "") {
    //    error.push("Please give Phone Number.");
    //    isValid = false;
    //}
    //if ($('#email').val().trim() == "") {
    //    error.push("Please enter a E-mail.");
    //    isValid = false;
    //}
    //else if ($('#email').val().match(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/)) {
    //    error.push();
    //}
    //else {
    //    error.push("Invalid e-mail.");
    //    isValid = false;
    //}
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

function AddMember() {
    isValid = true;
    var res = validate(this);
    if (res == false) {
        return false;
    }
    else {
        var cusObj = {
            orgid: $('#orgid').val(),
            fname: $('#fname').val(),
            lname: $('#lname').val(),
            Mobile: $('#mobile').val(),
            EmailId: $('#email').val(),
            Password: $('#password').val(),
            CountryId: $('#CountryId').val(),
            CityId: $('#CityId').val(),
            GroupId: $('#GroupId').val(),
            IsCmtMember: $('#IsCmtMember').val(),
        };
        $.ajax({
            url: apiurl + "CustomerRegistration",
            data: JSON.stringify(cusObj),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (StatusResponse) {
                if (StatusResponse.StatusCode == -1) {
                    document.getElementById("error").innerHTML = "This Email Already Exist give Another";
                    isValid = false;
                    return isValid;
                }
                else if (StatusResponse.StatusCode == -2) {
                    document.getElementById("error").innerHTML = "This Mobile Number Already Exist give Another'";
                    isValid = false;
                    return isValid;
                }
                else {
                    $('#success').addClass('show');
                    $('#success').removeClass('hide');
                    //$('#success').show();
                    document.getElementById("success").innerHTML = "Registered Successfully";
                    cleartext();
                    //$('#error').hide();
                }
            },
            error: function (result) {
                //alert(errormessage.responseText);

            }
        });
    }
}

function cleartext() {
    $('#fname').val(""),
    $('#lname').val(""),
    $('#mobile').val(""),
    $('#email').val(""),
    $('#password').val(""),
    $('#Confirmpassword').val(""),
    $('#CountryId').val(0),
    $('#CityId').val(0),
    $('#IsCmtMember').val("")
}

function getMemberspage() {

    GetMembers(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetMembers(1, 10, 1, '');
    });
    $(document).on('click', '#shwall', function () {
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetMembers(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#grpid').val(0);
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetMembers(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        GetMembers(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        GetMembers(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {

        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var CustomerId = $('#ddlCustomerID').val();
        var StationLocation = $('#ddlLocation option:selected').text();
        GetstoreSignalData(pageindex, pagesize, sortby, searchby, CustomerId, StationLocation);
        $('#Searchstr').focus();
        // this.focus();
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

function GetMembers(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var groupid = $('#grpid').val();
    var orgid = $('#orgid').val();
    var searchby = $('#Searchstr').val();
    var from = $('#StartDate').val();
    var to = $('#EndDate').val();
    var commitee;
    //$("input:checkbox[name=Committee]:checked").prop(function () {
    //    commitee = 1;
    //});
    if ($('#Committee').is(":checked")) {
        commitee = "1";
    }
    else { commitee = "0"; }

    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "GetCustomerList", "get", { orgid: orgid, grpid: groupid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to, Committee: commitee }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                row += "<tr><td><img src='" + item.CustomerImagePath + "' class='tblimgrw'/></td><td>" + item.fname + "</td><td>" + item.lname + "</td><td>" + item.Mobile + "</td><td>" + item.EmailId + "</td><td>" + item.Profession + "</td><td>" + item.CountryName + "</td><td>" + item.ModifiedDateString + "</td><td><button class='wrench-bg' onclick='MemberDetails(" + item.CustomerId + ")'><i class='fas fa-wrench'></i></button></td></tr>";
            });
            $("#tbldata").html(row);
            setPagging(reccount, pageindex, pagesize);
            $('.norec').addClass('hide');
            $('.tblcontent').removeClass('hide');
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


function getPartnerMemberspage() {

    GetPartnerMembers(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetPartnerMembers(1, 10, 1, '');
    });
    $(document).on('click', '#shwall', function () {
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetPartnerMembers(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#grpid').val(0);
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetPartnerMembers(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        GetPartnerMembers(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        GetPartnerMembers(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {

        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();
        var CustomerId = $('#ddlCustomerID').val();
        var StationLocation = $('#ddlLocation option:selected').text();
        GetstoreSignalData(pageindex, pagesize, sortby, searchby, CustomerId, StationLocation);
        $('#Searchstr').focus();
        // this.focus();
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

function GetPartnerMembers(pageindex, pagesize, sortby, searchby) {
    //  $('.pageloader').removeClass("hide");
    //alert('dfr');
    var groupid = $('#grpid').val();
    var orgid = $('#orgid').val();
    var searchby = $('#Searchstr').val();
    var from = $('#StartDate').val();
    var to = $('#EndDate').val();
    var commitee;
    //$("input:checkbox[name=Committee]:checked").prop(function () {
    //    commitee = 1;
    //});
    if ($('#Committee').is(":checked")) {
        commitee = "1";
    }
    else { commitee = "0"; }

    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false
    gl.ajaxreqloader(apiurl + "GetCustomerList", "get", { orgid: orgid, grpid: groupid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to, Committee: commitee }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {         
                row += "<tr><td><img src='" + item.CustomerImagePath + "' class='tblimgrw'/></td><td>" + item.fname + "</td><td>" + item.lname + "</td><td>" + item.Mobile + "</td><td>" + item.EmailId + "</td><td>" + item.Profession + "</td><td>" + item.CountryName + "</td><td>" + item.ModifiedDateString + "</td></tr>";
            });
            $("#tbldata").html(row);
            setPagging(reccount, pageindex, pagesize);
            $('.norec').addClass('hide');
            $('.tblcontent').removeClass('hide');
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

function MemberDetails(id) {
    window.location.href = "AddMember?id=" + id;
}

//$('#Committee').change(function () {
//    if ($(this).is(":checked")) {
//        Commitee = 1;
//    } else {
//        Commitee = 0;
//    }
//    //Committe.push($(this).val());
//});
//<td><div class='checkbox custom-checkbox my-0'> <label class='pl-2 prussian-txt'><input type='checkbox' id='chk_1' name='MediaTypeId' value='1'><span class='checkmark'></span></label></div></td>