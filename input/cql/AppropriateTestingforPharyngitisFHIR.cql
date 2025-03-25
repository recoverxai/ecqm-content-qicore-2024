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
valueset "Comorbid Conditions for Respiratory Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1025'
valueset "Competing Conditions for Respiratory Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1017'
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
code "Maxillary sinusitis (disorder)": '88348008' from "SNOMEDCT" display 'Maxillary sinusitis (disorder)'
code "Otitis media, unspecified, right ear": 'H66.91' from "ICD" display 'Otitis media, unspecified, right ear'
code "Otitis media, unspecified, left ear": 'H66.92' from "ICD" display 'Otitis media, unspecified, left ear'
code "Otitis media, unspecified, bilateral": 'H66.93' from "ICD" display 'Otitis media, unspecified, bilateral'
code "Contact with and (suspected) exposure to infections with a predominantly sexual mode of transmission": 'Z20.2' from "ICD" display 'Contact with and (suspected) exposure to infections with a predominantly sexual mode of transmission'
code "Urinary tract infection, site not specified": 'N39.0' from "ICD" display 'Urinary tract infection, site not specified'
code "Acute maxillary sinusitis, unspecified": 'J01.00' from "ICD" display 'Acute maxillary sinusitis, unspecified'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Age In Measurement Period":
  AgeInYearsAt(date from
    end of "Measurement Period"
  )
define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Initial Population":
  // "Encounter With Pharyngitis or Tonsillitis With Antibiotic"
  "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period") >= 3
    return EncounterWithPharyngitis

define function EndOfDay(dateValue DateTime):
  if dateValue is null then null
  else DateTime(year from dateValue, month from dateValue, day from dateValue, 23, 59, 59, 999, 0)

// original CQL
define "Encounter With Pharyngitis or Tonsillitis With Antibiotic":
  from
    "Encounter With Antibiotic Ordered Within Three Days" VisitWithAntibiotic,
    "Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
    where AcutePharyngitisTonsillitis.prevalenceInterval() starts during VisitWithAntibiotic.period.toInterval()
    return VisitWithAntibiotic

define "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic":
  from
    "Encounter With Antibiotic Ordered Within Three Days" VisitWithAntibiotic,
    "Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
    where EndOfDay(AcutePharyngitisTonsillitis.onset) during VisitWithAntibiotic.period.toInterval()
    return VisitWithAntibiotic

define "Debug Pharyngitis Intervals":
  from "Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
  return AcutePharyngitisTonsillitis.prevalenceInterval()

define "Debug Visit Intervals":
  from "Encounter With Antibiotic Ordered Within Three Days" VisitWithAntibiotic
  return  VisitWithAntibiotic.period.toInterval()

define "Pharyngitis or Tonsillitis":
  ( [Condition: "Acute Pharyngitis"]
      union [Condition: "Acute Tonsillitis"] )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "In Hospice"
    union Antibiotic."Has Antibiotic Medication History" ( "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic", ( [MedicationRequest: "Antibiotic Medications for Pharyngitis"] ) )
    // union Antibiotic."Has Competing Diagnosis History" ( "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic", ( [Condition: "Competing Conditions for Respiratory Conditions"] union [Condition: "Sinusitis (disorder)"] union [Condition: "Maxillary sinusitis (disorder)"] ) )
    union "Enhanced Has Competing Diagnosis History" ( "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic", ( 
        [Condition: "Competing Conditions for Respiratory Conditions"] 
        union [Condition: "Sinusitis (disorder)"] 
        union [Condition: "Maxillary sinusitis (disorder)"]
        union [Condition: "Otitis media, unspecified, right ear"] 
        union [Condition: "Otitis media, unspecified, left ear"]
        union [Condition: "Otitis media, unspecified, bilateral"]
        union [Condition: "Contact with and (suspected) exposure to infections with a predominantly sexual mode of transmission"]
        union [Condition: "Urinary tract infection, site not specified"]
        union [Condition: "Acute maxillary sinusitis, unspecified"]
      ) )
    union Antibiotic."Has Comorbid Condition History" ( "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic", ( [Condition: "Comorbid Conditions for Respiratory Conditions"] ) )

define function "Enhanced Has Competing Diagnosis History"(episodeDate List<Encounter>, competingConditions List<Condition>):
  episodeDate eDate
      with competingConditions competcondition
        such that (
          competcondition.prevalenceInterval ( )  starts 3 days or less on or after day of start of eDate.period
          or (competcondition.prevalenceInterval ( ) is null
            and competcondition.recordedDate.toInterval() starts 3 days or less on or after day of start of eDate.period)
        ) 
      return eDate

// Check 1: Hospice status check
define "In Hospice":
  "Initial Population" EligibleEncounters
    where Hospice."Has Hospice Services"

