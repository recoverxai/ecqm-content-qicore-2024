library AppropriateTestingforPharyngitisFHIR version '0.1.000'
// using FHIR version '4.0.1'
using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include SupplementalDataElements version '3.4.000' called SDE
include CQMCommon version '2.0.000' called CQMCommon
include Hospice version '6.9.000' called Hospice
include Antibiotic version '1.5.000' called Antibiotic
include Status version '1.6.000' called Status
include QICoreCommon version '2.0.000' called QICoreCommon

codesystem "CPT": 'http://www.ama-assn.org/go/cpt'
codesystem "CERNER": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/71'
codesystem "CERNER_SYNONYM": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/synonym'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "ICD": 'http://hl7.org/fhir/sid/icd-10-cm'

valueset "Acute Pharyngitis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1011'
valueset "Acute Tonsillitis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1012'
valueset "Antibiotic Medications for Pharyngitis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1001'

valueset "Comorbid Conditions for Respiratory Conditions - Part 1": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.1'
valueset "Comorbid Conditions for Respiratory Conditions - Part 2": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.2'
valueset "Comorbid Conditions for Respiratory Conditions - Part 3": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.3'
valueset "Comorbid Conditions for Respiratory Conditions - Part 4": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.4'
valueset "Comorbid Conditions for Respiratory Conditions - Part 5": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.5'
valueset "Comorbid Conditions for Respiratory Conditions - Part 6": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.6'
valueset "Comorbid Conditions for Respiratory Conditions - Part 7": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025.7'

valueset "Competing Conditions for Respiratory Conditions - Part 1": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1017.1'
valueset "Competing Conditions for Respiratory Conditions - Part 2": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1017.2'
valueset "Competing Conditions for Respiratory Conditions - Part 3": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1017.3'

valueset "Discharge Services Observation Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1039'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Group A Streptococcus Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1012'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Initial Hospital Observation Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Medical Disability Exam": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1073'
valueset "Observation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1086'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Online Assessments": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Group Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'

code "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])": '99217' from "CPT" display 'Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'
code "Clinic": '22282402' from "CERNER" display 'Clinic'
code "Azithromycin 5 Day Dose Pack 250 mg oral tablet": '4144756' from "CERNER_SYNONYM" display 'Azithromycin 5 Day Dose Pack 250 mg oral tablet'
code "Sinusitis (disorder)": '36971009' from "SNOMEDCT" display 'Sinusitis (disorder)'

parameter "Measurement Period" Interval<DateTime>

context Patient

/**
Base Expressions
*/
define "Initial Population":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic".episode EncounterWithPharyngitis
    where "Age In Measurement Period" >= 3
    return EncounterWithPharyngitis

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "In Hospice".episode
    union "Has Antibiotic Medication History".episode
    union "Has Competing Diagnosis History".episode
    union "Has Comorbid Condition History".episode

define "Numerator":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic and Step Test in 3 days Interval".episode
  
/**
IP Conditions
*/
// Age
define "Age In Measurement Period":
  AgeInYearsAt(date from
    start of "Measurement Period"
  )

// Encounter With Antibiotic Ordered Within Three Days and Pharyngitis or Tonsillitis Diagnosis
define "Encounter With Pharyngitis or Tonsillitis With Antibiotic":
  from
    "Encounter With Antibiotic Ordered Within Three Days".episode VisitWithAntibiotic,
    "Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
    where EndOfDay(AcutePharyngitisTonsillitis.onset) during VisitWithAntibiotic.period.toInterval()
    return {episode: VisitWithAntibiotic, "Diagnosis of Pharyngitis or Tonsillitis": AcutePharyngitisTonsillitis}

