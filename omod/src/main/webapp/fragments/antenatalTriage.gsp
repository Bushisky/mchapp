<script>
    jq(function () {
        var patientProfile = JSON.parse('${patientProfile}');
        if (patientProfile.details.length > 0) {
            var patientProfileTemplate = _.template(jq("#patient-profile-template").html());
            jq(".patient-profile").append(patientProfileTemplate(patientProfile));
        } else {
            jq(".patient-profile-editor").prependTo(jq(".profile-editor"));
        }

        jq(".patient-profile").on("click", ".edit-profile", function(){
            jq(".patient-profile").empty();
            jq("<span style='margin-top: 5px; display: block;'><a href=\"#\" class=\"cancel\"><i class='icon-remove small'></i>Cancel Edit</a></span>").appendTo(jq(".patient-profile"));
            jq(".patient-profile-editor").prependTo(jq(".profile-editor"));
            for (var i = 0; i < patientProfile.details.length; i++) {
                if (isValidDate(patientProfile.details[i].value)) {
                    jq("input[name\$='"+ patientProfile.details[i].uuid +"']").val(moment(patientProfile.details[i].value, 'D/M/YYYY').format('YYYY-MM-DD'));
                    jq("#"+ patientProfile.details[i].uuid + "-display").val(moment(patientProfile.details[i].value, 'D/M/YYYY').format('DD MMM YYYY'));
                } else {
                    jq("input[name\$='"+ patientProfile.details[i].uuid +"']").val(patientProfile.details[i].value);
                }
            }
        });

        jq(".patient-profile").on("click", ".cancel", function(e){
            e.preventDefault();
            jq('.patient-profile-editor').appendTo('.template-holder');
            jq(':input','.patient-profile-editor')
              .val('')
              .removeAttr('checked')
              .removeAttr('selected');
            if (patientProfile.details.length > 0) {
                var patientProfileTemplate = _.template(jq("#patient-profile-template").html());
                jq(".patient-profile").append(patientProfileTemplate(patientProfile));
            }
            jq(this).remove();
        });

        jq("form").on("change", "#1427AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", function(e){
            calculateExpectedDeliveryDate();
            calculateGestationInWeeks();
        });

        function calculateExpectedDeliveryDate() {
            var lastMenstrualPeriod = jq("#1427AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-field", document.forms[0]).val();
            var expectedDate = moment(lastMenstrualPeriod, "YYYY-MM-DD").add(9, "months")
            jq('#5596AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-field', document.forms[0]).val(expectedDate.format('YYYY-MM-DD'));
            jq('#5596AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-display', document.forms[0]).val(expectedDate.format('DD MMM YYYY'));
        }

        function calculateGestationInWeeks(){
            var lastMenstrualPeriod = moment(jq("#1427AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-field", document.forms[0]).val(), "YYYY-MM-DD");
            var expectedDate = moment();
            var gestationInWeeks = Math.ceil(moment.duration(expectedDate.diff(lastMenstrualPeriod)).asWeeks());
            jq('#gestation', document.forms[0]).val(gestationInWeeks);
        }

        //submit data
        jq(".submit").on("click", function(event){
            event.preventDefault();
            var data = jq("form#antenatal-triage-form").serialize();

            jq.post(
                '${ui.actionLink("mchapp", "antenatalTriage", "saveAntenatalTriageInformation")}',
                data,
                function (data) {
                    if (data.status === "success") {
                        //show success message
                        window.location = "${ui.pageLink("patientqueueapp", "mchTriageQueue")}"
                    } else if (data.status === "fail") {
                        //show error message;
                        jq().toastmessage('showErrorToast', data.message);
                    }
                }, 
                "json");
        });
    });
</script>
<script id="patient-profile-template" type="text/template">
    {{ _.each(details, function(profileDetail) { }}
		<span class="menu-title">
			<i class="icon-angle-right"></i>
			<span>{{=profileDetail.name}}:</span>{{=profileDetail.value}}
		</span>
    {{ }); }}
	
	<span style="border-top: 1px dotted rgb(136, 136, 136); display: block; margin-top: 5px; padding-top: 5px;">
		<a href="#" class="edit-profile">
			<i class="icon-pencil"></i>
			Edit Details
		</a>	
	</span>
	
</script>

