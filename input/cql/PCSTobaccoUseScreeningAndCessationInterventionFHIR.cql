library PCSTobaccoUseScreeningAndCessationInterventionFHIR version '0.0.001'

using QICore version '4.1.1'

include CQMCommon version '2.0.000' called CQMCommon
include Status version '1.6.000' called Status
include FHIRHelpers version '4.3.000' called FHIRHelpers
include SupplementalDataElements version '3.4.000' called SDE
include QICoreCommon version '2.0.000' called QICoreCommon
include Hospice version '6.9.000' called Hospice
include CumulativeMedicationDuration version '4.0.000' called CMD

codesystem "CPT": 'http://www.ama-assn.org/go/cpt'
codesystem "ICD10CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'
codesystem "LOINC": 'http://loinc.org'

valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Limited Life Expectancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1259'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1007'
valueset "Nutrition Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.1006'
valueset "Occupational Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1011'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Virtual Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Ophthalmological Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1285'
valueset "Physical Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1022'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Group Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psych Visit Diagnostic Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1141'
valueset "Speech and Hearing Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1530'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Tobacco Non User": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1189'
valueset "Tobacco Use Cessation Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.509'
valueset "Tobacco Use Cessation Pharmacotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1190'
valueset "Tobacco Use Screening": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1278'
valueset "Tobacco User": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1170'

code "Health behavior assessment, or re-assessment (ie, health-focused clinical interview, behavioral observations, clinical decision making)": '96156' from "CPT" display 'Health behavior assessment, or re-assessment (ie, health-focused clinical interview, behavioral observations, clinical decision making)'
code "Health behavior intervention, individual, face-to-face; initial 30 minutes": '96158' from "CPT" display 'Health behavior intervention, individual, face-to-face; initial 30 minutes'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "Tobacco abuse counseling": 'Z71.6' from "ICD10CM" display 'Tobacco abuse counseling'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'
code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'
code "Smokeless Tobacco Use Screening": '88031-0' from "LOINC" display 'SHX Smokeless Tobacco use'

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

parameter "Measurement Period" Interval<DateTime>default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0 )

context Patient

define "Denominator 1":
  "Initial Population"

define "Denominator 2":
  "Initial Population"
    and 
    (
      "Most Recent Tobacco Use Screening Indicates Tobacco User" is not null
      or
      "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco User" is not null
    )

define "Denominator 3":
  "Initial Population"

define "Initial Population":
  "Age at Start of Measurement Period" >= 12
    and ( Count("Qualifying Encounters") >= 2
        or exists "Qualifying Encounter"
    )

define "Numerator 1":
  "Most Recent Tobacco Use Screening Indicates Tobacco Non User" is not null
    or "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco Non User" is not null
    or "Most Recent Tobacco Use Screening Indicates Tobacco User" is not null
    or "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco User" is not null

define "Numerator 2":
  exists "Tobacco Cessation Counseling Given"
    or exists "Tobacco Cessation Pharmacotherapy Ordered"
    or exists "Active Pharmacotherapy for Tobacco Cessation"

define "Numerator 3":
  (
    "Most Recent Tobacco Use Screening Indicates Tobacco Non User" is not null
    and 
    "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco Non User" is not null
  )
  or
  (
    (
      "Most Recent Tobacco Use Screening Indicates Tobacco User" is not null
      or
      "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco User" is not null
    )
    and
    ( 
      exists "Tobacco Cessation Counseling Given"
      or exists "Tobacco Cessation Pharmacotherapy Ordered"
      or exists "Active Pharmacotherapy for Tobacco Cessation"
    )
  )

define "Age at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period")

