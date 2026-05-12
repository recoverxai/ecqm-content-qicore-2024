library AdvancedIllnessandFrailty version '1.8.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include CQMCommon version '2.0.000' called CQMCommon
include CumulativeMedicationDuration version '4.0.000' called CMD
include Status version '1.6.000' called Status

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "RXNORM": 'http://www.nlm.nih.gov/research/umls/rxnorm'
codesystem "CERNER-71": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/71'
codesystem "HL7-DD": 'http://terminology.hl7.org/CodeSystem/discharge-disposition'
codesystem "HL7-RoleCode": 'http://terminology.hl7.org/CodeSystem/v3-RoleCode'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

valueset "Acute Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1083'
valueset "Advanced Illness": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1082'
valueset "Dementia Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1510'
valueset "Emergency Department Evaluation and Management Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Frailty Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1300'
valueset "Frailty Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.113.12.1074'
valueset "Frailty Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1088'
valueset "Frailty Symptom": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.113.12.1075'
valueset "Nonacute Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1084'
valueset "Observation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1086'
valueset "Outpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1087'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'

code "Housing status": '71802-3' from "LOINC" display 'Housing status'
code "Lives in a nursing home (finding)": '160734000' from "SNOMEDCT" display 'Lives in a nursing home (finding)'
code "Medical equipment used": '98181-1' from "LOINC" display 'Medical equipment used'
code "Equipment observable": '364697006' from "SNOMEDCT" display 'Equipment observable (observable entity)'
code "donepezil": '135447' from "RXNORM" display 'donepezil'
code "Inpatient": '309308' from "CERNER-71" display 'Inpatient'
code "Skilled nursing facility": 'snf' from "HL7-DD" display 'Skilled nursing facility'
code "NCCF": 'NCCF' from "HL7-RoleCode" display 'Nursing or custodial care facility'
code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Is Age 66 or Older with Advanced Illness and Frailty":
   "Patient Age 66 or Older at End of Measurement Period" is not null
    and exists ("Criteria Indicating Frailty")
    and ( exists ("Advanced Illness in Year Before or During Measurement Period")
        or exists ("Dementia Medications in Year Before or During Measurement Period")
    )

define "Is Age 66 to 80 with Advanced Illness and Frailty or Is Age 81 or Older with Frailty":
  ( "Patient Age 66 to 80 at End of Measurement Period" is not null
      and exists ("Criteria Indicating Frailty")
      and ( exists ("Advanced Illness in Year Before or During Measurement Period")
        or exists ("Dementia Medications in Year Before or During Measurement Period")
      )
  )
    or ( "Patient Age 81 or Older at End of Measurement Period" is not null
        and exists ("Criteria Indicating Frailty")
    )

define "Criteria Indicating Frailty":
  ( (([DeviceRequest: "Frailty Device"]).isDeviceOrder()) FrailtyDeviceOrder
      where FrailtyDeviceOrder.doNotPerform() is not true
      and FrailtyDeviceOrder.authoredOn.toInterval() during day of "Measurement Period"
  ) 
    union ( (([MedicationRequest: "Frailty Device"]).isMedicationOrder()) FrailtyDeviceMedicationOrder
        where FrailtyDeviceMedicationOrder.authoredOn.toInterval() during day of "Measurement Period"
    )
    union ( (([Observation: "Medical equipment used"] 
      union [Observation: "Equipment observable"]) O 
      where O.status in { 'final', 'amended', 'corrected' }) EquipmentUsed
        where (EquipmentUsed.value as Concept in "Frailty Device" 
          or exists (EquipmentUsed.component C where C.value as Concept in "Frailty Device"))
        and EquipmentUsed.effective.toInterval() ends during day of "Measurement Period"
    )
    union ( ([Condition: "Frailty Diagnosis"] union [Condition: "Frailty Symptom"]) FrailtyDiagnosis
        where FrailtyDiagnosis.onset during day of "Measurement Period"
          or (FrailtyDiagnosis.onset is null 
            and FrailtyDiagnosis.recordedDate during day of "Measurement Period")
    )
    union ( (( [Encounter] ).isEncounterPerformed()) FrailtyEncounter
        where FrailtyEncounter.period.toInterval() overlaps day of "Measurement Period"
          and exists ("Frailty Encounter Charge" VC where VC.encounter.reference = 'Encounter/' + FrailtyEncounter.id)
    )
    union ( (([Observation: "Frailty Symptom"]).isSymptom()) FrailtySymptom
        where FrailtySymptom.effective.toInterval() overlaps day of "Measurement Period"
    )

