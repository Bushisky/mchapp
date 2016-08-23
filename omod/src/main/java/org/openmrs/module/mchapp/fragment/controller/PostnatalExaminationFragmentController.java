package org.openmrs.module.mchapp.fragment.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.http.HttpServletRequest;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.mchapp.InternalReferral;
import org.openmrs.module.mchapp.MchMetadata;
import org.openmrs.module.mchapp.QueueLogs;
import org.openmrs.module.mchapp.api.MchService;
import org.openmrs.module.mchapp.api.model.ClinicalForm;
import org.openmrs.module.patientdashboardapp.model.Referral;
import org.openmrs.module.patientdashboardapp.model.ReferralReasons;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by qqnarf on 5/17/16.
 */
public class PostnatalExaminationFragmentController {
    protected Logger log = LoggerFactory.getLogger(PostnatalExaminationFragmentController.class);
    public void controller(FragmentModel model, FragmentConfiguration config, UiUtils ui) {
        config.require("patientId");
        config.require("queueId");
        Patient patient = Context.getPatientService().getPatient(Integer.parseInt(config.get("patientId").toString()));
        Concept familyPlanningConcept = Context.getConceptService().getConceptByUuid("374AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        Collection<ConceptAnswer> familyPlanningOptions = new ArrayList<ConceptAnswer>();
        if (familyPlanningConcept != null) {
            familyPlanningOptions = familyPlanningConcept.getAnswers();
        }
        model.addAttribute("familyPlanningOptions",familyPlanningOptions);
        model.addAttribute("patient", patient);
        model.addAttribute("patientProfile", PatientProfileGenerator.generatePatientProfile(patient, MchMetadata._MchProgram.PNC_PROGRAM));
        model.addAttribute("patientHistoricalProfile", PatientProfileGenerator.generateHistoricalPatientProfile(patient, MchMetadata._MchProgram.PNC_PROGRAM));
        model.addAttribute("internalReferrals", SimpleObject.fromCollection(Referral.getInternalReferralOptions(), ui, "label", "id", "uuid"));
        model.addAttribute("externalReferrals", SimpleObject.fromCollection(Referral.getExternalReferralOptions(), ui, "label", "id", "uuid"));
        model.addAttribute("referralReasons", SimpleObject.fromCollection(ReferralReasons.getReferralReasonsOptions(), ui, "label", "id", "uuid"));
        model.addAttribute("queueId", config.get("queueId"));
    }

    public SimpleObject savePostnatalExaminationInformation(
            @RequestParam("patientId") Patient patient, 
            @RequestParam("queueId") Integer queueId,
            UiSessionContext session,
            HttpServletRequest request) {
        OpdPatientQueue patientQueue = Context.getService(PatientQueueService.class).getOpdPatientQueueById(queueId);
        String location = "PNC Exam Room";
        if (patientQueue != null) {
            location = patientQueue.getOpdConceptName();
        }
        try {
            ClinicalForm form = ClinicalForm.generateForm(request, patient, location);
            Encounter encounter = Context.getService(MchService.class).saveMchEncounter(form, MchMetadata._MchProgram.PNC_PROGRAM, MchMetadata._MchEncounterType.PNC_ENCOUNTER_TYPE, session.getSessionLocation());
            QueueLogs.logOpdPatient(patientQueue, encounter);
            InternalReferral internalReferral = new InternalReferral();
            String refferedRoomUuid = request.getParameter("internalRefferal");
            if(refferedRoomUuid!="" && refferedRoomUuid != null && !refferedRoomUuid.equals(0) && !refferedRoomUuid.equals("0")) {
                internalReferral.sendToRefferedRoom(patient, refferedRoomUuid);
            }
            return SimpleObject.create("status", "success", "message", "Triage information has been saved.");
        } catch (NullPointerException e) {
            log.error(e.getMessage());
            return SimpleObject.create("status", "error", "message",
                e.getMessage());
        } catch (ParseException e) {
            log.error(e.getMessage());
            return SimpleObject.create("status", "error", "message",
                e.getMessage());
        }
    }
}
