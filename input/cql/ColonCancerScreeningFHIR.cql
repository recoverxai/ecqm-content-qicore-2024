library ColonCancerScreeningFHIR version '0.1.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include SupplementalDataElements version '3.4.000' called SDE
include CQMCommon version '2.0.000' called CQMCommon
include Hospice version '6.9.000' called Hospice
include PalliativeCare version '1.9.000' called PalliativeCare
include AdultOutpatientEncounters version '4.8.000' called AdultOutpatientEncounters
include AdvancedIllnessandFrailty version '1.8.000' called AdvancedIllnessandFrailty
include Status version '1.6.000' called Status
include QICoreCommon version '2.0.000' called QICoreCommon

codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'
codesystem "Cerner72": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/72'

valueset "Colonoscopy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1020'
valueset "CT Colonography": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1038'
valueset "Fecal Occult Blood Test (FOBT)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1011'
valueset "sDNA FIT Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1039'
valueset "Flexible Sigmoidoscopy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1010'
valueset "Malignant Neoplasm of Colon": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1001'
valueset "Total Colectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1019'

code "Colonoscope, device": '90412006' from "SNOMEDCT" display 'Colonoscope, device (physical object)'
code "Colonoscopy abnormal": '313172000' from "SNOMEDCT" display 'Colonoscopy abnormal (finding)'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

code "Outside - Cologuard": '2775203073' from "Cerner72" display 'Outside - Cologuard'
code "Colonoscopy Doc": '2820646' from "Cerner72" display 'Colonoscopy'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Initial Population":
  "Age at End of Measurement Period" in Interval[46, 75]
    and exists "Qualifying Encounters"

define "Denominator":
  "Initial Population"

define "Denominator Exclusion":
  exists Hospice."Hospice Services"
    or exists "Malignant Neoplasm"
    or exists "Total Colectomy Performed"
    or (
      AdvancedIllnessandFrailty."Patient Age 66 or Older at End of Measurement Period" is not null
      and 
      (
        (
          exists (AdvancedIllnessandFrailty."Criteria Indicating Frailty")
          and (
            exists (AdvancedIllnessandFrailty."Advanced Illness in Year Before or During Measurement Period")
            or exists (AdvancedIllnessandFrailty."Dementia Medications in Year Before or During Measurement Period")
          )
        )
        or
        AdvancedIllnessandFrailty."Living Long Term in a Nursing Home" is not null
        or
        exists (AdvancedIllnessandFrailty."Discharged to a Nursing Home")
        or
        exists (AdvancedIllnessandFrailty."Encounter in a Nursing Home")
      )
    )
    or exists PalliativeCare."Palliative Care in the Measurement Period"

define "Numerator":
  exists "Fecal Occult Blood Test Performed"
    or exists "Stool DNA with FIT Test Performed"
    or exists "Flexible Sigmoidoscopy Performed"
    or exists "CT Colonography Performed"
    or exists "Colonoscopy Performed"
    or exists "Colonoscopy Report"

define "Age at End of Measurement Period":
  AgeInYearsAt(date from end of "Measurement Period")

define "Qualifying Encounters":
  AdultOutpatientEncounters."Qualifying Encounters"

define "Fecal Occult Blood Test Performed":
  ( Status."Final Lab Observation" ( ["Observation": "Fecal Occult Blood Test (FOBT)"] ) ) FecalOccultResult
    where FecalOccultResult.value is not null
      and QICoreCommon."Latest" ( FecalOccultResult.effective ) during day of "Measurement Period"

define "Stool DNA with FIT Test Performed":
  ( Status."Final Lab Observation" ( ["Observation": "sDNA FIT Test"] ) ) sDNATest
    where sDNATest.value is not null
      and QICoreCommon."Latest" ( sDNATest.effective ) during day of Interval[start of "Measurement Period" - 2 years, end of "Measurement Period"]

define "Flexible Sigmoidoscopy Performed":
  ( Status."Completed Procedure" ( ["Procedure": "Flexible Sigmoidoscopy"] ) ) FlexibleSigmoidoscopy
    where QICoreCommon."ToInterval" ( FlexibleSigmoidoscopy.performed ) ends during day of Interval[start of "Measurement Period" - 4 years, end of "Measurement Period"]

define "CT Colonography Performed":
  ( Status."Final Observation" ( ["Observation": "CT Colonography"] ) ) Colonography
    where QICoreCommon."ToInterval" ( Colonography.effective ) ends during day of Interval[start of "Measurement Period" - 4 years, end of "Measurement Period"]

define "Colonoscopy Performed":
  ( Status."Completed Procedure" ( 
    ["Procedure": "Colonoscopy"] 
    union ["Procedure": "Colonoscope, device"] 
    union ["Procedure": "Colonoscopy abnormal"] 
  ) ) Colscopy
    with [Encounter] ColscopyEncounter
    such that QICoreCommon."ToInterval" ( Colscopy.performed ) ends during day of Interval[start of "Measurement Period" - 9 years, end of "Measurement Period"]
      or 
      (Colscopy.encounter.reference = 'Encounter/' + ColscopyEncounter.id 
      and ColscopyEncounter.period.toInterval() ends during day of Interval[start of "Measurement Period" - 9 years, end of "Measurement Period"])

define "Debug Colonoscopy Performed":
  ( Status."Completed Procedure" ( 
    ["Procedure": "Colonoscopy"] 
    union ["Procedure": "Colonoscope, device"]
    union ["Procedure": "Colonoscopy abnormal"] 
  ) ) Colscopy

define "Colonoscopy Report":
  ( [DiagnosticReportNote: "Outside - Cologuard"] 
  union [DiagnosticReportNote: "Colonoscopy Doc"] ) Report
    where Report.effective.toInterval ( ) ends during day of Interval[start of "Measurement Period" - 9 years, end of "Measurement Period"]

define "Malignant Neoplasm":
  ( Status."Active Condition" ( ["Condition": "Malignant Neoplasm of Colon"] ) ) ColorectalCancer
    where QICoreCommon."ToPrevalenceInterval" ( ColorectalCancer ) starts on or before day of end of "Measurement Period"
    or (ColorectalCancer.onset is null and ColorectalCancer.recordedDate on or before day of end of "Measurement Period")

define "Total Colectomy Performed":
  ( Status."Completed Procedure" ( ["Procedure": "Total Colectomy"] ) ) Colectomy
    where QICoreCommon."ToInterval" ( Colectomy.performed ) ends on or before day of end of "Measurement Period"

define "Stratification 1":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  ) in Interval[46, 49]

define "Stratification 2":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  ) in Interval[50, 75]

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
