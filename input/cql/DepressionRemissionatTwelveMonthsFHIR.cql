library DepressionRemissionatTwelveMonthsFHIR version '0.1.000'

using QICore version '4.1.1'

/*This spec aligns with AU2024/PY2025 QDM version*/


include FHIRHelpers version '4.3.000' called FHIRHelpers
include SupplementalDataElements version '3.4.000' called SDE
include QICoreCommon version '2.0.000' called QICoreCommon

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "ConditionVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-ver-status'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'
codesystem "Cerner72": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/72'
codesystem "CERNER-71": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/71'
codesystem "HL7-DD": 'http://terminology.hl7.org/CodeSystem/discharge-disposition'

valueset "Bipolar Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.67.1.101.1.128'
valueset "Contact or Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1080.5'
valueset "Dysthymia": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.67.1.101.1.254'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Hospice Care Ambulatory": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1584'
valueset "Hospice Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.1165'
valueset "Hospice Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.1003'
valueset "Major Depression Including Remission": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.113883.3.67.1.101.3.2444'
valueset "Palliative Care Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.1167'
valueset "Palliative Care Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1090'
valueset "Palliative Care Intervention": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1135'
valueset "Personality Disorder Emotionally Labile": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.67.1.101.1.246'
valueset "Pervasive Developmental Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1152'
valueset "PHQ 9 and PHQ 9M Tools": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.67.1.101.1.263'
valueset "Schizophrenia or Psychotic Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1104'

code "Discharge to healthcare facility for hospice care (procedure)": '428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)": '428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)": '71007-9' from "LOINC" display 'Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)'
code "Hospice care [Minimum Data Set]": '45755-6' from "LOINC" display 'Hospice care [Minimum Data Set]'
code "Yes (qualifier value)": '373066001' from "SNOMEDCT" display 'Yes (qualifier value)'
code "confirmed": 'confirmed' from ConditionVerificationStatusCodes display 'Confirmed'
code "PHQ-9": '4316182' from "Cerner72" display 'Detailed Depression Screen Score'
code "Bipolar (qualifier value)": '260994008' from "SNOMEDCT" display 'Bipolar (qualifier value)'
code "Inpatient": '309308' from "CERNER-71" display 'Inpatient'
code "Recurring": '309314' from "CERNER-71" display 'Recurring'
code "hospice service (qualifier value)": '3231000175100' from "SNOMEDCT" display 'hospice service (qualifier value)'
code "Hospice": 'hosp' from "HL7-DD" display 'Hospice'
code "Palliative care service": '310073009' from "SNOMEDCT" display 'Palliative care service (qualifier value)'

// HCPCS codes from Contact or Office Visit value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0402": 'G0402' from "HCPCS" display 'G0402'
code "G0438": 'G0438' from "HCPCS" display 'G0438'
code "G0439": 'G0439' from "HCPCS" display 'G0439'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)
  
context Patient

define "Initial Population":
  "Age at Index Depression Assessment" >= 12
    and "Index Depression Assessment" is not null
    and exists ( "Qualifying Encounter" )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists ("Hospice Services in the Measure Assessment Period")
    or exists ("Palliative Care in the Measure Assessment Period")
    or ("Patient Expired Date" is not null and "Patient Expired before end of Measure Assessment Period")
    or exists ("Mental Health Disorder Diagnoses")

define "Numerator":
  "Last Depression Assessment" is not null
    and
  "Last Depression Assessment Negative" is not null

define "Last Depression Assessment Negative":
  "Last Depression Assessment" Assessment
    where Assessment.value as Quantity < 5

define "Last Depression Assessment":
  Last(([Observation: "PHQ 9 and PHQ 9M Tools"] union [Observation: "PHQ-9"]) DepressionAssessment
      where ToDate(start of DepressionAssessment.effective.toInterval()) during "Measure Assessment Period"
        and DepressionAssessment.status in { 'final', 'amended', 'corrected' }
      sort by start of effective.toInterval()
  )

define "Debug Depression Assessments in Measure Assessment Period":
  ([Observation: "PHQ 9 and PHQ 9M Tools"] union [Observation: "PHQ-9"]) DepressionAssessment
      where ToDate(start of DepressionAssessment.effective.toInterval()) during "Measure Assessment Period"
        and DepressionAssessment.status in { 'final', 'amended', 'corrected' }

define "Debug All Depression Assessments":
  ([Observation: "PHQ 9 and PHQ 9M Tools"] union [Observation: "PHQ-9"]) DepressionAssessment
      where DepressionAssessment.status in { 'final', 'amended', 'corrected' }

define "Stratification 1":
  "Index Depression Assessment" IndexAssessment
    return AgeInYearsAt(date from start of IndexAssessment.effective.toInterval()) in Interval[12, 17]

define "Stratification 2":
  "Index Depression Assessment" IndexAssessment
    return AgeInYearsAt(date from start of IndexAssessment.effective.toInterval()) >= 18

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Age at Index Depression Assessment":
  "Index Depression Assessment" IndexAssessment
    return AgeInYearsAt(date from start of IndexAssessment.effective.toInterval())

define "Denominator Identification Period":
  Interval[start of "Measurement Period" - 14 months, start of "Measurement Period" - 2 months )

define "Depression Assessments Greater than 9":
  ([Observation: "PHQ 9 and PHQ 9M Tools"] union [Observation: "PHQ-9"]) DepressionAssessment
    where DepressionAssessment.value as Quantity > 9
      and DepressionAssessment.status in { 'final', 'amended', 'corrected' }

define "Depression Diagnoses":
  ( [Condition: "Major Depression Including Remission"]
    union [Condition: "Dysthymia"] ) Depression
    where Depression.isActive ( )
      and Depression.verificationStatus ~ "confirmed"

