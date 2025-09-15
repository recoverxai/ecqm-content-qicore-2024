library PCSBPScreeningFollowUpFHIR version '0.2.000'

using QICore version '4.1.1'

include CQMCommon version '2.0.000' called CQMCommon
include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include SupplementalDataElements version '3.4.000' called SDE

codesystem "CERNER-ServiceType": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/34'
codesystem "CERNER-SR": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/200'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'

valueset "Diagnosis of Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.263'
valueset "Dietary Recommendations": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1515'
valueset "Encounter to Screen for Blood Pressure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1920'
valueset "Finding of Elevated Blood Pressure or Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.514'
valueset "Follow Up Within 4 Weeks": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1578'
valueset "Laboratory Tests for Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1482'
valueset "Lifestyle Recommendation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1581'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1007'
valueset "Patient Declined": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1582'
valueset "Pharmacologic Therapy for Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.1577'
valueset "Recommendation to Increase Physical Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1518'
valueset "Referral or Counseling for Alcohol Consumption": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1583'
valueset "Referral to Primary Care or Alternate Provider": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1580'
valueset "Weight Reduction Recommended": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1510'

code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "12 lead EKG panel": '34534-8' from "LOINC" display 'EKG 12 channel panel'
code "EKG study": '11524-6' from "LOINC" display 'EKG study'
code "Follow-up 2-3 months (finding)": '183624006' from "SNOMEDCT" display 'Follow-up 2-3 months (finding)'
code "Follow-up 4-6 months (finding)": '183625007' from "SNOMEDCT" display 'Follow-up 4-6 months (finding)'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
code "virtual": 'VR' from "ActCode" display 'virtual'
code "Referral Management": '4659041987' from "CERNER-SR" display 'Referral Management'
code "Equimed": '12888890229' from "CERNER-ServiceType" display 'Equimed'
code "Lab": '2554653267' from "CERNER-ServiceType" display 'Lab'
code "Telehealth": '2709938661' from "CERNER-ServiceType" display 'Telehealth'

// HCPCS codes from Encounter to Screen for Blood Pressure value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0101": 'G0101' from "HCPCS" display 'G0101'
code "G0270": 'G0270' from "HCPCS" display 'G0270'
code "G0402": 'G0402' from "HCPCS" display 'G0402'
code "G0438": 'G0438' from "HCPCS" display 'G0438'
code "G0439": 'G0439' from "HCPCS" display 'G0439'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)

context Patient

define "Initial Population":
  from "Qualifying Encounter And Age at Start of Measurement Period" EncounterAndAge
    where EncounterAndAge.Age >= 18
  return EncounterAndAge.episode

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "Encounter after Diagnosis of Hypertension".episode

define "Numerator":
  "Encounter with Normal Blood Pressure Reading".episode
    // union ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80 and Followup".episode )
    union ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80 and Referral".episode )
    // union ( "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80 and Followup".episode )
    union ( "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80 and Referral".episode )
    // union ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Followup".episode )
    union ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Referral".episode )
    // union ( "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 and Followup".episode )
    union ( "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 and Referral".episode )

// define "Denominator Exceptions":
//   "Encounter with Medical Reason for Not Obtaining or Patient Declined Blood Pressure Measurement"
//     union "Encounter with Order for Hypertension Follow Up Declined by Patient"

define "Denominator Exceptions":
  [Encounter] E
    where true = false

// define "Potential Denominator Exceptions":
//   "Qualifying Encounter Without Blood Pressure"

// Potential Denominator Exceptions conditions
// define "Qualifying Encounter Without Blood Pressure":
//   "Qualifying Encounter" QualifyingEncounter
//     let EncounterLastSystolicBP: Last("Systolic Blood Pressure" BloodPressure
//         where BloodPressure.effective.toInterval() ends during QualifyingEncounter.period
//         sort by start of effective.toInterval()
//     ),
//     EncounterLastDiastolicBP: Last("Diastolic Blood Pressure" BloodPressure
//         where BloodPressure.effective.toInterval() ends during QualifyingEncounter.period
//         sort by start of effective.toInterval()
//     )
//     where EncounterLastSystolicBP is null
//       or EncounterLastDiastolicBP is null