define "Frailty Encounter Charge":
  (["ServiceRequest": "Frailty Encounter"]) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Debug Frailty DeviceRequest":
  (([DeviceRequest: "Frailty Device"]).isDeviceOrder()) FrailtyDeviceOrder
      where FrailtyDeviceOrder.doNotPerform() is not true
      and FrailtyDeviceOrder.authoredOn.toInterval() during day of "Measurement Period"

define "Debug Frailty Observation Equipment":
  (([Observation: "Medical equipment used"] 
    union [Observation: "Equipment observable"]) O 
    where O.status in { 'final', 'amended', 'corrected' }) EquipmentUsed
        where (EquipmentUsed.value as Concept in "Frailty Device" 
          or exists (EquipmentUsed.component C where C.value as Concept in "Frailty Device"))
        and EquipmentUsed.effective.toInterval() ends during day of "Measurement Period"

define "Debug2 Frailty Observation Equipment":
  (([Observation: "Medical equipment used"] 
    union [Observation: "Equipment observable"]) O 
    where O.status in { 'final', 'amended', 'corrected' }) EquipmentUsed

define "Debug Frailty Condition":
  ([Condition: "Frailty Diagnosis"] union [Condition: "Frailty Symptom"]) FrailtyDiagnosis
        where FrailtyDiagnosis.prevalenceInterval() overlaps day of "Measurement Period"
          or (FrailtyDiagnosis.onset is null 
            and FrailtyDiagnosis.recordedDate during day of "Measurement Period")

define "Debug Frailty Encounter":
  (( [Encounter] ).isEncounterPerformed()) FrailtyEncounter
        where FrailtyEncounter.period.toInterval() overlaps day of "Measurement Period"
          and exists ("Frailty Encounter Charge" VC where VC.encounter.reference = 'Encounter/' + FrailtyEncounter.id)

define "Debug Frailty Observation Symptom":
  (([Observation: "Frailty Symptom"]).isSymptom()) FrailtySymptom
        where FrailtySymptom.effective.toInterval() overlaps day of "Measurement Period"

define "Advanced Illness in Year Before or During Measurement Period":
  ["Condition": "Advanced Illness"] AdvancedIllnessDiagnosis
      where AdvancedIllnessDiagnosis.prevalenceInterval() starts during day of Interval[start of "Measurement Period" - 1 year, end of "Measurement Period"]
        or (AdvancedIllnessDiagnosis.onset is null 
          and AdvancedIllnessDiagnosis.recordedDate during day of Interval[start of "Measurement Period" - 1 year, end of "Measurement Period"])

define "Debug Advanced Illness":
  ["Condition": "Advanced Illness"]

define "Has Two Outpatient Encounters with Advanced Illness on Different Dates of Service":
  exists ( from
      "Outpatient Encounters with Advanced Illness" OutpatientEncounter1,
      "Outpatient Encounters with Advanced Illness" OutpatientEncounter2
      where OutpatientEncounter2.period ends 1 day or more after day of 
      end of OutpatientEncounter1.period
      return OutpatientEncounter1
  )

