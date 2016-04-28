package org.openmrs.module.mchapp;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;

public class CodedObsProcessor implements ObsProcessor {

	@Override
	public List<Obs> createObs(Concept question, String[] answers, Patient patient) {
		List<Obs> observations = new ArrayList<Obs>();
		for (int i = 0; i < answers.length; i++) {
			String answerConceptUuid = answers[i];
			Concept answerConcept = Context.getConceptService().getConceptByUuid(answerConceptUuid);
			Obs obs = new Obs();
			obs.setConcept(question);
			obs.setValueCoded(answerConcept);
			obs.setPerson(patient);
			obs.setObsDatetime(new Date());
			observations.add(obs);
		}
		return observations;
	}

}