// Initial Population conditions
define "Qualifying Encounter And Age at Start of Measurement Period":
  from "Qualifying Encounter" QualifyingEncounter,
    "Age at Start of Measurement Period" Age
  return {episode: QualifyingEncounter, "Qualifying Encounter": QualifyingEncounter, Age: Age}

define "Age at Start of Measurement Period":
  AgeInYearsAt(start of "Measurement Period")

// Denominator Exclusions conditions
define "Encounter after Diagnosis of Hypertension":
  from
    "Qualifying Encounter" QualifyingEncounter,
    "Active Hypertension With Date" Hypertension
  where 
    Hypertension.date before QualifyingEncounter.period
    and
    not exists (
      "Inactive Hypertension With Date" InactiveHypertension
        where
          Hypertension.date before InactiveHypertension.date
          and InactiveHypertension.date before QualifyingEncounter.period
    )
  return {episode: QualifyingEncounter, "1_Diagnosis of Hypertension": Hypertension.activeHypertension}

define "Active Hypertension With Date":
  from
    [Condition: "Diagnosis of Hypertension"] Hypertension,
    [Encounter] HypertensionEncounter
  where (
        Hypertension.encounter.reference = 'Encounter/' & HypertensionEncounter.id
    )
    and Hypertension.isActive ( )
  return {
    activeHypertension: Hypertension,
    date: Min ({ start of HypertensionEncounter.period.toInterval(), Coalesce( Hypertension.onset.toDate().toDateTime(), Hypertension.recordedDate ) })
  }

define "Inactive Hypertension With Date":
  from
    [Condition: "Diagnosis of Hypertension"] InactiveHypertension
  where InactiveHypertension.isInActive ( )
  return {
    activeHypertension: InactiveHypertension,
    date: Coalesce( InactiveHypertension.onset.toDate().toDateTime(), InactiveHypertension.recordedDate )
  }

// Numerator conditions
// Normal BP
define "Encounter with Normal Blood Pressure Reading":
  "Encounter with Blood Pressure Reading" EncounterBP
    where EncounterBP.systolicBP.systolicReading() in Interval[1 'mm[Hg]', 120 'mm[Hg]' )
      and EncounterBP.diastolicBP.diastolicReading() in Interval[1 'mm[Hg]', 80 'mm[Hg]' )
    return {episode: EncounterBP.episode, "1_Systolic BP": EncounterBP.systolicBP, "2_Diastolic BP": EncounterBP.diastolicBP}

// Elevated BP 120-129
// define "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80 and Followup":
//   from 
//     "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80" ElevatedEncounter,
//     "Follow up with Rescreen in 2 to 6 Months" Twoto6MonthRescreen,
//     "NonPharmacological Interventions" NonPharmInterventions
//   where Twoto6MonthRescreen.authoredOn during day of ElevatedEncounter.episode.period
//       and NonPharmInterventions.authoredOn during day of ElevatedEncounter.episode.period
//   return {episode: ElevatedEncounter.episode, "1_Systolic BP": ElevatedEncounter.systolicBP, "2_Diastolic BP": ElevatedEncounter.diastolicBP, "3_Follow-up": Twoto6MonthRescreen, "4_Recommendation": NonPharmInterventions }

define "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80 and Referral":
  from
    "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80" ElevatedEncounter,
    "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" Referral
  where Referral.authoredOn during day of ElevatedEncounter.episode.period
  return {episode: ElevatedEncounter.episode, "1_Systolic BP": ElevatedEncounter.systolicBP, "2_Diastolic BP": ElevatedEncounter.diastolicBP, "3_Referral": Referral}

