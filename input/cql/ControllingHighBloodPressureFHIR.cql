library ControllingHighBloodPressureFHIR version '0.1.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include CQMCommon version '2.0.000' called CQMCommon
include SupplementalDataElements version '3.4.000' called SDE
include Status version '1.6.000' called Status
include AdvancedIllnessandFrailty version '1.8.000' called AdvancedIllnessandFrailty
include AdultOutpatientEncounters version '4.8.000' called AdultOutpatientEncounters
include Hospice version '6.9.000' called Hospice
include PalliativeCare version '1.9.000' called PalliativeCare

codesystem "LOINC": 'http://loinc.org'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

valueset "Chronic Kidney Disease, Stage 5": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1002'
valueset "Dialysis Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1013'
valueset "Emergency Department Evaluation and Management Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "End Stage Renal Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.353'
valueset "ESRD Monthly Outpatient Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1014'
valueset "Essential Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.104.12.1011'
valueset "Kidney Transplant": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "Kidney Transplant Recipient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1029'
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'

code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)

context Patient

define "Initial Population":
  "Age at End of Measurement Period" in Interval[18, 85]
    and exists "Essential Hypertension Diagnosis"
    and exists "Qualifying Encounters"

define "Age at End of Measurement Period":
  AgeInYearsAt(date from end of "Measurement Period")

define "Qualifying Encounters":
  AdultOutpatientEncounters."Qualifying Encounters"

define "Essential Hypertension Diagnosis":
  ( [Condition: "Essential Hypertension"] ) Hypertension
    where Hypertension.prevalenceInterval ( ) overlaps Interval[start of "Measurement Period", start of "Measurement Period" + 6 months )
      or (Hypertension.onset is null 
            and Hypertension.recordedDate before (start of "Measurement Period" + 6 months) )

define "Debug Essential Hypertension Diagnosis":
  ( [Condition: "Essential Hypertension"] ) Hypertension

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists Hospice."Hospice Services"
    or exists ( "Pregnancy Diagnosis Which Overlaps Measurement Period" ) 
    or exists ( "Renal Diagnosis" )
    or exists ( "End Stage Renal Disease Procedures" )
    or exists ( "End Stage Renal Disease Encounter" )
    or ( 
      AdvancedIllnessandFrailty."Patient Age 66 to 80 at End of Measurement Period" is not null
      and exists (AdvancedIllnessandFrailty."Criteria Indicating Frailty")
      and ( exists (AdvancedIllnessandFrailty."Advanced Illness in Year Before or During Measurement Period")
        or exists (AdvancedIllnessandFrailty."Dementia Medications in Year Before or During Measurement Period")
      )
    )
    or ( 
      AdvancedIllnessandFrailty."Patient Age 81 or Older at End of Measurement Period" is not null
        and exists (AdvancedIllnessandFrailty."Criteria Indicating Frailty")
    )
    or (
      AdvancedIllnessandFrailty."Patient Age 66 or Older at End of Measurement Period" is not null
      and 
      (
        AdvancedIllnessandFrailty."Living Long Term in a Nursing Home" is not null
        or
        exists (AdvancedIllnessandFrailty."Discharged to a Nursing Home")
        or
        exists (AdvancedIllnessandFrailty."Encounter in a Nursing Home")
      )
    )
    or exists PalliativeCare."Palliative Care in the Measurement Period"

define "Renal Diagnosis":
  ( [Condition: "End Stage Renal Disease"]
    union [Condition: "Kidney Transplant Recipient"]
    union [Condition: "Chronic Kidney Disease, Stage 5"] ) PregnancyESRDDiagnosis
    where PregnancyESRDDiagnosis.prevalenceInterval ( ) overlaps "Measurement Period"

define "Pregnancy Diagnosis Which Overlaps Measurement Period":
  ( Status."Active Condition" ( [Condition: "Pregnancy"] ) ) PregnancyCondition
    where Coalesce( PregnancyCondition.onset, PregnancyCondition.recordedDate ) during day of "Measurement Period"

define "End Stage Renal Disease Procedures":
  ( ( [Procedure: "Kidney Transplant"]
      union [Procedure: "Dialysis Services"]
  ).isProcedurePerformed ( ) ) ESRDProcedure
    where ESRDProcedure.performed.toInterval ( ) ends on or before end of "Measurement Period"

