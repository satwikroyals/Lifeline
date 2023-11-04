//1 - On , 0 - Off
$(document).ready(function () {
    //var pageurl = window.location.href.toLowerCase();
    //if (pageurl.indexOf("ChapterQuestions") != -1) {
    //    $("#surtab-add").addClass('active');
    //}
    $('.multiselectddl').multiSelect(
       { 'noneText': '--- select Locations ----' }
   );
    $('#subbtn').on('click', function () {
        $('#Locations').val($('#ddLocations').val());
    });
});

function GetChapterQandA(cid, sname) {
    $('.dsqsurveyname').html(sname);
    $('.dsquestionsgv').attr('data-sid', sid).attr('data-sname', sname);
    //$('.dsanseditsurvey').attr('href', editurl+"#surveyId");
    gl.ajaxreqloader(apiurl + "workshop/GetAdminChapterQuestions", "get", { cid: cid }, function (response) {
        //var resp = $.parseJSON(response.d);
        $.each(response, function (i, item) {
            var cnt = $('.divsquestionsdummy').clone();
            $('.dsqquestionname', cnt).html(item.question);
            var respans = $.parseJSON(JSON.stringify(item.answers));
            $.each(respans, function (j, itemans) {
                $('.dsanslist', cnt).append('<li class="answer"><p class="form-control-static">' + itemans.Answer + '</p></li>');
            });
            $('.dsquestionsgv').append(cnt.html());
        });
    }, $('#lblsqppupres'), 'Loading Questions...', '', 'getting Questions.');
}

function GetChapterQandAedit(cid) {
    $('.dsqadivedit').attr('data-sid', cid);
    var cnt = $('.divsqaeditdummy').clone();
    var qcount = 0;
    var acount = 0;
    //if (cid == '0') {
    //    SetChapterQandAEmptyedit(cnt);
    //}
    //else {
    gl.ajaxreqloader(apiurl + "workshop/GetAdminChapterQuestions", "get", { cid: cid }, function (response) {
        if (response.question == "") {
                SetChapterQandAEmptyedit(cnt);
            }
            else {
                $.each(response.question, function (i, item) {
                    cnt = $('.divsqaeditdummy').clone();

                    qcount++;
                    if (i == 0) {
                        $('.survey-question > a:first', cnt).remove();
                        //  $('.qpreviewq', previewcnt).attr('id', 'txtq' + qcount.toString()).attr('data-qid', item.SurveyquetionId).html('Q) ' + item.Question);                        
                    }
                    $('.survey-question', cnt).addClass('question-' + qcount.toString()).attr('data-qid', item.questionId);
                    $('.txtq', cnt).attr('id', 'txtq' + qcount.toString()).attr('data-qid', item.questionId).text(item.Question);
                    $('.dsanslistedit', cnt).addClass('answer-fieldlist-' + qcount.toString());
                    $('.answers > button', cnt).addClass('addanswer-btn-' + qcount.toString()).attr('data-target', 'answer-fieldlist-' + qcount.toString());
                    $.each(item.Answers, function (j, itemans) {
                        //console.log(itemans);
                        acount++;

                        if (j == 0) {
                            $('.dsanslistedit', cnt).append('<li class="answer col-xs-12 px-2">' +
                                '<div class="col-xs-12 px-0 mb-3">' +
                                '<div class="input-group">' +
                                '<input id="txta' + acount.toString() + '" type="text" class="form-control main-input border-right txta surveyans-ctrl" name="email" placeholder="Enter your answer here" value="' + itemans.Answer + '" data-aid=' + itemans.SurveyanswerId + '>' +
                                '<span class="input-group-addon main-input nobg"></span></div></div>' +
                                '</li>');
                        }
                        else {
                            $('.dsanslistedit', cnt).append(
                                '<li class="answer col-xs-12 px-2">' +
                                '<div class="col-xs-12 px-0 mb-3">' +
                                '<div class="input-group">' +
                                '<input id="txta' + acount.toString() + '" type="text" class="form-control main-input border-right txta surveyans-ctrl" name="email" placeholder="Enter your answer here" value="' + itemans.Answer + '" data-aid=' + itemans.SurveyanswerId + '>' +
                                '<span class="input-group-addon main-input"><i class="fas fa-times remove" class="remove_field" onclick="RemoveChapterAnswerfield(this)"></i></span></div></div>' +
                                '</li>');
                        }
                    });
                    $('.dsqadivedit').append(cnt.html());
                });
                //$('.qpreview').append(previewcnt.html());
            }
        }, '', 'Loading Questions...', '', 'getting Questions.');
    //}
}