define "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80":
  "Encounter with Blood Pressure Reading" EncounterBP
    where EncounterBP.systolicBP.systolicReading() in Interval[120 'mm[Hg]', 129 'mm[Hg]' )
      and EncounterBP.diastolicBP.diastolicReading() in Interval[1 'mm[Hg]', 80 'mm[Hg]' )
    return {episode: EncounterBP.episode, systolicBP: EncounterBP.systolicBP, diastolicBP: EncounterBP.diastolicBP}

// First Hypertensive 
// define "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80 and Followup":
//   from
//     "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80" FirstHTNEncounter,
//     [ServiceRequest: "Follow Up Within 4 Weeks"] FourWeekRescreen,
//     "NonPharmacological Interventions" NonPharmInterventions
//    where FourWeekRescreen.authoredOn during day of FirstHTNEncounter.episode.period
//      and FourWeekRescreen.intent ~ 'order'
//      and NonPharmInterventions.authoredOn during day of FirstHTNEncounter.episode.period
//   return {episode: FirstHTNEncounter.episode, "1_Systolic BP": FirstHTNEncounter.systolicBP, "2_Diastolic BP": FirstHTNEncounter.diastolicBP, "3_Follow-up": FourWeekRescreen, "4_Recommendation": NonPharmInterventions }

define "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80 and Referral":
  from
    "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80" FirstHTNEncounter,
    "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" Referral
  where Referral.authoredOn during day of FirstHTNEncounter.episode.period
  return {episode: FirstHTNEncounter.episode, "1_Systolic BP": FirstHTNEncounter.systolicBP, "2_Diastolic BP": FirstHTNEncounter.diastolicBP, "3_Referral": Referral}

define "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80":
  "Encounter with Blood Pressure Reading" EncounterBP
    where EncounterBP.systolicBP is not null
      and EncounterBP.diastolicBP is not null
      and (
        EncounterBP.systolicBP.systolicReading() >= 130 'mm[Hg]'
        or EncounterBP.diastolicBP.diastolicReading() >= 80 'mm[Hg]'
      )
      and not exists ("Systolic Blood Pressure" BloodPressure
        where BloodPressure.systolicReading() >= 130 'mm[Hg]'
          and BloodPressure.effective.toInterval() ends 1 year or less before start of EncounterBP.episode.period)
      and not exists ("Diastolic Blood Pressure" BloodPressure
        where BloodPressure.diastolicReading() >= 80 'mm[Hg]'
          and BloodPressure.effective.toInterval() ends 1 year or less before start of EncounterBP.episode.period)
  return {episode: EncounterBP.episode, systolicBP: EncounterBP.systolicBP, diastolicBP: EncounterBP.diastolicBP}

// Second Hypertensive 130
// define "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Followup":
//   from
//     "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89" SecondHTNEncounter,
//     "Follow up with Rescreen in 2 to 6 Months" Rescreen2to6,
//     "Laboratory Test or ECG for Hypertension" LabECGIntervention,
//     "NonPharmacological Interventions" NonPharmInterventions
//    where Rescreen2to6.authoredOn during day of SecondHTNEncounter.episode.period
//      and LabECGIntervention.authoredOn during day of SecondHTNEncounter.episode.period
//      and NonPharmInterventions.authoredOn during day of SecondHTNEncounter.episode.period
//   return {episode: SecondHTNEncounter.episode, "1_Systolic BP": SecondHTNEncounter.systolicBP, "2_Diastolic BP": SecondHTNEncounter.diastolicBP, "3_Follow-up": Rescreen2to6, "4_Recommendation": NonPharmInterventions, "5_ECG": LabECGIntervention }

define "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Referral":
  from
    "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89" SecondHTNEncounter,
    "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" Referral
  where Referral.authoredOn during day of SecondHTNEncounter.episode.period
  return {episode: SecondHTNEncounter.episode, "1_Systolic BP": SecondHTNEncounter.systolicBP, "2_Diastolic BP": SecondHTNEncounter.diastolicBP, "3_Referral": Referral}

