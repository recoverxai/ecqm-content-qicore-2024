library FallsScreeningForFutureFallRiskFHIR version '0.2.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include SupplementalDataElements version '3.4.000' called SDE
include CQMCommon version '2.0.000' called CQMCommon
include Hospice version '6.9.000' called Hospice
include Status version '1.6.000' called Status

codesystem "CERNER": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/71'
codesystem "ObservationCategoryCodes": 'http://terminology.hl7.org/CodeSystem/observation-category'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'

valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Audiology Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1066'
valueset "Care Services in Long Term Residential Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services Nursing Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Falls Screening": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1028'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nursing Facility Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Occupational Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1011'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Ophthalmological Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1285'
valueset "Physical Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1022'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Virtual Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'

code "Clinic": '22282402' from "CERNER" display 'Clinic'
code "survey": 'survey' from "ObservationCategoryCodes" display 'survey'
code "social-history": 'social-history' from "ObservationCategoryCodes" display 'social-history'
code "vital-signs": 'vital-signs' from "ObservationCategoryCodes" display 'vital-signs'
code "imaging": 'imaging' from "ObservationCategoryCodes" display 'imaging'
code "laboratory": 'laboratory' from "ObservationCategoryCodes" display 'laboratory'
code "procedure": 'procedure' from "ObservationCategoryCodes" display 'procedure'
code "exam": 'exam' from "ObservationCategoryCodes" display 'exam'
code "therapy": 'therapy' from "ObservationCategoryCodes" display 'therapy'
code "activity": 'activity' from "ObservationCategoryCodes" display 'activity'

// HCPCS codes from Virtual Encounter value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0071": 'G0071' from "HCPCS" display 'G0071'
code "G2010": 'G2010' from "HCPCS" display 'G2010'
code "G2250": 'G2250' from "HCPCS" display 'G2250'
code "G2251": 'G2251' from "HCPCS" display 'G2251'
code "G2252": 'G2252' from "HCPCS" display 'G2252'

// HCPCS codes from Annual Wellness Visit value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0402": 'G0402' from "HCPCS" display 'G0402'
code "G0438": 'G0438' from "HCPCS" display 'G0438'
code "G0439": 'G0439' from "HCPCS" display 'G0439'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Age In Measurement Period":
  AgeInYearsAt(date from
    start of "Measurement Period"
  )

define "Initial Population":
  "Age In Measurement Period" >= 65
  and exists "Qualifying Encounter"

define "Debug Patients Over 65":
  "Age In Measurement Period" >= 65

define "Debug Valid Encounters":
  "Qualifying Encounter"

define "Qualifying Encounter":
  (( [Encounter: "Clinic"] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  (["ServiceRequest": "Office Visit"]
    union ["ServiceRequest": "Annual Wellness Visit"]
    union ["ServiceRequest": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["ServiceRequest": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["ServiceRequest": "Home Healthcare Services"]
    union ["ServiceRequest": "Ophthalmological Services"]
    union ["ServiceRequest": "Preventive Care Services Individual Counseling"]
    union ["ServiceRequest": "Discharge Services Nursing Facility"]
    union ["ServiceRequest": "Nursing Facility Visit"]
    union ["ServiceRequest": "Care Services in Long Term Residential Facility"]
    union ["ServiceRequest": "Audiology Visit"]
    union ["ServiceRequest": "Telephone Visits"]
    union ["ServiceRequest": "Virtual Encounter"]
    union ["ServiceRequest": "Physical Therapy Evaluation"]
    union ["ServiceRequest": "Occupational Therapy Evaluation"]
    union [ServiceRequest: "G0071"]
    union [ServiceRequest: "G2010"]
    union [ServiceRequest: "G2250"]
    union [ServiceRequest: "G2251"]
    union [ServiceRequest: "G2252"]
    union [ServiceRequest: "G0402"]
    union [ServiceRequest: "G0438"]
    union [ServiceRequest: "G0439"] )

define "Raw Matching Encounters":
  ["Encounter": "Office Visit"]
    union [Encounter: "Clinic"]
    union ["Encounter": "Annual Wellness Visit"]
    union ["Encounter": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter": "Home Healthcare Services"]
    union ["Encounter": "Ophthalmological Services"]
    union ["Encounter": "Preventive Care Services Individual Counseling"]
    union ["Encounter": "Discharge Services Nursing Facility"]
    union ["Encounter": "Nursing Facility Visit"]
    union ["Encounter": "Care Services in Long Term Residential Facility"]
    union ["Encounter": "Audiology Visit"]
    union ["Encounter": "Telephone Visits"]
    union ["Encounter": "Virtual Encounter"]
    union ["Encounter": "Physical Therapy Evaluation"]
    union ["Encounter": "Occupational Therapy Evaluation"]

define "Denominator":
     "Initial Population"

define "Denominator Exclusions":
     Hospice."Has Hospice Services"

define "Numerator":
  exists "Falls Screening Assessment Performed"

define "Falls Screening Assessment Performed":
  (( ["Observation": "Falls Screening"]).isAssessmentPerformed()) FallsScreening
  where FallsScreening.effective.toInterval() during day of "Measurement Period"

/**
Debug methods for Numerator
*/
define "Raw Falls Screening Observations":
  ["Observation": "Falls Screening"]

define "Falls Screening Passed Assessment Check":
  (["Observation": "Falls Screening"]).isAssessmentPerformed()

define "Falls Screening Time":
  from "Falls Screening Passed Assessment Check" FallsScreening
  return FallsScreening.effective

/**
Potential numerator - When the observation category coding is missing
*/
define "Potential Numerator":
  exists "Falls Screening Assessment Missing Category"
  and not "Numerator"

define "Falls Screening Assessment Missing Category":
  from ["Observation": "Falls Screening"] O
  where (O.status in { 'final', 'amended', 'corrected' }
        and exists ( O.category ObservationCategory
          where ( ObservationCategory ) !~ "survey"
          and ( ObservationCategory ) !~ "social-history"
          and ( ObservationCategory ) !~ "vital-signs"
          and ( ObservationCategory ) !~ "imaging"
          and ( ObservationCategory ) !~ "laboratory"
          and ( ObservationCategory ) !~ "procedure"
          and ( ObservationCategory ) !~ "exam"
          and ( ObservationCategory ) !~ "therapy"
          and ( ObservationCategory ) !~ "activity" )
        and O.effective.toInterval() during day of "Measurement Period")
  return O
