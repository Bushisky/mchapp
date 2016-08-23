package org.openmrs.module.mchapp.api.parsers;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;

import java.util.Date;
import java.util.List;

public class SendForExaminationParser {
    private static final String TRIAGE_ROOM_CONCEPT_UUID = "7f5cd7ad-ff69-4d60-b70c-799a98b046ef";
    private static final String EXAM_ROOM_CONCEPT_UUID = "11303942-75cd-442a-aead-ae1d2ea9b3eb";
    private static final String IMMUNIZATION_ROOM_CONCEPT_UUID = "4e87c99b-8451-4789-91d8-2aa33fe1e5f6";

    public static OpdPatientQueue parse(String referParamKey, String[] referParamValue, Patient patient, String visitStatus) {

        Concept mchTriageConcept = Context.getConceptService().getConceptByUuid(TRIAGE_ROOM_CONCEPT_UUID);
        Concept mchExamRoomConcept = Context.getConceptService().getConceptByUuid(EXAM_ROOM_CONCEPT_UUID);
        Concept mchImmunizationRoomConcept = Context.getConceptService().getConceptByUuid(IMMUNIZATION_ROOM_CONCEPT_UUID);
        OpdPatientQueue opdPatient = new OpdPatientQueue();
        if (StringUtils.equalsIgnoreCase(referParamKey, "send_for_examination") &&
                referParamValue.length > 0) {
            List<PersonAttribute> pas = Context.getService(HospitalCoreService.class).getPersonAttributes(patient.getPatientId());
            String selectedCategory = "";
            for (PersonAttribute pa : pas) {
                PersonAttributeType attributeType = pa.getAttributeType();
                if (attributeType.getPersonAttributeTypeId() == 14) {
                    selectedCategory = pa.getValue();
                }
            }
            OpdPatientQueue queue = new OpdPatientQueue();
            queue.setPatient(patient);
            queue.setCreatedOn(new Date());
            queue.setBirthDate(patient.getBirthdate());
            queue.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
            if (StringUtils.equalsIgnoreCase(referParamValue[0], EXAM_ROOM_CONCEPT_UUID)) {
                queue.setOpdConcept(mchExamRoomConcept);
                queue.setOpdConceptName(mchExamRoomConcept.getName().getName());
            } else if (StringUtils.equalsIgnoreCase(referParamValue[0], IMMUNIZATION_ROOM_CONCEPT_UUID)) {
                queue.setOpdConcept(mchImmunizationRoomConcept);
                queue.setOpdConceptName(mchImmunizationRoomConcept.getName().getName());
            }
            if (patient.getMiddleName() != null) {
                queue.setPatientName(patient.getGivenName() + " "
                        + patient.getFamilyName() + " "
                        + patient.getMiddleName().replace(",", " "));
            } else {
                queue.setPatientName(patient.getGivenName() + " "
                        + patient.getFamilyName());
            }
            queue.setReferralConcept(mchTriageConcept);
            queue.setReferralConceptName(mchTriageConcept.getName().getName());
            queue.setSex(patient.getGender());
            queue.setTriageDataId(null);
            queue.setCategory(selectedCategory);
            queue.setVisitStatus(visitStatus);
            opdPatient = Context.getService(PatientQueueService.class).saveOpdPatientQueue(queue);
        }
        return opdPatient;
    }

}