<style>
	.menu-title span{
		display: inline-block;
		width: 65px;
	}
	span a:hover{
		text-decoration: none;
	}	
	form label,
	.form label {
		display: inline-block;
		padding-left: 10px;
		width: 140px;
	}	
	form input, 
	form select, 
	form textarea, 
	form ul.select, 
	.form input, 
	.form select, 
	.form textarea, .form ul.select {
		display: inline-block;
		min-width: 70%;
	}
	#lmpDate label,
	#eddDate label{
		display: none;
	}
</style>

<div>
	<div style="padding-top: 15px;" class="col15 clear">
		<ul id="left-menu" class="left-menu">
			<li class="menu-item selected" visitid="54">
				<span class="menu-date">
					<i class="icon-time"></i>
					<span id="vistdate">5 Nov 2017<br> &nbsp; &nbsp; (Active since 04:10 PM)</span>
				</span>
				
				<div class="patient-profile">
				
				</div>
				
				
				
				<span class="arrow-border"></span>
				<span class="arrow"></span>
			</li>

			<li style="height: 30px;" class="menu-item" visitid="53">
			</li>
		</ul>
	</div>
	
	<div style="min-width: 78%" class="col16 dashboard">
		<div class="info-section">
			<form id="antenatal-triage-form">
				<div class="profile-editor"></div>
				
				<div class="info-header">
					<i class="icon-diagnosis"></i>
					<h3>TRIAGE DETAILS</h3>
				</div>
				
				<div class="info-body">
						
					<input type="hidden" name="patientId" value="${patientId}" >
					<div>
						<label for="concept.5089AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA">Weight</label>
						<input type="text" id="concept.5089AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" name="concept.5089AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"/>
						<span class="append-to-value">Kgs</span>
					</div>
					<div>
						<label for="concept.5090AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA">Height</label>
						<input type="text" id="concept.5090AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" name="concept.5090AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" />
						<span class="append-to-value">Mtrs</span>
					</div>
					<div>
						<label for="systolic">Blood Pressure</label>
						<input type="text" id="systolic" name="concept.5085AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" />
						<span class="append-to-value">Systolic</span>
					</div>
					
					<div>
						<label for="diastolic"></label>
						<input type="text" id="diastolic" name="concept.5086AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" />
						<span class="append-to-value">Diastolic</span>
					</div>					
					
					<div>
						<label></label>
						<label style="padding-left:0px; width: auto;">
							<input type="checkbox" name="send_for_examination" value="yes" >
							Tick to Send to Examination Room
						</label>
					</div>
				</div>
			</form>
			
			<div>
				<span class="button submit confirm right" id="antenatalTriageFormSubmitButton" style="margin-top: 10px; margin-right: 50px;">
					<i class="icon-save"></i>
					Save
				</span>
			</div>
		</div>

		

		

	</div>
</div>



<div class="container">	
	<br style="clear: both">
</div>














<div class="template-holder" style="display:none;">


	<div class="patient-profile-editor">
		<div class="info-header">
			<i class="icon-user-md"></i>
			<h3>ANTENATAL DETAILS</h3>
		</div>
		
		<div class="info-body" style="margin-bottom: 20px; padding-bottom: 10px;">
			<div>				
				<label for="parity">Parity</label>
				<input type="text" name="concept.1053AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" id="parity" />				
				<span class="append-to-value">Pregnancies</span>
			</div>
		
			<div>
				<label for="gravidae">Gravida</label>
				<input type="text" name="concept.5624AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" id="gravida" />
				<span class="append-to-value">Pregnancies</span>
			</div>
			
			<div>
				<label>L.M.P</label>
				${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'concept.1427AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', id: 'lmpDate', label: '', useTime: false, defaultToday: false, class: ['searchFieldChange', 'date-pick', 'searchFieldBlur']])}
			</div>
			
			<div>
				<label>E.D.D</label>
				${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'concept.5596AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', id: 'eddDate', label: '', useTime: false, defaultToday: false, class: ['searchFieldChange', 'date-pick', 'searchFieldBlur']])}
			</div>
			
			<div>
				<label for="gestation">Gestation</label>
				<input type="text" id="gestation">
				<span class="append-to-value">Weeks</span>
			</div>
		</div>
	</div>
</div>
<div class=""></div>