function SetChapterQandAEmptyedit(cnt) {
    $('.survey-question', cnt).addClass('question-1');
    $('.survey-question > a:first', cnt).remove();
    $('.txtq', cnt).attr('id', 'txtq1');
    $('.dsanslistedit', cnt).addClass('answer-fieldlist-1');
    //$('.dsanslistedit', cnt).append('<li class="answer"><input type="text" id="txta1" runat="server" class="form-control txta" data-aid="0"></li>');

    $('.dsanslistedit', cnt).append('<li class="answer col-xs-12 px-2">' +
                                '<div class="col-xs-12 px-0 mb-3">' +
                                '<div class="input-group">' +
                                '<input id="txta1" type="text" class="form-control main-input border-right txta surveyans-ctrl" name="email" placeholder="Enter your answer here" data-aid="0">' +
                                '<span class="input-group-addon main-input nobg"></span></div></div>' +
                                '</li>');
    $('.answers > button', cnt).addClass('addanswer-btn-1').attr('data-target', 'answer-fieldlist-1');
    $('.dsqadivedit').append(cnt.html());
    $('.qpreview').html('No Questions.');
    $('.qpreviewnxtdiv').hide();  
}


function AddorRemoveChapterQuestionfield() {
    var wrapper = $("." + $('.addquestion-btn').data('target')); //Fields wrapper
    var x = $('.dsqadivedit').children().length;
    event.preventDefault();
    x++;
    //$(wrapper).append('<div class="survey-question question-' + x + ' well" style="display:none;"><a href="void(0)" class="remove_field">Remove <i class="fa fa-close"></i></a><div class="form-group"><label>Question </label><textarea name="" id="txtq' + x.toString() + '" runat="server" id="" cols="30" rows="10" class="form-control question-' + x.toString() + ' txtq" data-qid="0"></textarea></div><div class="answers"><label>Answer/s</label><ol class="answer-fieldlist-' + x + ' row dsanslistedit"><li class="answer"><input type="text" id="txta1" runat="server" class="form-control txta" data-aid="0"></li></ol><button type="button" class="addfield-btn' + x + '" data-target="answer-fieldlist-' + x + '" onclick="m.AddorRemoveSurveyAnswerfield(this)">+ Add answer</button></div></div>'); //add input box
    $(wrapper).append('<div class="my-5 survey-question question-' + x + '" style="display:none;" data-qid="0">' +
                       '<a href="void(0)" class="remove_field" onclick="RemoveChapterQuestionfield(this)"><i class="far fa-window-close pull-right"></i></a>' +
                                            '<div class="col-xs-6 my-2 px-2">' +
                                                '<textarea class="form-control main-input question-' + x.toString() + ' txtq" data-qid="0" rows="12" id="txtq' + x.toString() + '" placeholder="Enter your question here"></textarea>' +
                                            '</div>' +
                                            '<div class="col-xs-6 mb-3 answers">' +
                                                '<ol class="answer-fieldlist-' + x + ' row dsanslistedit">' +
                                                '<li class="answer col-xs-12 px-2">' +
 '<div class="col-xs-12 px-0 mb-3">' +
                            '<div class="input-group">' +
                            '<input id="txta1" type="text" class="form-control main-input border-right txta surveyans-ctrl" name="email" placeholder="Enter your answer here" data-aid="0">' +
                            '<span class="input-group-addon main-input nobg"></span></div></div>' +
    '</li>' +
                                               '</ol>' +
                                                '<button type="button" class="adda addfield-btn' + x + '" data-target="answer-fieldlist-' + x + '" onclick="AddorRemoveChapterAnswerfield(this)"><i class="fa fa-plus fa-1x"></i> Add answer here</button>' +
                                            '</div>'); //add input box
    $(wrapper).find('.survey-question.question-' + x).slideDown(200);

    $(wrapper).on('click', '.remove_field', function (e) { //user click on remove text
        e.preventDefault();
        $(this).parent("div").slideUp(200, function () {
            $(this).remove();//x--;
        });
    });
}