define "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89":
  "Encounter with Blood Pressure Reading" EncounterBP
    where (
        EncounterBP.systolicBP.systolicReading() in Interval[130 'mm[Hg]', 139 'mm[Hg]']
        or EncounterBP.diastolicBP.diastolicReading() in Interval[80 'mm[Hg]', 89 'mm[Hg]']
      )
      and not (
        EncounterBP.systolicBP.systolicReading() >= 140 'mm[Hg]'
        or EncounterBP.diastolicBP.diastolicReading() >= 90 'mm[Hg]'
      )
      and (exists ("Systolic Blood Pressure" BloodPressure
        where BloodPressure.systolicReading() >= 130 'mm[Hg]'
          and BloodPressure.effective.toInterval() ends 1 year or less before start of EncounterBP.episode.period)
      or exists ("Diastolic Blood Pressure" BloodPressure
        where BloodPressure.diastolicReading() >= 80 'mm[Hg]'
          and BloodPressure.effective.toInterval() ends 1 year or less before start of EncounterBP.episode.period))
  return {episode: EncounterBP.episode, systolicBP: EncounterBP.systolicBP, diastolicBP: EncounterBP.diastolicBP}

// Second Hypertensive 140
// define "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 and Followup":
//   from
//     "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90" SecondHTN140Encounter,
//     [ServiceRequest: "Follow Up Within 4 Weeks"] WeeksRescreen,
//     "Laboratory Test or ECG for Hypertension" LabECGIntervention,
//     "NonPharmacological Interventions" NonPharmInterventions,
//     ["MedicationRequest": "Pharmacologic Therapy for Hypertension"] Medications
//    where WeeksRescreen.authoredOn during day of SecondHTN140Encounter.episode.period
//      and WeeksRescreen.intent ~ 'order'
//      and LabECGIntervention.authoredOn during day of SecondHTN140Encounter.episode.period
//      and NonPharmInterventions.authoredOn during day of SecondHTN140Encounter.episode.period
//      and Medications.authoredOn during day of SecondHTN140Encounter.episode.period
//      and Medications.status ~ 'active'
//   return {episode: SecondHTN140Encounter.episode, "1_Systolic BP": SecondHTN140Encounter.systolicBP, "2_Diastolic BP": SecondHTN140Encounter.diastolicBP, "3_Follow-up": WeeksRescreen, "4_Recommendation": NonPharmInterventions, "5_ECG": LabECGIntervention, "6_Medication": Medications }

define "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 and Referral":
  from
    "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90" SecondHTN140Encounter,
    "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" Referral
  where Referral.authoredOn during day of SecondHTN140Encounter.episode.period
  return {episode: SecondHTN140Encounter.episode, "1_Systolic BP": SecondHTN140Encounter.systolicBP, "2_Diastolic BP": SecondHTN140Encounter.diastolicBP, "3_Referral": Referral}

define "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90":
  "Encounter with Blood Pressure Reading" EncounterBP
    where EncounterBP.systolicBP is not null
      and EncounterBP.diastolicBP is not null
      and (
        EncounterBP.systolicBP.systolicReading() >= 140 'mm[Hg]'
        or EncounterBP.diastolicBP.diastolicReading() >= 90 'mm[Hg]'
      )
      and (exists ("Systolic Blood Pressure" BloodPressure
        where BloodPressure.systolicReading() >= 130 'mm[Hg]'
          and BloodPressure.effective.toInterval() ends 1 year or less before start of EncounterBP.episode.period)
      or exists ("Diastolic Blood Pressure" BloodPressure
        where BloodPressure.diastolicReading() >= 80 'mm[Hg]'
          and BloodPressure.effective.toInterval() ends 1 year or less before start of EncounterBP.episode.period))
  return {episode: EncounterBP.episode, systolicBP: EncounterBP.systolicBP, diastolicBP: EncounterBP.diastolicBP}