define "Most Recent Tobacco Use Screening Indicates Tobacco Non User":
  ( Last(([Observation: "Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()
  ) ) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.value as Concept in "Tobacco Non User"

define "Debug Most Recent Tobacco Use Screening":
  ( Last(([Observation: "Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()
  ) )

define "Debug Tobacco Use Screening":
  ([Observation: "Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()

define "Debug2 Tobacco Use Screening":
  (([Observation: "Tobacco Use Screening"])) TobaccoUseScreening

define "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco Non User":
  ( Last(([Observation: "Smokeless Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()
  ) ) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.value as Concept in "Tobacco Non User"

define "Debug Most Recent Smokeless Tobacco Use Screening":
  ( Last(([Observation: "Smokeless Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()
  ) )

define "Debug Smokeless Tobacco Use Screening":
  ([Observation: "Smokeless Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()

define "Debug2 Smokeless Tobacco Use Screening":
  ([Observation: "Smokeless Tobacco Use Screening"]) TobaccoUseScreening

define "Most Recent Tobacco Use Screening Indicates Tobacco User":
  ( Last(([Observation: "Tobacco Use Screening"]) TobaccoUseScreening
      where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()
  ) ) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.value as Concept in "Tobacco User"

define "Most Recent Smokeless Tobacco Use Screening Indicates Tobacco User":
  ( Last(([Observation: "Smokeless Tobacco Use Screening"]) TobaccoUseScreening
     where TobaccoUseScreening.status in { 'final', 'amended', 'corrected' }
        and TobaccoUseScreening.effective.toInterval() during day of "Measurement Period"
      sort by start of effective.toInterval()
  ) ) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.value as Concept in "Tobacco User"

define "Tobacco Cessation Counseling Given":
  ( ( ( [Procedure: "Tobacco Use Cessation Counseling"] ).isInterventionPerformed ( ) ) TobaccoCessationCounseling
      where TobaccoCessationCounseling.performed.toInterval ( ) during day of Interval[start of "Measurement Period" - 6 months, end of "Measurement Period"]
  )
    union ( ( [Condition: "Tobacco abuse counseling"] ) TobaccoCounseling
        where TobaccoCounseling.prevalenceInterval ( ) starts during day of Interval[start of "Measurement Period" - 6 months, end of "Measurement Period"]
    )

define "Tobacco Cessation Pharmacotherapy Ordered":
  ( ( [MedicationRequest: "Tobacco Use Cessation Pharmacotherapy"] ).isMedicationOrder ( ) ) CessationPharmacotherapyOrdered
    where CessationPharmacotherapyOrdered.authoredOn during day of Interval[start of "Measurement Period" - 6 months, end of "Measurement Period"]

define "Active Pharmacotherapy for Tobacco Cessation":
  ( ( [MedicationRequest: "Tobacco Use Cessation Pharmacotherapy"] ).isMedicationActive ( ) ) TakingCessationPharmacotherapy
    where TakingCessationPharmacotherapy.authoredOn during day of Interval[start of "Measurement Period" - 6 months, end of "Measurement Period"]

define "Qualifying Encounter":
  (( [Encounter] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  (["ServiceRequest": "Annual Wellness Visit"]
    union ["ServiceRequest": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["ServiceRequest": "Preventive Care Services Group Counseling"]
    union ["ServiceRequest": "Unlisted preventive medicine service"]
    union ["ServiceRequest": "Preventive Care Services Individual Counseling"]
    union ["ServiceRequest": "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"]
    union ["ServiceRequest": "Nutrition Services"]
    union ["ServiceRequest": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union [ServiceRequest: "G0402"]
    union [ServiceRequest: "G0438"]
    union [ServiceRequest: "G0439"]
    union [ServiceRequest: "G0270"]
    union [ServiceRequest: "G0271"]
    union [ServiceRequest: "G0447"]
    union [ServiceRequest: "S9449"]
    union [ServiceRequest: "S9452"]
    union [ServiceRequest: "S9470"]
    ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Qualifying Encounters":
  (( [Encounter] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charges" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charges":
  (["ServiceRequest": "Health behavior intervention, individual, face-to-face; initial 30 minutes"]
    union ["ServiceRequest": "Health behavior assessment, or re-assessment (ie, health-focused clinical interview, behavioral observations, clinical decision making)"]
    union ["ServiceRequest": "Home Healthcare Services"]
    union ["ServiceRequest": "Occupational Therapy Evaluation"]
    union ["ServiceRequest": "Office Visit"]
    union ["ServiceRequest": "Ophthalmological Services"]
    union ["ServiceRequest": "Physical Therapy Evaluation"]
    union ["ServiceRequest": "Psych Visit Diagnostic Evaluation"]
    union ["ServiceRequest": "Psych Visit Psychotherapy"]
    union ["ServiceRequest": "Psychoanalysis"]
    union ["ServiceRequest": "Speech and Hearing Evaluation"]
    union ["ServiceRequest": "Telephone Visits"]
    union ["ServiceRequest": "Virtual Encounter"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Denominator Exclusion":
  exists Hospice."Hospice Services"

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"
