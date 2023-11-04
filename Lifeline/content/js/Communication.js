
function getPartnerMemberspage() {

    GetPartnerMembers(1, 10, 1, '');
    var AllcusIds = GetAllCustomerIds(1, 0);

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



    $(document).on('change', '.allpgchk', function () {
        var chk = $(this).is(':checked');
        if (chk) {
            $('#chkedcustomers').val(String(AllcusIds));
            $('.chkbox').prop('checked', 'checked');
        }
        else {
            $('#chkedcustomers').val('');
            $('.chkbox').prop('checked', false);
        }

    });

    $(document).on('change', '.curpgchk', function () {
        var chk = $(this).is(':checked');
        var checkedids = String($('#chkedcustomers').val()).split(',');
        if (chk) {
            // $('#chkedcustomers').val();

            $('.chkbox').each(function () {
                var id = String($(this).prop('id')).split('_')[1];
                var index = checkedids.indexOf(id);
                if (index == -1) {
                    checkedids.push(id);
                }
                $(this).prop('checked', 'checked');
            });

        }
        else {
            // var checkedids = String($('#chkedcustomers').val()).split(',');
            $('#chkedcustomers').val('');
            $('.chkbox').each(function () {
                var id = String($(this).prop('id')).split('_')[1];

                var index = checkedids.indexOf(id);
                checkedids.splice(index, 1);
                $(this).prop('checked', false);
            });
        }
        $('#chkedcustomers').val(String(checkedids));
    });
    $(document).on('change', '.chkbox', function () {
        var checkedids = String($('#chkedcustomers').val()).split(',');
        var chk = $(this).is(':checked');
        if (chk) {
            var id = String($(this).prop('id')).split('_')[1];
            var index = checkedids.indexOf(id);
            if (index == -1) {


                checkedids.push(id);
            }
        }
        else {
            var id = String($(this).prop('id')).split('_')[1];

            var index = checkedids.indexOf(id);
            checkedids.splice(index, 1);

        }
        $('#chkedcustomers').val(String(checkedids));
    });
}

function getPartenerCommunicationpage() {
    GetPartnetrCommunications(1, 10, 1, '');
    $(document).on('click', '#shwbtn', function () {
        GetPartnetrCommunications(1, 10, 1, '');
    });
    $(document).on('click', '#shwall', function () {
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetPartnetrCommunications(1, 10, 1, '');
    });
    $(document).on('click', '#shwallbtn', function () {
        $('#grpid').val(0);
        $('#Searchstr').val("");
        $('#StartDate').val("");
        $('#EndDate').val("");
        GetPartnetrCommunications(1, 10, 1, '');
    });
    $(document).on("click", ".d-paging", function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = $(this).attr('_id');
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        GetPartnetrCommunications(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("change", '#ddlpagesize', function (event) {

        var pagesize = $('#ddlpagesize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = '';//$('#Searchstr').val();
        GetPartnetrCommunications(pageindex, pagesize, sortby, searchby);
    });
    $(document).on("keyup", '#Searchstr', function (event) {

        var pagesize = 10;// $('#ddlPageSize').val();
        var pageindex = 1;
        var sortby = 1; //$('#SortBy').val();
        var searchby = $('#Searchstr').val();

        GetPartnetrCommunications(pageindex, pagesize, sortby, searchby);
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
        GetPartnetrCommunications(pageindex, pagesize, sortby, searchby);
    });
}

function GetPartnerMembers(pageindex, pagesize, sortby, searchby) {

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
    var isloader = String(searchby).length == 0 ? true : false;
    var ids = $('#chkedcustomers').val().split(',');
    console.log(ids);
    gl.ajaxreqloader(apiurl + "GetCustomerList", "get", { orgid: orgid, grpid: groupid, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to, Committee: commitee }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {
                var indx = ids.indexOf(String(item.CustomerId));
                console.log(indx);
                if (indx != -1) {
                    row += "<tr><td><input class='chkbox' id='chkid_" + item.CustomerId + "' checked='checked'  type='checkbox'></td><td><img src='" + item.CustomerImagePath + "' class='tblimgrw'/></td><td>" + item.fname + "</td><td>" + item.lname + "</td><td>" + item.Mobile + "</td><td>" + item.EmailId + "</td><td>" + item.CountryName + "</td><td>" + item.ModifiedDateString + "</td></tr>";
                }
                else {
                    row += "<tr><td><input class='chkbox' id='chkid_" + item.CustomerId + "' type='checkbox'></td><td><img src='" + item.CustomerImagePath + "' class='tblimgrw'/></td><td>" + item.fname + "</td><td>" + item.lname + "</td><td>" + item.Mobile + "</td><td>" + item.EmailId + "</td><td>" + item.CountryName + "</td><td>" + item.ModifiedDateString + "</td></tr>";

                }
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

function GetPartnetrCommunications(pageindex, pagesize, sortby, searchby) {

    var groupid = $('#grpid').val();
    var partid = $('#partid').val();
    var fromtype = $('#fromtype').val();
    var orgid = $('#orgid').val();
    var searchby = $('#Searchstr').val();
    var from = $('#StartDate').val();
    var to = $('#EndDate').val();

    var row = '';
    var reccount = 0;
    var isloader = String(searchby).length == 0 ? true : false;

    gl.ajaxreqloader(apiurl + "GetCommunications", "get", { fromid: partid, fromtype: fromtype, pgindex: pageindex, pgsize: pagesize, sortby: sortby, str: searchby, FromDate: from, ToDate: to, Committee: 0 }, function (response) {
        if (response.length > 0) {
            reccount = response[0].TotalRecords;
            $.each(response, function (i, item) {

                row += "<tr><td>" + item.CommunicationType + "</td><td>" + (item.Message) + "</td><td>" + item.ReceipentCount + "</td><td>" + item.CreatedDateString + "</td></tr>";

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

function GetAllCustomerIds(orgid, groupid) {
    var ids;
    gl.ajaxreqloader(apiurl + "GetAllCustomerIds", "get", { orgid: orgid, grpid: groupid }, function (response) {
        //console.log(response);
        ids = response;

    }, '', '', '', '', false, false, '.loader', '.tblcontent', 'text json', 'true');
    return ids;

}
function sendcommunication(id) {
    $('#' + id).submit();
}