define "End Stage Renal Disease Encounter":
  ( ( [Encounter: "ESRD Monthly Outpatient Services"] ).isEncounterPerformed ( ) ) ESRDEncounter
    where ESRDEncounter.period.toInterval ( ) starts on or before end of "Measurement Period"

define "Numerator":
  "Lowest Systolic Reading on Most Recent Blood Pressure Day" is not null
      and "Lowest Diastolic Reading on Most Recent Blood Pressure Day" is not null
      and "Has Systolic Blood Pressure Less Than 140"
      and "Has Diastolic Blood Pressure Less Than 90"

define "Has Systolic Blood Pressure Less Than 140":
  "Lowest Systolic BP and Value on Most Recent Blood Pressure Day".sbp < 140 'mm[Hg]'

define "Has Diastolic Blood Pressure Less Than 90":
  "Lowest Diastolic BP and Value on Most Recent Blood Pressure Day".dbp < 90 'mm[Hg]'

define "Lowest Systolic Reading on Most Recent Blood Pressure Day":
  "Lowest Systolic BP and Value on Most Recent Blood Pressure Day".observation

define "Lowest Systolic BP and Value on Most Recent Blood Pressure Day":
  First(
    (
      "Qualifying Systolic Blood Pressure Reading" BP
        where BP.effective.latest() same day as "Most Recent Blood Pressure Day"
        return {
          observation: BP,
          sbp: singleton from (
            BP.component C
              where C.code ~ "Systolic blood pressure"
              return (C.value as Quantity)
          )
        }
    ) tuple
    sort by sbp.value asc
  )

define "Lowest Diastolic Reading on Most Recent Blood Pressure Day":
  "Lowest Diastolic BP and Value on Most Recent Blood Pressure Day".observation

define "Lowest Diastolic BP and Value on Most Recent Blood Pressure Day":
  First(
    (
      "Qualifying Diastolic Blood Pressure Reading" BP
        where BP.effective.latest() same day as "Most Recent Blood Pressure Day"
        return {
          observation: BP,
          dbp: singleton from (
            BP.component C
              where C.code ~ "Diastolic blood pressure"
              return (C.value as Quantity)
          )
        }
    ) tuple
    sort by dbp.value asc
  )

define "Qualifying Systolic Blood Pressure Reading":
  from
    "Systolic Blood Pressure in Measurement Period" BloodPressure,
    "Non-emergency Non-inpatient Encounters" EncounterWithBP
  where BloodPressure.encounter.reference = 'Encounter/' + EncounterWithBP.id
  return BloodPressure

define "Qualifying Diastolic Blood Pressure Reading":
  from
    "Diastolic Blood Pressure in Measurement Period" BloodPressure,
    "Non-emergency Non-inpatient Encounters" EncounterWithBP
  where BloodPressure.encounter.reference = 'Encounter/' + EncounterWithBP.id
  return BloodPressure

define "Systolic Blood Pressure in Measurement Period":
  ((["observation-bp"]).isObservationSystolicBP ( )) BloodPressure
    where BloodPressure.effective.latest ( ) during day of "Measurement Period"

define "Diastolic Blood Pressure in Measurement Period":
  ((["observation-bp"]).isObservationDiastolicBP ( )) BloodPressure
    where BloodPressure.effective.latest ( ) during day of "Measurement Period"

define "Non-emergency Non-inpatient Encounters":
  ( ["Encounter"] E
      where E.period overlaps day of "Measurement Period"
        and not (E.class.code in { 'EMER', 'IMP', 'ACUTE', 'NONAC', 'PRENC', 'SS' })
  ) EncounterWithBP

define fluent function getEncounter(reference Reference):
  singleton from ( [Encounter] E
      where E.id = reference.reference.getId ( )
  )

define "Most Recent Blood Pressure Day":
  Last("Blood Pressure Days" BPDays
      sort asc
  )

define "Blood Pressure Days":
  ( "Qualifying Diastolic Blood Pressure Reading" DBPExam
      return date from DBPExam.effective.latest ( )
  )
    intersect ( "Qualifying Systolic Blood Pressure Reading" SBPExam
        return date from SBPExam.effective.latest ( )
    )

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
  ( ([Encounter]).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"

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
