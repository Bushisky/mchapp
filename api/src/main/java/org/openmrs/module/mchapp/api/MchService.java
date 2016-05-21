/**
 * 
 */
package org.openmrs.module.mchapp.api;

import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.ui.framework.SimpleObject;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author gwasilwa
 *
 */
public interface MchService {

	boolean enrolledInANC(Patient patient);
	SimpleObject enrollInANC(Patient patient, Date dateEnrolled);

	boolean enrolledInPNC(Patient patient);
	SimpleObject enrollInPNC(Patient patient, Date dateEnrolled);

	boolean enrolledInCWC(Patient patient);
	SimpleObject enrollInCWC(Patient patient, Date dateEnrolled,Map<String,String> cwcInitialStates);
	Encounter saveMchEncounter(Patient patient, List<Obs> encounterObservations, List<OpdDrugOrder> drugOrders, String program);

}