// Common
define "Qualifying Encounter":
  ["Encounter"] ValidEncounter
    where ValidEncounter.period.toInterval ( ) during day of "Measurement Period"
      and ValidEncounter.status ~ 'finished'
      and ValidEncounter.class !~ "virtual"
      and ValidEncounter.serviceType !~ "Equimed"
      and ValidEncounter.serviceType !~ "Lab"
      and ValidEncounter.serviceType !~ "Telehealth"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  ([ServiceRequest: "Encounter to Screen for Blood Pressure"]
    union [ServiceRequest: "G0101"]
    union [ServiceRequest: "G0270"]
    union [ServiceRequest: "G0402"]
    union [ServiceRequest: "G0438"]
    union [ServiceRequest: "G0439"]) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Systolic Blood Pressure":
  (["observation-bp"]).isObservationSystolicBP ( )

define "Diastolic Blood Pressure":
  (["observation-bp"]).isObservationDiastolicBP ( )

define "Encounter with Blood Pressure Reading":
  "Qualifying Encounter" QualifyingEncounter
    let EncounterLastSystolicBP: Last("Systolic Blood Pressure" BloodPressure
        where BloodPressure.effective.toInterval() ends during QualifyingEncounter.period
        sort by issued
    ),
    EncounterLastDiastolicBP: Last("Diastolic Blood Pressure" BloodPressure
        where BloodPressure.effective.toInterval() ends during QualifyingEncounter.period
        sort by issued
    )
  return {episode: QualifyingEncounter, systolicBP: EncounterLastSystolicBP, diastolicBP: EncounterLastDiastolicBP}

// define "Follow up with Rescreen in 2 to 6 Months":
//   ( [ServiceRequest: "Follow-up 2-3 months (finding)"]
//     union [ServiceRequest: "Follow-up 4-6 months (finding)"] ) FollowUp
//     where FollowUp.intent ~ 'order'

// define "Laboratory Test or ECG for Hypertension":
//   ( [ServiceRequest: "12 lead EKG panel"]
//     union [ServiceRequest: "EKG study"]
//     union [ServiceRequest: "Laboratory Tests for Hypertension"] ) EKGLab
//     where EKGLab.intent ~ 'order'

// define "NonPharmacological Interventions":
//   ( [ServiceRequest: "Lifestyle Recommendation"]
//     union [ServiceRequest: "Weight Reduction Recommended"]
//     union [ServiceRequest: "Dietary Recommendations"]
//     union [ServiceRequest: "Recommendation to Increase Physical Activity"]
//     union [ServiceRequest: "Referral or Counseling for Alcohol Consumption"] ) NonPharmaInterventions
//     where NonPharmaInterventions.intent ~ 'order'

define "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading":
  ([ServiceRequest: "Referral to Primary Care or Alternate Provider"]
    union [ServiceRequest: code = "Referral Management"]) Referral
    where (Referral.reasonCode in "Finding of Elevated Blood Pressure or Hypertension"
      or Referral.reasonCode in "Diagnosis of Hypertension")
      and Referral.intent ~ 'order'

// define "NonPharmacological Intervention Not Ordered":
//   ( [ServiceNotRequested: "Lifestyle Recommendation"]
//     union [ServiceNotRequested: "Weight Reduction Recommended"]
//     union [ServiceNotRequested: "Dietary Recommendations"]
//     union [ServiceNotRequested: "Recommendation to Increase Physical Activity"]
//     union [ServiceNotRequested: "Referral or Counseling for Alcohol Consumption"] ) NonPharmIntervention
//     where NonPharmIntervention.reasonRefused in "Patient Declined"
//       and NonPharmIntervention.status = 'completed'