// Check 2: Previous antibiotic medication history check
define "Debug Antibiotic Medication History":
  Antibiotic."Has Antibiotic Medication History"(
    "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic",
    [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
  )

// Get the list of antibiotic medications for this patient
define "Debug Antibiotic Medications List":
  [MedicationRequest: "Antibiotic Medications for Pharyngitis"]

// Get the list of pharyngitis encounters for debugging
define "Debug Pharyngitis Encounters":
  "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic"

// Check antibiotics with appropriate timing - returns the filtered medications that match
define "Debug Antibiotics With Valid Timing":
  "Debug Antibiotic Medications List" ActiveMedication
    with "Debug Pharyngitis Encounters" Encounter
      such that exists ( ActiveMedication.dosageInstruction.timing T
          where ( QICoreCommon."ToInterval" ( T.repeat.bounds ) ) overlaps day of 
            Interval[
              date from start of QICoreCommon."ToInterval" ( Encounter.period ) - 30 days, 
              date from start of QICoreCommon."ToInterval" ( Encounter.period ) - 1 day
            ]
      )

// Check 3: Competing diagnosis check
define "Debug Competing Diagnosis":
  "Enhanced Has Competing Diagnosis History" ( 
    "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic", 
    ( 
      [Condition: "Competing Conditions for Respiratory Conditions"] 
      union [Condition: "Sinusitis (disorder)"] 
      union [Condition: "Maxillary sinusitis (disorder)"]
      union [Condition: "Otitis media, unspecified, right ear"]
      union [Condition: "Otitis media, unspecified, left ear"]
      union [Condition: "Otitis media, unspecified, bilateral"]
      union [Condition: "Contact with and (suspected) exposure to infections with a predominantly sexual mode of transmission"]
      union [Condition: "Urinary tract infection, site not specified"]
      union [Condition: "Acute maxillary sinusitis, unspecified"]
    )
  )

// Get the list of competing conditions
define "Debug Competing Conditions List":
  ( 
    [Condition: "Competing Conditions for Respiratory Conditions"] 
    union [Condition: "Sinusitis (disorder)"] 
    union [Condition: "Maxillary sinusitis (disorder)"]
    union [Condition: "Otitis media, unspecified, right ear"] 
    union [Condition: "Otitis media, unspecified, left ear"]
    union [Condition: "Otitis media, unspecified, bilateral"]
    union [Condition: "Contact with and (suspected) exposure to infections with a predominantly sexual mode of transmission"]
    union [Condition: "Urinary tract infection, site not specified"]
    union [Condition: "Acute maxillary sinusitis, unspecified"]
  )

// Get competing conditions with valid timing - returns the filtered conditions that match
define "Debug Competing Conditions With Valid Timing":
  "Debug Competing Conditions List" CompetingCondition
    with "Debug Pharyngitis Encounters" Encounter
      such that ( QICoreCommon."ToPrevalenceInterval" ( CompetingCondition ) ) 
          starts 3 days or less on or after day of start of Encounter.period

// Check 4: Comorbid condition check
define "Debug Comorbid Conditions":
  Antibiotic."Has Comorbid Condition History" ( 
    "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic", 
    ( [Condition: "Comorbid Conditions for Respiratory Conditions"] ) 
  )

// Get the list of comorbid conditions
define "Debug Comorbid Conditions List":
  [Condition: "Comorbid Conditions for Respiratory Conditions"]

// Get comorbid conditions with valid timing - returns the filtered conditions that match
define "Debug Comorbid Conditions With Valid Timing":
  "Debug Comorbid Conditions List" ComorbidCondition
    with "Debug Pharyngitis Encounters" Encounter
      such that date from start of ( QICoreCommon."ToPrevalenceInterval" ( ComorbidCondition ) ) 
          during Interval[
            date from start of QICoreCommon."ToInterval" ( Encounter.period ) - 1 year, 
            date from start of QICoreCommon."ToInterval" ( Encounter.period )
          ]

define fluent function isActiveCompletedStoppedMedicationOrder(MedicationRequest List<MedicationRequest>):
  MedicationRequest M
    where M.status in { 'active', 'completed', 'stopped' }
      and M.intent = 'order'

define "Encounter With Antibiotic Ordered Within Three Days":
  "Qualifying Encounter" EDOrAmbulatoryVisit
    with (( [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
    union [MedicationRequest: "Azithromycin 5 Day Dose Pack 250 mg oral tablet"]).isActiveCompletedStoppedMedicationOrder() ) AntibioticOrdered
    such that EDOrAmbulatoryVisit.period.toInterval() starts 3 days or less on or before AntibioticOrdered.authoredOn

define "Debug Medication Requests":
  ( [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
    union [MedicationRequest: "Azithromycin 5 Day Dose Pack 250 mg oral tablet"]
  ).isActiveCompletedStoppedMedicationOrder()

define "Debug Medication Authored Dates":
  ( [MedicationRequest: "Antibiotic Medications for Pharyngitis"]
    union [MedicationRequest: "Azithromycin 5 Day Dose Pack 250 mg oral tablet"]
  ).isActiveCompletedStoppedMedicationOrder().authoredOn

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

define "Numerator":
  from
    "Group A Streptococcus Lab Test With Result" GroupAStreptococcusTest,
    "Debug 2 Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    // "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where  GroupAStreptococcusTest.effective.toInterval() starts during day of Interval[( end of EncounterWithPharyngitis.period ) - 3 days, ( end of EncounterWithPharyngitis.period ) + 3 days]
    return EncounterWithPharyngitis

define "Group A Streptococcus Lab Test With Result":
  (( [Observation: "Group A Streptococcus Test"] ).isLaboratoryTestPerformed() ) GroupAStreptococcusTest
    where GroupAStreptococcusTest.value is not null

define "Debug Group A Streptococcus Lab Test With Result":
  ( [Observation: "Group A Streptococcus Test"] )

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