// Encounter with pharyngitis or tonsillitis and an antibiotic ordered within three days of the encounter
define "Encounter With Antibiotic Ordered Within Three Days":
  from
    "Qualifying Encounter" EDOrAmbulatoryVisit,
    (( [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
    union [MedicationRequest: "Azithromycin 5 Day Dose Pack 250 mg oral tablet"]).isActiveCompletedStoppedMedicationOrder() ) AntibioticOrdered
    where EDOrAmbulatoryVisit.period.toInterval() starts 3 days or less on or before AntibioticOrdered.authoredOn
    return {episode: EDOrAmbulatoryVisit, "Antibiotic Medication": AntibioticOrdered}

// Pharyngitis or Tonsillitis Diagnosis
define "Pharyngitis or Tonsillitis":
  ( [Condition: "Acute Pharyngitis"]
      union [Condition: "Acute Tonsillitis"] )

define "Qualifying Encounter":
  ( ([Encounter: "Emergency Department Visit"]
    union ([Encounter] E where exists ((E.type) T where T ~ "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])"))
    union [Encounter: "Clinic"]
    union [Encounter: "Home Healthcare Services"]
    union [Encounter: "Initial Hospital Observation Care"]
    union [Encounter: "Medical Disability Exam"]
    union [Encounter: "Observation"]
    union [Encounter: "Office Visit"]
    union [Encounter: "Telephone Visits"]
    union [Encounter: "Online Assessments"]
    union [Encounter: "Outpatient Consultation"]
    union [Encounter: "Preventive Care Services Established Office Visit, 18 and Up"]
    union [Encounter: "Preventive Care Services Group Counseling"]
    union ([Encounter] E where exists ((E.type) T where T ~ "Unlisted preventive medicine service"))
    union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union [Encounter: "Preventive Care Services Individual Counseling"]
    union [Encounter: "Preventive Care Services Initial Office Visit, 18 and Up"]
    union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() during "Measurement Period"

/**
Denominator Exclusion Conditions
*/

// Hospice Check
define "In Hospice":
  from
    "Initial Population" EligibleEncounters
    where Hospice."Has Hospice Services"
    return {episode: EligibleEncounters}

// Has an Antibiotic Medication History within 30 days prior to the encounter date for pharyngitis or tonsillitis
define "Has Antibiotic Medication History":
  from
    "Encounter With Pharyngitis or Tonsillitis With Antibiotic".episode DateOfEpisode,
    [MedicationRequest: "Antibiotic Medications for Pharyngitis"] ActiveMedication
    where exists ( ActiveMedication.dosageInstruction.timing T
          where ( QICoreCommon."ToInterval" ( T.repeat.bounds ) ) overlaps day of Interval[date from start of QICoreCommon."ToInterval" ( DateOfEpisode.period ) - 30 days, date from start of QICoreCommon."ToInterval" ( DateOfEpisode.period ) - 1 day]
      )
    return {episode: DateOfEpisode, "Antibiotic Medication": ActiveMedication}

// Has Competing Diagnoisis History within 3 days or less on or after the encounter date for pharyngitis or tonsillitis
define "Has Competing Diagnosis History":
  from
    "Encounter With Pharyngitis or Tonsillitis With Antibiotic".episode eDate,
    "Competing Diagnosis for Respiratory Conditions" competcondition
    where (
      competcondition.prevalenceInterval ( )  starts 3 days or less on or after day of start of eDate.period
      or (competcondition.prevalenceInterval ( ) is null
        and competcondition.recordedDate.toInterval() starts 3 days or less on or after day of start of eDate.period)
    ) 
    return {episode: eDate, "Competing Diagnosis": competcondition}

define "Competing Diagnosis for Respiratory Conditions":
  ([Condition: "Competing Conditions for Respiratory Conditions - Part 1"]
    union [Condition: "Competing Conditions for Respiratory Conditions - Part 2"]
    union [Condition: "Competing Conditions for Respiratory Conditions - Part 3"]) 

// Has Comorbid Condition History within 1 year prior to the encounter date for pharyngitis or tonsillitis
define "Has Comorbid Condition History":
  from
    "Encounter With Pharyngitis or Tonsillitis With Antibiotic".episode eDate,
    "Comorbid Conditions for Respiratory Conditions" comcondition
    where date from start of ( QICoreCommon."ToPrevalenceInterval" ( comcondition ) ) during Interval[date from start of QICoreCommon."ToInterval" ( eDate.period ) - 1 year, date from start of QICoreCommon."ToInterval" ( eDate.period )]
      return {episode: eDate, "Comorbid Condition": comcondition}

define "Comorbid Conditions for Respiratory Conditions":
  ([Condition: "Comorbid Conditions for Respiratory Conditions - Part 1"]
    union [Condition: "Comorbid Conditions for Respiratory Conditions - Part 2"]
    union [Condition: "Comorbid Conditions for Respiratory Conditions - Part 3"]
    union [Condition: "Comorbid Conditions for Respiratory Conditions - Part 4"]
    union [Condition: "Comorbid Conditions for Respiratory Conditions - Part 5"]
    union [Condition: "Comorbid Conditions for Respiratory Conditions - Part 6"]
    union [Condition: "Comorbid Conditions for Respiratory Conditions - Part 7"])

/**
Numerator Conditions
*/
define "Encounter With Pharyngitis or Tonsillitis With Antibiotic and Step Test in 3 days Interval":
from
    "Group A Streptococcus Lab Test With Result" GroupAStreptococcusTest,
    "Encounter With Pharyngitis or Tonsillitis With Antibiotic".episode EncounterWithPharyngitis
    where  GroupAStreptococcusTest.effective.toInterval() starts during day of Interval[( end of EncounterWithPharyngitis.period ) - 3 days, ( end of EncounterWithPharyngitis.period ) + 3 days]
    return {episode: EncounterWithPharyngitis, "Strep Test": GroupAStreptococcusTest}

define "Group A Streptococcus Lab Test With Result":
  (( [Observation: "Group A Streptococcus Test"] ).isLaboratoryTestPerformed() ) GroupAStreptococcusTest
    where GroupAStreptococcusTest.value is not null

/**
Stratifications
*/
define "Stratification 1":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period") in Interval[3, 17]
    return EncounterWithPharyngitis

define "Stratification 2":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period") in Interval[18, 64]
    return EncounterWithPharyngitis

define "Stratification 3":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period") >= 65
    return EncounterWithPharyngitis

/**
Helper Functions
*/
define fluent function isActiveCompletedStoppedMedicationOrder(MedicationRequest List<MedicationRequest>):
  MedicationRequest M
    where M.status in { 'active', 'completed', 'stopped' }
      and M.intent = 'order'

define function EndOfDay(dateValue DateTime):
  if dateValue is null then null
  else DateTime(year from dateValue, month from dateValue, day from dateValue, 23, 59, 59, 999, 0)

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

/**
Debug Functions - Initial Population
*/
// Get the onset interval of the pharyngitis or tonsillitis condition
define "Debug Pharyngitis Intervals":
  from "Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
  return EndOfDay(AcutePharyngitisTonsillitis.onset)

// Get the encounter visit interval
define "Debug Visit Intervals":
  from "Encounter With Antibiotic Ordered Within Three Days".episode VisitWithAntibiotic
  return  VisitWithAntibiotic.period.toInterval()

// Get the list of active/completed/stopped antibiotic medication requests for this patient
define "Debug Medication Requests":
  ( [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
    union [MedicationRequest: "Azithromycin 5 Day Dose Pack 250 mg oral tablet"]
  ).isActiveCompletedStoppedMedicationOrder()

// Get the authored dates of the antibiotic medication requests
define "Debug Medication Authored Dates":
  ( [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
    union [MedicationRequest: "Azithromycin 5 Day Dose Pack 250 mg oral tablet"]
  ).isActiveCompletedStoppedMedicationOrder().authoredOn


/**
Debug Functions - Numerator
*/
define "Debug Group A Streptococcus Lab Test With Result":
  ( [Observation: "Group A Streptococcus Test"] ).isLaboratoryTestPerformed()