// define "Encounter with Hypertensive Reading Within Year Prior":
//   "Qualifying Encounter" QualifyingEncounter
//     let LastPreviousHyperTensiveSystolicBP: Last("Systolic Blood Pressure" BloodPressure
//         where BloodPressure.systolicReading() >= 130 'mm[Hg]'
//           and BloodPressure.effective.toInterval() ends 1 year or less before start of QualifyingEncounter.period
//         sort by start of effective.toInterval()
//     ),
//     LastPreviousHyperTensiveDiastolicBP: Last("Diastolic Blood Pressure" BloodPressure
//         where BloodPressure.diastolicReading() >= 80 'mm[Hg]'
//           and BloodPressure.effective.toInterval() ends 1 year or less before start of QualifyingEncounter.period
//         sort by start of effective.toInterval()
//     )
//     where LastPreviousHyperTensiveSystolicBP is not null
//       and LastPreviousHyperTensiveDiastolicBP is not null

// Denominator Exceptions conditions
// define "Encounter with Medical Reason for Not Obtaining or Patient Declined Blood Pressure Measurement":
//   "Qualifying Encounter" QualifyingEncounter
//     with ( [ObservationNotDone: code ~ "Systolic blood pressure"]
//       union [ObservationNotDone: code ~ "Diastolic blood pressure"] ) NoBPScreen
//       such that NoBPScreen.issued during day of QualifyingEncounter.period
//         and ( NoBPScreen.notDoneReason in "Patient Declined"
//             or NoBPScreen.notDoneReason in "Medical Reason"
//         )
//         and NoBPScreen.status = 'cancelled'

// define "Encounter with Order for Hypertension Follow Up Declined by Patient":
//   ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80".episode ElevatedBPEncounter
//       with ( [ServiceNotRequested: "Referral to Primary Care or Alternate Provider"]
//         union [ServiceNotRequested: code = "Referral Management"]
//         union [ServiceNotRequested: code = "Follow-up 2-3 months (finding)"]
//         union [ServiceNotRequested: code = "Follow-up 4-6 months (finding)"] ) ElevatedBPDeclinedInterventions
//         such that ElevatedBPDeclinedInterventions.reasonRefused in "Patient Declined"
//           and ElevatedBPDeclinedInterventions.authoredOn during day of ElevatedBPEncounter.period
//           and ElevatedBPDeclinedInterventions.status = 'completed'
//   )
//     union ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80".episode ElevatedBPEncounter
//         with "NonPharmacological Intervention Not Ordered" NotOrdered
//           such that NotOrdered.authoredOn during day of ElevatedBPEncounter.period
//     )
//     union ( "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80".episode FirstHTNEncounter
//         with ( [ServiceNotRequested: "Follow Up Within 4 Weeks"]
//           union [ServiceNotRequested: "Referral to Primary Care or Alternate Provider"]
//           union [ServiceNotRequested: code = "Referral Management"] ) FirstHTNDeclinedInterventions
//           such that FirstHTNDeclinedInterventions.reasonRefused in "Patient Declined"
//             and FirstHTNDeclinedInterventions.authoredOn during day of FirstHTNEncounter.period
//             and FirstHTNDeclinedInterventions.status = 'completed'
//     )
//     union ( "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80".episode FirstHTNEncounter
//         with "NonPharmacological Intervention Not Ordered" NoNonPharm
//           such that NoNonPharm.authoredOn during day of FirstHTNEncounter.period
//     )
//     union ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89".episode SecondHTNEncounter
//         with "Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 Interventions Declined" SecondHTNDeclinedInterventions
//           such that SecondHTNDeclinedInterventions.authoredOn during day of SecondHTNEncounter.period
//     )
//     union ( "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90".episode SecondHTN140Over90Encounter
//         with "Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 Interventions Declined" SecondHTN140Over90DeclinedInterventions
//           such that SecondHTN140Over90DeclinedInterventions.authoredOn during day of SecondHTN140Over90Encounter.period
//     )