define "Qualifying Encounter":
  [Encounter] ValidEncounter
    with "Depression Diagnoses" Depression
    such that ValidEncounter.period overlaps Depression.prevalenceInterval ( )
      and ValidEncounter.period ends during "Denominator Identification Period"
      and ValidEncounter.status = 'finished'
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)


define "Qualifying Visit Charge":
  ([ServiceRequest: "Contact or Office Visit"]
    union [ServiceRequest: "G0402"]
    union [ServiceRequest: "G0438"]
    union [ServiceRequest: "G0439"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Hospice Services in the Measure Assessment Period":
  ( ([Encounter: "Encounter Inpatient"] union [Encounter: "Inpatient"]) InpatientEncounter
      where ( InpatientEncounter.hospitalization.dischargeDisposition ~ "Discharge to home for hospice care (procedure)"
          or InpatientEncounter.hospitalization.dischargeDisposition ~ "Discharge to healthcare facility for hospice care (procedure)"
          or InpatientEncounter.hospitalization.dischargeDisposition ~ "Hospice"
      )
        and InpatientEncounter.period ends during day of Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
        and InpatientEncounter.status = 'finished'
  )
    union ( [Encounter: "Hospice Encounter"] HospiceEncounter
        where HospiceEncounter.period overlaps day of Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and not ( HospiceEncounter.status in { 'cancelled', 'entered-in-error', 'unknown' } )
    )
    union (([Encounter: "Recurring"]) PerformedEncounter
        where PerformedEncounter.serviceType ~ "hospice service (qualifier value)"
          and PerformedEncounter.period.toInterval() overlaps day of "Measurement Period"
          and PerformedEncounter.status = 'finished'
    )
    union ( [Observation: "Hospice care [Minimum Data Set]"] HospiceAssessment
        where HospiceAssessment.value ~ "Yes (qualifier value)"
          and HospiceAssessment.effective.toInterval ( ) overlaps day of Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and HospiceAssessment.status in { 'final', 'amended', 'corrected' }
    )
    union ( [ServiceRequest: code in "Hospice Care Ambulatory"] HospiceOrder
        where HospiceOrder.authoredOn during day of Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and HospiceOrder.status in { 'active', 'completed' }
          and HospiceOrder.intent in { 'order', 'original-order', 'reflex-order', 'filler-order', 'instance-order' }
    )
    union ( [Procedure: "Hospice Care Ambulatory"] HospicePerformed
        where HospicePerformed.performed.toInterval ( ) overlaps day of Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and not ( HospicePerformed.status in { 'not-done', 'entered-in-error', 'unknown' } )
    )
    union ( [Condition: "Hospice Diagnosis"] HospiceCareDiagnosis
        where HospiceCareDiagnosis.prevalenceInterval ( ) overlaps day of Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and HospiceCareDiagnosis.isActive ( )
          and HospiceCareDiagnosis.verificationStatus ~ "confirmed"
    )

define "Mental Health Disorder Diagnoses":
  ( [Condition: "Bipolar Disorder"]
      union [Condition: "Bipolar (qualifier value)"]
      union [Condition: "Personality Disorder Emotionally Labile"]
      union [Condition: "Schizophrenia or Psychotic Disorder"]
      union [Condition: "Pervasive Developmental Disorder"] ) MentalHealthDisorderDiagnoses
      where ToDate(start of MentalHealthDisorderDiagnoses.prevalenceInterval()) on or before end of "Measure Assessment Period"
        and MentalHealthDisorderDiagnoses.isActive ( )
        and MentalHealthDisorderDiagnoses.verificationStatus ~ "confirmed"

define "Palliative Care in the Measure Assessment Period":
  ( [Observation: "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)"] PalliativeAssessment
      where PalliativeAssessment.effective.toInterval ( ) overlaps Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
        and PalliativeAssessment.status in { 'final', 'amended', 'corrected' }
  )
    union ( [Condition: "Palliative Care Diagnosis"] PalliativeDiagnosis
        where PalliativeDiagnosis.prevalenceInterval ( ) overlaps Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and PalliativeDiagnosis.isActive ( )
          and PalliativeDiagnosis.verificationStatus ~ "confirmed"
    )
    union (( 
      [Encounter: "Palliative Care Encounter"]
      union [Encounter] ValidEncounter where ValidEncounter.serviceType ~ "Palliative care service") PalliativeEncounter
        where PalliativeEncounter.period overlaps Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and PalliativeEncounter.status = 'finished'
    )
    union ( [Procedure: "Palliative Care Intervention"] PalliativeIntervention
        where PalliativeIntervention.performed.toInterval ( ) overlaps Interval[start of "Denominator Identification Period", end of "Measure Assessment Period"]
          and not ( PalliativeIntervention.status in { 'not-done', 'entered-in-error', 'unknown' } )
    )

define "Index Depression Assessment":
  First("Depression Assessments Greater than 9" DepressionAssessment
      with "Qualifying Encounter" DepressionEncounter
        such that DepressionAssessment.effective.toInterval() during day of Interval[ToDate((start of DepressionEncounter.period) - 7 days), 
        end of DepressionEncounter.period]
      sort by start of effective.toInterval()
  )

define "Measure Assessment Period":
  "Index Depression Assessment" FirstIndexAssessment
    let YearAfterIndexAssessment: date from start of FirstIndexAssessment.effective.toInterval ( ) + 12 months
    return Interval[YearAfterIndexAssessment - 60 days, YearAfterIndexAssessment + 60 days]

define "Patient Expired before end of Measure Assessment Period":
  "Patient Expired Date" on or before end of "Measure Assessment Period"

define "Patient Expired Date":
  Patient.deceased
