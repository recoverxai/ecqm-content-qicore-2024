library DiabetesHemoglobinA1cHbA1cPoorControl9FHIR version '0.1.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include CQMCommon version '2.0.000' called CQMCommon
include SupplementalDataElements version '3.4.000' called SDE
include Status version '1.6.000' called Status
include CumulativeMedicationDuration version '4.0.000' called CMD
include AdvancedIllnessandFrailty version '1.8.000' called AdvancedIllnessandFrailty
include Hospice version '6.9.000' called Hospice
include PalliativeCare version '1.9.000' called PalliativeCare

codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

valueset "Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "HbA1c Laboratory Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1013'
valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240' 
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016' 
valueset "Nutrition Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.1006'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025' 
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023' 
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'

// HCPCS codes from Annual Wellness Visit value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0402": 'G0402' from "HCPCS" display 'G0402'
code "G0438": 'G0438' from "HCPCS" display 'G0438'
code "G0439": 'G0439' from "HCPCS" display 'G0439'

// HCPCS codes from Nutrition Services value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0270": 'G0270' from "HCPCS" display 'G0270'
code "G0271": 'G0271' from "HCPCS" display 'G0271'
code "G0447": 'G0447' from "HCPCS" display 'G0447'
code "S9449": 'S9449' from "HCPCS" display 'S9449'
code "S9452": 'S9452' from "HCPCS" display 'S9452'
code "S9470": 'S9470' from "HCPCS" display 'S9470'

code "Wound Care": '3661000175108' from "SNOMEDCT" display 'Wound care service (qualifier value)'
code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0 )

context Patient

define "Initial Population":
  "Age at Start of Measurement Period" in Interval[18, 75]
    and exists "Qualifying Encounters"
    and exists "Diabetes Overlaps Measurement Period"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists Hospice."Hospice Services"
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
  (
    "Most Recent HbA1c" is not null
    and (
      "Has Most Recent HbA1c Without Result"
      or "Has Most Recent Elevated HbA1c"
    )
  )
    or "Has No Record Of HbA1c"

define "Age at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period")

define "Diabetes Overlaps Measurement Period":
  [Condition: "Diabetes"] DiabetesDiagnosis
    where QICoreCommon."ToPrevalenceInterval" ( DiabetesDiagnosis ) overlaps "Measurement Period"
      or (DiabetesDiagnosis.onset is null and DiabetesDiagnosis.isActive() and DiabetesDiagnosis.recordedDate before end of "Measurement Period")

define "Most Recent HbA1c":
  Last((([Observation: "HbA1c Laboratory Test"]).isLaboratoryTestPerformed()) RecentHbA1c
      where QICoreCommon."Latest"(RecentHbA1c.effective) during day of "Measurement Period"
      sort by start of QICoreCommon."ToInterval"(effective)
  )

define "Has Most Recent HbA1c Without Result":
  "Most Recent HbA1c" is not null 
    and "Most Recent HbA1c".value as Quantity is null

define "Has Most Recent Elevated HbA1c":
  ( "Most Recent HbA1c".value as Quantity ) > 9 '%'

define "Has No Record Of HbA1c":
  not exists ( ( [Observation: "HbA1c Laboratory Test"] ).isLaboratoryTestPerformed ( ) ) NoHbA1c
    where QICoreCommon."Latest" ( NoHbA1c.effective ) during day of "Measurement Period"

define "Qualifying Encounters":
  (( [Encounter] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  (["ServiceRequest": "Office Visit"]
    union ["ServiceRequest": "Annual Wellness Visit"]
    union ["ServiceRequest": "Preventive Care Services Established Office Visit, 18 and Up"]
    union [ServiceRequest: "Preventive Care Services Initial Office Visit, 18 and Up"]
    union [ServiceRequest: "Home Healthcare Services"]
    union [ServiceRequest: "Nutrition Services"]
    union [ServiceRequest: "Telephone Visits"]
    union [ServiceRequest: "G0402"]
    union [ServiceRequest: "G0438"]
    union [ServiceRequest: "G0439"]
    union [ServiceRequest: "G0270"]
    union [ServiceRequest: "G0271"]
    union [ServiceRequest: "G0447"]
    union [ServiceRequest: "S9449"]
    union [ServiceRequest: "S9452"]
    union [ServiceRequest: "S9470"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

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
