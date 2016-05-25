package org.openmrs.module.mchapp;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by qqnarf on 4/28/16.
 */
public class ObsParser {
    public static List<Obs> parse(List<Obs> observations, Patient patient, String parameterKey, String[] parameterValues) throws Exception
    {
        if (observations == null) {
            observations = new ArrayList<Obs>();
        }
        if (StringUtils.contains(parameterKey, "concept.")
                || StringUtils.contains(parameterKey, "test_order")) {
            String obsConceptUuid;
            if (StringUtils.contains(parameterKey, "concept.")) {
                obsConceptUuid = parameterKey.substring("concept.".length());
            } else {
                obsConceptUuid = parameterKey.substring("test_order.".length());
            }
            Concept obsConcept = Context.getConceptService().getConceptByUuid(obsConceptUuid);
            if (obsConcept ==  null) {
                throw new NullPointerException("concept with uuid: " + obsConceptUuid + " is not defined.");
            }
            if (parameterValues.length > 0) {
                ObsProcessor obsProcessor = ObsFactory.getObsProcessor(obsConcept);
                observations.addAll(obsProcessor.createObs(obsConcept, parameterValues, patient));
            }
        }

        return observations;
    }
}