define "Outpatient Encounters with Advanced Illness":
   (( [Encounter: "Outpatient"]
    union [Encounter: "Observation"]
    union [Encounter: "Emergency Department Evaluation and Management Visit"]
    union [Encounter: "Nonacute Inpatient"] ).isEncounterPerformed()) OutpatientEncounter
      where exists ((OutpatientEncounter.encounterDiagnosis()) Diagnosis where Diagnosis.code in "Advanced Illness")
        and OutpatientEncounter.period.toInterval() starts during day of Interval[start of "Measurement Period" - 1 year, 
        end of "Measurement Period"]

define "Has Inpatient Encounter with Advanced Illness":
  exists ( ( ([Encounter: "Acute Inpatient"]).isEncounterPerformed()) InpatientEncounter
      where exists ((InpatientEncounter.encounterDiagnosis()) Diagnosis where Diagnosis.code in "Advanced Illness")
        and InpatientEncounter.period.toInterval() starts during day of Interval[start of "Measurement Period" - 1 year, 
          end of "Measurement Period"]
  )

define "Dementia Medications in Year Before or During Measurement Period":
  ( ([MedicationRequest: "Dementia Medications"]
    union [MedicationRequest: "donepezil"]).isMedicationOrder()) DementiaMedication
      where DementiaMedication.doNotPerform is not true and
      CMD."MedicationRequestPeriod" ( DementiaMedication ) overlaps day of Interval[start of "Measurement Period" - 1 year, 
        end of "Measurement Period"]

define "Debug Dementia Medications in Year Before or During Measurement Period":
  ([MedicationRequest: "Dementia Medications"]
    union [MedicationRequest: "donepezil"]) DementiaMedication
      where DementiaMedication.doNotPerform is not true and
      CMD."MedicationRequestPeriod" ( DementiaMedication ) overlaps day of Interval[start of "Measurement Period" - 1 year, 
        end of "Measurement Period"]

define "Is Age 66 or Older Living Long Term in a Nursing Home":
  "Patient Age 66 or Older at End of Measurement Period" is not null
    and ("Living Long Term in a Nursing Home" is not null
      or exists ("Discharged to a Nursing Home"))

define "Living Long Term in a Nursing Home":
  ( Last( (([Observation: "Housing status"]).isAssessmentPerformed()) HousingStatus    
      where HousingStatus.effective.toInterval() ends on or before 
      day of end of "Measurement Period"
      sort by 
      end of effective.toInterval() asc
  )) LastHousingStatus
    where LastHousingStatus.value ~ "Lives in a nursing home (finding)"

define "Discharged to a Nursing Home":
  (([Encounter: "Encounter Inpatient"] 
    union [Encounter: "Inpatient"]).isEncounterPerformed()) InpatientEncounter
    where InpatientEncounter.hospitalization.dischargeDisposition ~ "Skilled nursing facility"
        and InpatientEncounter.period.toInterval() ends during day of "Measurement Period"

define "Encounter Locations in Contained":
  flatten ((([Encounter]).isEncounterPerformed()) NursingHomeEncounter
    where exists (NursingHomeEncounter.contained C where C is Location)
        and NursingHomeEncounter.period.toInterval() ends during day of "Measurement Period"
  return NursingHomeEncounter.contained C where C is Location return {encounter: NursingHomeEncounter, location: C as Location}
  )

define "Encounter in a Nursing Home":
  "Encounter Locations in Contained" L
    where exists (L.location.type t where t ~ "NCCF")
  return L.encounter

define "Patient Age 66 or Older at End of Measurement Period":
  from (AgeInYearsAt(date from end of "Measurement Period")) age 
    where age >= 66
  return age

define "Patient Age 66 to 80 at End of Measurement Period":
  from (AgeInYearsAt(date from end of "Measurement Period")) age 
    where age >= 66 and age <= 80
  return age

define "Patient Age 81 or Older at End of Measurement Period":
  from (AgeInYearsAt(date from end of "Measurement Period")) age 
    where age >= 81
  return age