function AddorRemoveChapterAnswerfield(btnctrl) {
    var wrapacount = $(btnctrl).prev('.dsanslistedit').children().length;
    var wrapansol = btnctrl;
    var wrapper2 = $("." + $(wrapansol).data('target')); //Fields wrapper2        
    var add_button2 = $(wrapansol); //Add button ID        
    event.preventDefault();
    wrapacount++;
    //$(wrapper2).append('<li class="answer" style="display:none;"><input type="text" id="txta' + wrapacount.toString() + '" runat="server" class="form-control txta" data-aid="0"/><a href="void(0)" class="remove_field"><i class="fa fa-close"></i></a></li>'); //add input box
    $(wrapper2).append(
         '<li style="display:none;" class="answer col-xs-12 px-2">' +
                            '<div class="col-xs-12 px-0 mb-3">' +
                            '<div class="input-group">' +
                            '<input id="txta' + wrapacount.toString() + '" type="text" class="form-control main-input border-right txta surveyans-ctrl" name="email" placeholder="Enter your answer here" data-aid="0">' +
                            '<span class="input-group-addon main-input"><i class="fas fa-times remove" class="remove_field" onclick="RemoveChapterAnswerfield(this)"></i></span></div></div>' +
                            '</li>'); //add input box
    $(wrapper2).find('.answer:last').slideDown(200, function () {
    });

    $(wrapper2).on('click', '.remove_field', function (e) { //user click on remove text
        e.preventDefault();
        $(this).parent("li").slideUp(200, function () {
            $(this).remove();//x--;
        });

    });
}

function RemoveChapterAnswerfield(ctrl) {
    var aid = $(ctrl).parents('span').prev("input").attr('data-aid');
    if (aid == 0) {
        $(ctrl).parents("li").slideUp(200, function () {
            $(this).remove();//x--;
        });
    } else {
        event.preventDefault();
        $.ajax({
            url: apiurl + "workshop/DeleteAnswers?aid=" + aid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                $(ctrl).parents("li").slideUp(200, function () {
                    $(this).remove();//x--;
                });
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    }
    //$('.txtremovedataa').val($('.txtremovedataa').val() + ',' + $(ctrl).parents('span').prev("input").attr('data-aid'));      
}

function RemoveChapterQuestionfield(ctrl) {
    var qid = $(ctrl).parent().attr('data-qid');
    //alert($(ctrl).parent().attr('data-qid'));
    event.preventDefault();
    if (qid != 0) {
        $.ajax({
            url: apiurl + "workshop/DeleteQuestions?qid=" + qid,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                $(ctrl).parent("div").slideUp(200, function () {
                    $(this).remove();//x--;
                });
            },
            error: function (errormessage) {
                alert(errormessage.responseText);
            }
        });
    } else {
        $(ctrl).parent("div").slideUp(200, function () {
            $(this).remove();//x--;
        });
    }
    // $('.txtremovedataq').val($('.txtremovedataq').val() + ',' + $(ctrl).parent().attr('data-qid'));             
}

function ClearSurveyQandAdetails() {
    $('.dsanslist').html('');
    $('.dsqsurveyname').html('');
    $('.dsquestionsgv').html('');
    $('.dsanseditsurvey').attr('href', '#');
}

function AddChapterQuestions(cid) {
    //alert(sid);
    var data = [];
    $('.dsqadivedit > div').each(function () {
        var qcontainer = this;
        if ($('.txtq', qcontainer).val() != '') {
            data.push('[' + $('.txtq', qcontainer).attr('data-qid') + ':' + $('.txtq', qcontainer).val() + '&^');
            var alength = $('.answers > ol > li', qcontainer).length - 1;
            $('.answers > ol > li', qcontainer).each(function (index) {
                if ($('.txta', this).val() != '') {
                    if (alength == 0) {
                        data.push('{' + $('.txta', this).attr('data-aid') + ':' + $('.txta', this).val() + '}&^]');
                    }
                    else if (index == alength) {
                        data.push('{' + $('.txta', this).attr('data-aid') + ':' + $('.txta', this).val() + '}&^]');
                    }
                    else {
                        data.push('{' + $('.txta', this).attr('data-aid') + ':' + $('.txta', this).val() + '}');
                    }
                }
            });
        }
    });
    //console.log(data.toString());
    $('.txtdataqa').val(data.toString());
    // console.log(data.toString());
    //m.ajaxreq("AddSurveyQuestions", { id: sid, qdetails: data.toString() }, function (response) {

    //}, '', '', '', '');
}