// define "Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 Interventions Declined":
//   ( ( ( [ServiceNotRequested: "Referral to Primary Care or Alternate Provider"]
//         union [ServiceNotRequested: code = "Referral Management"]
//         union [ServiceNotRequested: code = "Follow-up 2-3 months (finding)"]
//         union [ServiceNotRequested: code = "Follow-up 4-6 months (finding)"] ) SecondHTNDeclinedReferralAndFollowUp
//         where SecondHTNDeclinedReferralAndFollowUp.reasonRefused in "Patient Declined"
//           and SecondHTNDeclinedReferralAndFollowUp.status = 'completed'
//     )
//       union "Laboratory Test or ECG for Hypertension Not Ordered"
//       union "NonPharmacological Intervention Not Ordered"
//   )

// define "Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 Interventions Declined":
//   ( ( ( [ServiceNotRequested: "Referral to Primary Care or Alternate Provider"]
//         union [ServiceNotRequested: code = "Referral Management"]
//         union [ServiceNotRequested: "Follow Up Within 4 Weeks"] ) SecondHTN140Over90ReferralFollowUpNotDone
//         where SecondHTN140Over90ReferralFollowUpNotDone.reasonRefused in "Patient Declined"
//           and SecondHTN140Over90ReferralFollowUpNotDone.status = 'completed'
//     )
//       union ( [MedicationNotRequested: "Pharmacologic Therapy for Hypertension"] MedicationRequestNotOrdered
//           where MedicationRequestNotOrdered.status = 'completed'
//       )
//       union "Laboratory Test or ECG for Hypertension Not Ordered"
//       union "NonPharmacological Intervention Not Ordered"
//   )

// define "Laboratory Test or ECG for Hypertension Not Ordered":
//   ( [ServiceNotRequested: code = "12 lead EKG panel"]
//     union [ServiceNotRequested: code = "EKG study"]
//     union [ServiceNotRequested: "Laboratory Tests for Hypertension"] ) LabECGNotDone
//     where LabECGNotDone.reasonRefused in "Patient Declined"

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define fluent function isObservationSystolicBP(Obs List<"QICore.observation-bp">):
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.component is not null
      and Last(O.component C where C.code ~ "Systolic blood pressure" return C.value as Quantity) > 0 'mm[Hg]'

define fluent function isObservationDiastolicBP(Obs List<"QICore.observation-bp">):
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.component is not null
      and Last(O.component C where C.code ~ "Diastolic blood pressure" return C.value as Quantity) > 0 'mm[Hg]'

define fluent function systolicReading(Ob "QICore.observation-bp"):
  Last(Ob.component C where C.code ~ "Systolic blood pressure" return C.value as Quantity)

define fluent function diastolicReading(Ob "QICore.observation-bp"):
  Last(Ob.component C where C.code ~ "Diastolic blood pressure" return C.value as Quantity)

// Debug All Encounters in Period
define "Debug Encounter":
  ["Encounter"] ValidEncounter
    where ValidEncounter.period.toInterval ( ) starts during day of "Measurement Period"
      and ValidEncounter.status ~ 'finished'
      and ValidEncounter.class !~ "virtual"
      and ValidEncounter.serviceType !~ "Equimed"
      and ValidEncounter.serviceType !~ "Lab"
      and ValidEncounter.serviceType !~ "Telehealth"

// Debug All Encounters in Period and their organizations
define "Debug Encounter Organization":
  from "Debug Encounter" E
    let Org: singleton from ([Organization] O where E.serviceProvider.reference = 'Organization/' + O.id)
    return {id: E.id, period: E.period, type: E.type, serviceType: E.serviceType, organization: Org.name}

// Debug All Visit Charges
define "Debug Visit Charge":
  (["ServiceRequest"]) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

// Debug All Encounters in Period and their charges
define "Debug Encounter Visit Charge":
  from "Debug Visit Charge" VC,
    "Debug Encounter" E
  where VC.encounter.reference = 'Encounter/' + E.id
  return {id: E.id, period: E.period, type: E.type, serviceType: E.serviceType, visitCharge: VC.code}
