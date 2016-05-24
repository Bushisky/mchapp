<%
    ui.decorateWith("appui", "standardEmrPage", [title: "MCH Module"])
    ui.includeJavascript("billingui", "moment.js")
%>

<% if (enrolledInAnc){ %>
	${ui.includeFragment("mchapp","antenatalExamination", [patientId: patient.patientId])}
<% } else if (enrolledInPnc) { %>
	${ui.includeFragment("mchapp","postnatalExamination", [patientId: patient.patientId])}
<% } else if (enrolledInCwc) { %>
	${ui.includeFragment("mchapp","childWelfareExamination")}
<% } else { %>
	${ui.includeFragment("mchapp","programSelection")}
<% } %>

