library WeightNutritionPhysicalActivityChildrenAdolescentsFHIR version '0.1.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include SupplementalDataElements version '3.4.000' called SDE
include Hospice version '6.9.000' called Hospice
include Status version '1.6.000' called Status

codesystem "UCUM": 'http://unitsofmeasure.org'
codesystem "LOINC": 'http://loinc.org'
codesystem "ObservationCategoryCodes": 'http://terminology.hl7.org/CodeSystem/observation-category'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "BMI percentile": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1012'
valueset "Counseling for Nutrition": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.195.12.1003'
valueset "Counseling for Physical Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1035'
valueset "Discharged to Health Care Facility for Hospice Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.209'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Height": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1014'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hospice care ambulatory": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1108.15'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
valueset "Preventive Care Services - Group Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Weight": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1015'

code "[in_i]": '[in_i]' from "UCUM" display 'inch (international)'
code "[lb_av]": '[lb_av]' from "UCUM" display 'pound (US and British)'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Body height": '8302-2' from "LOINC" display 'Body height'
code "Body mass index (BMI) [Ratio]": '39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'
code "Body weight": '29463-7' from "LOINC" display 'Body weight'
code "cm": 'cm' from "UCUM" display 'centimeter'
code "exam": 'exam' from "ObservationCategoryCodes" display 'exam'
code "g": 'g' from "UCUM" display 'gram'
code "kg": 'kg' from "UCUM" display 'kilogram'
code "vital-signs": 'vital-signs' from "ObservationCategoryCodes" display 'Vital Signs'
code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'
code "Wound Care": '3661000175108' from "SNOMEDCT" display 'Wound care service (qualifier value)'
code "Patient Counseled": '129441002' from "SNOMEDCT" display 'Counseling - action (qualifier value)'
code "Nutrition": '300893006' from "SNOMEDCT" display 'Nutritional finding (finding)'
code "Physical activity": '129861002' from "SNOMEDCT" display 'Physical activity finding (finding)'


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
  "Age at End of Measurement Period" in Interval[3, 17]
    and exists ( "Qualifying Encounter" )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists Hospice."Hospice Services"
    or exists ( "Pregnancy Diagnosis Which Overlaps Measurement Period" )

define "Pregnancy Diagnosis Which Overlaps Measurement Period":
  ( Status."Active Condition" ( [Condition: "Pregnancy"] ) ) Pregnancy
    where Coalesce( Pregnancy.onset, Pregnancy.recordedDate ) during day of "Measurement Period"

define "Numerator 1":
  exists ( "BMI Percentile in Measurement Period" )
    and exists ( "Height in Measurement Period" )
    and exists ( "Weight in Measurement Period" )

define "Numerator 2":
  exists ( "Nutrition Counseling" )

define "Numerator 3":
  exists ( "Physical Activity Counseling" )

define "Stratifaction 1":
  "Patient Age 3 to 11 Years at End of Measurement Period" is not null

define "Stratifaction 2":
  "Patient Age 12 to 17 Years at End of Measurement Period" is not null

define "Age at End of Measurement Period":
  AgeInYearsAt(date from end of "Measurement Period")

define "Patient Age 3 to 11 Years at End of Measurement Period":
  from "Age at End of Measurement Period" age 
    where age in Interval[3, 11]
  return age

define "Patient Age 12 to 17 Years at End of Measurement Period":
  from "Age at End of Measurement Period" age 
    where age in Interval[12, 17]
  return age

define "Qualifying Encounter":
  (( [Encounter] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  (["ServiceRequest": "Office Visit"]
    union ["ServiceRequest": "Preventive Care Services-Individual Counseling"]
    union ["ServiceRequest": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["ServiceRequest": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["ServiceRequest": "Preventive Care Services - Group Counseling"]
    union ["ServiceRequest": "Home Healthcare Services"]
    union ["ServiceRequest": "Telephone Visits"]
    ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management"))

define "Height in Measurement Period":
  [Observation: "Body height"] Height
    where Height.status in { 'final', 'amended', 'corrected' }
      and QICoreCommon."ToInterval" ( Height.effective ) during day of "Measurement Period"
      and Height.value is not null

define "Weight in Measurement Period":
  [Observation: "Body weight"] Weight
    where Weight.status in { 'final', 'amended', 'corrected' }
      and QICoreCommon."ToInterval" ( Weight.effective ) during day of "Measurement Period"
      and Weight.value is not null

define "BMI Percentile in Measurement Period":
  [Observation: "Body mass index (BMI) [Ratio]"] BMIPercentile
    where BMIPercentile.status in { 'final', 'amended', 'corrected' }
      and QICoreCommon."ToInterval" ( BMIPercentile.effective ) during day of "Measurement Period"
      and BMIPercentile.value is not null

define "Nutrition Counseling":
  (( Status."Completed Procedure" ( [Procedure: "Counseling for Nutrition"] ) ) NutritionCounseling
    where QICoreCommon."ToInterval" ( NutritionCounseling.performed ) during day of "Measurement Period")
  union
  (
    (([Observation: "Patient Counseled"]).isNutritionCouncel()) PatientCounsel
    where QICoreCommon."ToInterval" ( PatientCounsel.effective ) during day of "Measurement Period"
  )

define "Physical Activity Counseling":
  (( Status."Completed Procedure" ( [Procedure: "Counseling for Physical Activity"] ) ) ActivityCounseling
    where QICoreCommon."ToInterval" ( ActivityCounseling.performed ) during day of "Measurement Period")
  union
  (
    (([Observation: "Patient Counseled"]).isPhysicalActivityCouncel()) PatientCounsel
    where QICoreCommon."ToInterval" ( PatientCounsel.effective ) during day of "Measurement Period"
  )

define fluent function isNutritionCouncel(Obs List<Observation>):
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
      and (O.component is not null
      and exists (O.component C where C.value ~ "Nutrition")
      or O.component is null and O.value ~ "Nutrition")

define fluent function isPhysicalActivityCouncel(Obs List<Observation>):
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
      and (O.component is not null
      and exists (O.component C where C.value ~ "Physical activity")
      or O.component is null and O.value ~ "Physical activity")

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
